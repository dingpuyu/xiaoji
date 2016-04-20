//
//  DataService.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/7.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

typealias ActionResult=(success:Bool,message:String,code:Int)->Void
typealias ActionResultArrayClosure=(resultArray:[NoteItemModel])->Void
typealias UserInfoResultClosure=(resultModel:UserInfoModel)->Void
class DataService: NSObject {
    class  func shareInstance() -> DataService{
        struct Static{
            static var onceToken:dispatch_once_t? = 0
            static var instance:DataService? = nil
        }
        dispatch_once(&Static.onceToken!) { 
            Static.instance = DataService()
        }
        return Static.instance!
    }

    class func searchNoteWithText(text:String,callBack:ActionResultArrayClosure){
        if text == ""{
            callBack(resultArray:[])
            return
        }
        let db = XTDB.getDb()
        db.open()
        let sql = "SELECT * FROM ITEMTABLE WHERE ANSWER LIKE '%\(text)%'"
        

        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let rs = db.executeQuery(sql, withArgumentsInArray: [])
            
            var arrayM = [NoteItemModel]()
            while rs.next() {
                let model = NoteItemModel()
                model.itemID = Int(rs.intForColumn("ITEMID"))
                model.titleID = Int(rs.intForColumn("TITLEID"))
                model.sortNumber = Int(rs.intForColumn("SORTNUMBER"))
                model.type = Int(rs.intForColumn("TYPE"))
                model.question = rs.stringForColumn("QUESTION")
                model.answer = rs.stringForColumn("ANSWER")
                model.dateTime = rs.stringForColumn("DATETIME")
                arrayM.append(model)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                callBack(resultArray: arrayM)
            })
        }
        
        
    }
    
    
    func RequestUserInfo(resultCallBack:UserInfoResultClosure,failerCallBack:ActionResult) -> Void {
        Alamofire.request(.POST, "\(hostName)/userinfo.php", parameters: ["userid":XJUserDefault.sharedInstance.UserID()]).responseJSON { (request, response, result) in
            if result.isSuccess{
                let model = UserInfoModel()
                model.initWithJson((result.value?.objectForKey("data"))!)
                resultCallBack(resultModel: model)
            }else{
                failerCallBack(success: false, message: "网路错误", code: -1000)
            }
        }
    }
    //上传头像
    func uploadAvatar(image:UIImage,actionCallBack:ActionResult) -> Void{
        let imageData = UIImageJPEGRepresentation(image, 0.1);
        Alamofire.upload(.POST, "http://api.xiaotei.com/upload_file.php",headers:["HTTP_ACCOUNT":XJUserDefault.sharedInstance.UserAccount()] , data:imageData!)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                   
                }
            }
            .responseString { response in
                
                print("result:\(response.2.value)")
//                if(response.2.isSuccess){
//                    let success = response.2.value?.objectForKey("success") as! NSNumber
//                    let message = response.2.value?.objectForKey("message") as! String
//                    let code = response.2.value?.objectForKey("code") as! NSNumber
//                    actionCallBack(success: (success.boolValue), message: message, code: code.integerValue)
//                }else{
//                    actionCallBack(success: false, message: "网路错误", code: -1000)
//                }
        }
    }
    
}
