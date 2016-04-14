//
//  XJRegisterController.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/14.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import Foundation
import Alamofire
import PKHUD

class XJRegisterController: UIViewController {
    @IBOutlet weak var nickNameField: UITextField!
    
    @IBOutlet weak var accountField: UITextField!
    
    @IBOutlet weak var password1Field: UITextField!
    
    @IBOutlet weak var password2Field: UITextField!
    
    
    override func viewDidLoad() {
//        self.view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0);
    }
    
    @IBAction func registerAction(sender: UIButton) {
        
        weak var weakSelf = self
        
        let parameters = [
            "nickname":nickNameField.text!,
            "account":accountField.text!,
            "password1":password1Field.text!.md5()!,
            "password2":password2Field.text!.md5()!
        ]
        
        Alamofire.request(.POST, "http://localhost/register.php", parameters: parameters).responseString { response in
            if(response.2.isSuccess){
                //                let message = response.2.value!["message"]! as! String
                let json:AnyObject = response.2.value!
                let message = json.objectForKey("message") as! String
                let success = json.objectForKey("success") as! NSNumber
                print("success:\(success)")
                if success.boolValue == true{
                    weakSelf?.dismissViewControllerAnimated(true, completion: nil)
//                    let userDefaluts = NSUserDefaults.standardUserDefaults()
//                    userDefaluts.setBool(true, forKey: isLogInKey)
                }
                HUD.flash(.Label(message), delay: 1.5)
            }else{
                HUD.flash(.Label("收到消息"), delay: 1.5);
                print(response.2.value)
            }
            
            //            print(response.2.value)
            //            HUD.flash(.Label("收到消息"), delay: 1.5);
            
        }
    
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
