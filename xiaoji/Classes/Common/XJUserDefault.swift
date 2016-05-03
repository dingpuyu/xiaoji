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
    
    func VoicePeople() -> String{
        let userdefault = NSUserDefaults.standardUserDefaults()
        var people = userdefault.stringForKey("voicePeople")
        if people == nil{
            people = "xiaoyan"
        }
        return people!
    }
    
    func setVoicePeople(name:String){
        let userdefault = NSUserDefaults.standardUserDefaults()
        userdefault.setValue(name, forKey: "voicePeople")
    }
    
    func voiceLanguage() -> String{
        let userdefault = NSUserDefaults.standardUserDefaults()
        var language = userdefault.stringForKey("voiceLanguage")
        if language == nil{
            language = CHINESE
        }
        return language!
    }
    
    func setVoiceLanguage(language:String){
        let userdefault = NSUserDefaults.standardUserDefaults()
        userdefault.setValue(language, forKey: "voiceLanguage")
    }
    
    func voiceFangYan() -> String {
        let userdefault = NSUserDefaults.standardUserDefaults()
        var fangYan = userdefault.stringForKey("voiceFangYan")
        if fangYan == nil{
            fangYan = PUTONGHUA
        }
        return fangYan!
    }
    
    func setFangYan(fangYan:String){
        let userdefault = NSUserDefaults.standardUserDefaults()
        userdefault.setValue(fangYan, forKey: "voiceFangYan")
    }
    
}
