//
//  XTUserInfoDetailView.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/15.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import Foundation
import SDWebImage
import Alamofire
class XTUserInfoDetailController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nickNameField: UITextField!
    
    @IBOutlet weak var signatureField: UITextView!
    
    override func viewDidLoad() {
    
        let parameters = ["userid":XJUserDefault.sharedInstance.UserID()];
        
        Alamofire.request(.POST, "http://api.xiaotei.com/userinfo.php", parameters:parameters).responseJSON{ response  in
            let json = response.2.value!
            if response.2.isSuccess == true{
                let success = json.objectForKey("success")
                if success?.boolValue == true{
                    let usermodel = UserInfoModel()
                    usermodel.initWithJson(json.objectForKey("data")!)
                    
                    print("nickname:\(usermodel.nickName)\n")
                }
            }
        }
        let fileURL = NSBundle.mainBundle().URLForResource("logInScreen", withExtension: "png")
        Alamofire.upload(.POST, "http://api.xiaotei.com/upload_file.php",headers:["HTTP_ACCOUNT":"2842668307@qq.com"] , file: fileURL!)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes written on main queue: \(totalBytesWritten)")
                }
            }
            .responseString { response in
                debugPrint(response)
            }
        
        
//        添加点击动作
        let gesture = UITapGestureRecognizer(target: self, action: #selector(presentPhotoCrawl))
        avatarImageView.userInteractionEnabled = true
        avatarImageView.addGestureRecognizer(gesture)
    }
    
    func presentPhotoCrawl(){
        let iPC = UIImagePickerController()
        iPC.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        iPC.delegate = self
        presentViewController(iPC, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("取消选择图片操作")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.avatarImageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}









/*
 <!DOCTYPE html>
 <html>
 <head>
	<meta http-equiv="Content-Type" content="text/html;charset=utf8";>
	<title></title>
 </head>
 <body>
 <form method='POST' action="<?php echo $_SERVER['PHP_SELF'];?>">
 <input type="text" name="userid">
 <input type="submit"  name="submit" value="查询">
 </form>
 
 
 </body>
 </html>
 

 */