//
//  Define.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/12.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import Foundation
import UIKit

let IS_IOS7 = (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 7.0
let IS_IOS8 = (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0

let kMainScreenWidth = UIScreen.mainScreen().bounds.width
let kMainScreenHeight = UIScreen.mainScreen().bounds.height

//let fontName = "Hiragino Mincho ProN"

let fontName = "Helvetica"

let lightGreenColor = UIColor(red: 0.18, green: 0.82, blue: 0.80, alpha: 1.0)
let hightGreenColor = UIColor(red: 0.00, green: 0.9, blue: 0.79, alpha: 1.0)

let hostName = "http://api.xiaotei.com"

let functionViewHeight = 30


let IFLYAPPID = "56dc14e0"

//判断系统版本是否iOS8
func ios8() -> Bool{
    if ( NSFoundationVersionNumber >= NSFoundationVersionNumber10_8 ) {
        return true
    } else {
        return false
    }
}

func dateTypeStrFromDate(date:NSDate) -> String{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateTimeStr
    return dateFormatter.stringFromDate(date)
}

