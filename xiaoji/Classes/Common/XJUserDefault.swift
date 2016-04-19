//
//  XJUserDefault.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/15.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import Foundation



class XJUserDefault: NSObject {
    static let sharedInstance = XJUserDefault()
    
    func isLogIn() -> Bool {
        let userdefault = NSUserDefaults.standardUserDefaults()
        return userdefault.boolForKey(isLogInKey)
    }
    
    func setLogIn(status:Bool){
        let userdefault = NSUserDefaults.standardUserDefaults()
        return userdefault.setBool(status, forKey: isLogInKey)
    }
    
    func UserAccount() -> String{
        let userdefault = NSUserDefaults.standardUserDefaults()
        return userdefault.stringForKey("userAccount")!
    }
    
    func setUserAccount(account:String){
        let userdefault = NSUserDefaults.standardUserDefaults()
        userdefault.setValue(account, forKey: "userAccount")
    }
    
    func UserID() -> Int{
        let userdefault = NSUserDefaults.standardUserDefaults()
        return userdefault.integerForKey("userid")
    }
    
    func setUserID(id:Int){
        let userdefault = NSUserDefaults.standardUserDefaults()
        userdefault.setInteger(id, forKey: "userid")
    }
    
}
