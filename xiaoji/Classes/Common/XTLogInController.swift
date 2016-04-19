//
//  XTLogInController.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/5.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import ReactiveCocoa
import PKHUD
import Alamofire

let isLogInKey = "UserIsLogIn"

class XTLogInController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logInButton.enabled = false
        userNameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidUserName(value:String) -> Bool{
        return value.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
    }
    
    func isValidPassword(value:String) -> Bool{
        return value.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) >= 6
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var userName:String = userNameTextField.text!
        var password:String = passwordTextField.text!

        
        
        if textField.tag == 1000{
            userName += string
            
            if string == ""{
                let index = userName.endIndex.advancedBy(-1)
                userName = userName.substringToIndex(index)
            }
        }else {
           password += string
            if string == ""{
                let index = password.endIndex.advancedBy(-1)
                password = password.substringToIndex(index)
            }
        }
        
        self.logInButton.enabled = self.isValidUserName(userName) && self.isValidPassword(password)
        return true
    }
    
    
    @IBAction func LogInButtonClick(sender: AnyObject) {
        HUD.show(.Label("登陆中..."))
        weak var weakSelf = self
        
        let parameters = [
            "account":userNameTextField.text!,
            "password":passwordTextField.text!.md5()!
            ]
    
        print(passwordTextField.text!.md5())
        
        Alamofire.request(.POST, "http://api.xiaotei.com/login.php", parameters: parameters).responseJSON { response in
            if(response.2.isSuccess){
//                let message = response.2.value!["message"]! as! String
                let json:AnyObject = response.2.value!
                let message = json.objectForKey("message") as! String
                let success = json.objectForKey("success") as! NSNumber
                print("success:\(success)")
                if success.boolValue == true{
                    let userid = json.objectForKey("userid") as! NSNumber
                    XJUserDefault.sharedInstance.setLogIn(true)
                    XJUserDefault.sharedInstance.setUserID(userid.integerValue)
                
                    weakSelf?.dismissViewControllerAnimated(true, completion: {
                    })
                }
                HUD.flash(.Label(message), delay: 1.5)
            }else{
                HUD.flash(.Label("收到消息"), delay: 1.5);
            }
            
//            print(response.2.value)
//            HUD.flash(.Label("收到消息"), delay: 1.5);
        
        }
//        XTSignInService.signInWithUserName(userNameTextField.text, passWord: passwordTextField.text) { (status:Bool) -> Void in
//            if status == true{
//                HUD.flash(.Label("登陆成功！"), delay: 1.5)
//                weakSelf?.dismissViewControllerAnimated(true, completion: nil)
//                let userDefaluts = NSUserDefaults.standardUserDefaults()
//                userDefaluts.setBool(true, forKey: isLogInKey)
//            }else{
//                HUD.flash(.Label("账号或密码错误！"), delay: 1.5)
//            }
//        }
        
    }
    

    
    
}
