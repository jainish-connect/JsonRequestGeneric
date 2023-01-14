//
//  Model.swift
//  API-Demo
//
//  Created by Jainish Patel on 08/03/18.
//  Copyright © 2018 Jainish Patel. All rights reserved.
//

import Foundation

import Foundation
struct Model<T: Decodable>: Decodable {
    let isError: Bool
    let message: String?
    let response:T?
    enum  CodingKeys:String, CodingKey{
        case isError,message,response
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isError = (try? values.decode(Bool.self, forKey: .isError)) ?? true
        message = try? values.decode(String.self, forKey: .message)
        response = try? values.decode(T.self, forKey: .response)
    }
}

