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
import PKHUD

class XTUserInfoDetailController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nickNameField: UITextField!
    
    @IBOutlet weak var signatureField: UITextView!
    
    var userInfoModel:UserInfoModel?{
        didSet{
            avatarImageView.sd_setImageWithURL(NSURL(string: (userInfoModel?.avatar)!))
            nickNameField.text = userInfoModel?.nickName
            signatureField.text = userInfoModel?.signature
        }
    }
    
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
        
//        添加点击动作
        let gesture = UITapGestureRecognizer(target: self, action: #selector(presentPhotoCrawl))
        avatarImageView.userInteractionEnabled = true
        avatarImageView.addGestureRecognizer(gesture)
        
        let editBtn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(saveCurrentUserInfo))
        
        self.navigationItem.rightBarButtonItem = editBtn
    }
    
    func saveCurrentUserInfo() -> Void{
        let parameters = [
            "userid":XJUserDefault.sharedInstance.UserID(),
            "nickname":nickNameField.text!,
            "signature":signatureField.text!
        ]
        HUD.flash(.Progress)
        
        Alamofire.request(.POST, "\(hostName)/updateuserinfo.php", parameters: parameters as? [String : AnyObject]).responseJSON { (request, response, result) in
            if result.isSuccess{
                let message = result.value?.objectForKey("message") as! String
                HUD.flash(.Label(message))
            }else{
                HUD.flash(.Label("修改失败，请检查网路状况"))
            }
        }
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
    
    override func viewDidAppear(animated: Bool) {
        weak var weakSelf = self
        DataService.shareInstance().RequestUserInfo({ (resultModel) in
            weakSelf?.userInfoModel = resultModel
            
        }) { (success, message, code) in
            print(message);
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        DataService.shareInstance().uploadAvatar(image) { (success, message, code) in
            print(message);
        }
        self.avatarImageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}