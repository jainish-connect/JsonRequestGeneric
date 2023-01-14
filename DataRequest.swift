//
//  DataRequest.swift
//  API-Demo
//
//  Created by Jainish Patel on 08/03/18.
//  Copyright © 2018 Jainish Patel. All rights reserved.
//

import Foundation



enum Response<T:Codable> {
    case errorResponse(error:String?)
    case success(data:Data,model:T?)
    case failure(error:String,message:String)
}

enum HTTPMethods:String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
}

class DataRequest {
    
    static func request<T:Codable>(_: T.Type,url:String,
                                   method:HTTPMethods = .get,
                                   param:[String:Any]? = nil,
                                   completion:@escaping (Response<T>)->Void){
        
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        if let param = param{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error: "param error", message: error.localizedDescription))
                }
            }
        }
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let sessionConfig = URLSessionConfiguration.default
        let authValue: String = "Bearer \(UserData.token ?? "")"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authValue]
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let mError = error{
                let msg:String = {
                    if let err = mError as? URLError,
                        err.code == .notConnectedToInternet {
                        return Const.networkError
                    } else {
                        return Const.wentWrong
                    }
                }()
                DispatchQueue.main.async {
                    completion(.failure(error: mError.localizedDescription, message: msg))
                }
                
            }else if let mData = data{
                DispatchQueue.main.async {
                    do{
                        let info = try JSONDecoder().decode(Model<T>.self, from: mData)
                        if info.isError{
                            completion(Response.errorResponse(error: info.message))
                        }else{
                            completion(Response.success(data: mData, model: info.response))
                        }
                        
                    }catch(let error){
                        completion(.failure(error: error.localizedDescription, message: Const.wentWrong))
                    }
                    
                }
                
            }
        }
        task.resume()
    }
    
    /*static func requestForDictionary(url:String,
                                   method:HTTPMethods = .get,
                                   param:[String:Any]? = nil,
                                   completion:@escaping (Response<[String:Any]>)->Void){
        
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        if let param = param{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            } catch let error {
                DispatchQueue.main.async {
                   
                }
            }
        }
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let sessionConfig = URLSessionConfiguration.default
        let authValue: String = "Bearer \(UserData.token ?? "")"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authValue]
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let mError = error{
                let msg:String = {
                    if let err = mError as? URLError,
                        err.code == .notConnectedToInternet {
                        return Const.networkError
                    } else {
                        return Const.wentWrong
                    }
                }()
                DispatchQueue.main.async {
                    completion(.failure(error: mError.localizedDescription, message: msg))
                }
                
            }else if let mData = data{
                DispatchQueue.main.async {
                    do{
                        if let info = (try? JSONSerialization.jsonObject(with: mData, options: [])) as? [String: Any]{
                            
                        }
                        
                        let info = try JSONDecoder().decode(Model<T>.self, from: mData)
                        if info.isError{
                            completion(Response.errorResponse(error: info.message))
                        }else{
                            completion(Response.success(data: mData, model: info.response))
                        }
                        
                    }catch(let error){
                        completion(.failure(error: error.localizedDescription, message: Const.wentWrong))
                    }
                    
                }
                
            }
        }
        task.resume()
    }*/
}
