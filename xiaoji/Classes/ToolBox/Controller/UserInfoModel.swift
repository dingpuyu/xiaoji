//
//  UserInfoModel.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/15.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import Foundation

class UserInfoModel: NSObject {
    var nickName:String? = ""
    var signature:String? = ""
    var account:String? = ""
    var password:String? = ""
    var birthday:String? = ""
    var avatar:String? = ""
    
    
    func initWithJson(object:AnyObject)->Self{
        nickName = object.objectForKey("nickname") as? String
        signature = object.objectForKey("signature") as? String
        account = object.objectForKey("account") as? String
        password = object.objectForKey("password") as? String
        birthday = object.objectForKey("birthday") as? String
        avatar = object.objectForKey("avatar") as? String
        return self
    }
    
}
