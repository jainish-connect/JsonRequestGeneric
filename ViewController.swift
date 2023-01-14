//
//  ViewController.swift
//  API-Demo
//
//  Created by Jainish Patel on 08/03/18.
//  Copyright © 2018 Jainish Patel. All rights reserved.
//


import UIKit

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        closure(no: 10) { (total) in
            print(total)
        }
        
        let button = UIButton(type: .system)
        button.setTitle("Test", for: .normal)
        button.sizeToFit()
        button.frame.origin = CGPoint(x: 50, y: 50)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        //sya
        //sfs
    }
    
    @objc func tapped(_ button:UIButton){
        let vc = TableVC(style: .plain)
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceRect = button.bounds
        vc.popoverPresentationController?.sourceView = button
        vc.popoverPresentationController?.delegate = self
        vc.preferredContentSize = CGSize(width: 300, height: 300)
        present(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alert = PickerView(title: "Select BD", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.data = ["Sample","Dog","Differ","Kite"]
        alert.onSelectItem = {(title,index) in
            print(title)
        }
        present(alert, animated: true)
        
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle{
        return .none
    }
    
    func closure(no:Int,total:@escaping ((_ total:Int)->Void)){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            total(no + no)
        }
        var res = abc()
        let str = res.1
    }
    func abc() -> (UIColor,String) {
        return (.red,"demo")
    }
    
    func copyFile(files:[String],index:Int,done:@escaping ()->Void){
        if(files.count>=index){
            //remove
            return
        }
        
        if(true){
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "yes", style: .default) { (_) in
                self.copyFile(files: files, index: index + 1, done: {
                    done()
                })
            }
        }else{
            //
            self.copyFile(files: files, index: index + 1, done: {
                done()
            })
        }
        
    }
    
}



class PickerView: UIAlertController,UIPickerViewDelegate,UIPickerViewDataSource {
    var onSelectItem : ((_ title:String,_ index:Int) -> Void)? = nil
    var data:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 115))
        pickerView.dataSource = self
        pickerView.delegate = self
        view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "OK", style: .default) { [unowned pickerView, unowned self] _ in
            let row = pickerView.selectedRow(inComponent: 0)
            if let onSelect = self.onSelectItem {
                onSelect(self.data[row], row)
            }
        }
        addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAction(cancelAction)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
}

class TableVC: UITableViewController{
    
}


