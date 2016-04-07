//
//  XTnoteItemDetailController.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/5.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
// 晓记cell详情

import UIKit

class XTnoteItemDetailController: UIViewController {

    var noteImteView:XTNoteItemView?
    
    var functionView:XTNoteFunctionView! = {
        var view = XTNoteFunctionView()
        
        return view
    }()
    
    var titleModel:TitleModel?{
        didSet{
                noteImteView?.titleModel = titleModel
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: Selector("rightButtonClick"))
//        UIBarButtonItem(image: UIImage(named: "sound"), style: .Plain, target: self, action: )
        
        
        self.view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        // Do any additional setup after loading the view.
        noteImteView = XTNoteItemView()
        self.view.addSubview(noteImteView!)
        self.view.addSubview(functionView)
        noteImteView?.snp_makeConstraints(closure: { (make) -> Void in
            make.edges.equalTo(self.view.snp_edges)
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-functionViewHeight)
        })
    
        
        functionView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp_bottom)
            make.height.equalTo(functionViewHeight)
        }
        functionView.initWithClosure(functionViewClosure)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillChangeFrameNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        noteImteView?.titleModel = titleModel
    }
    
//    保存
    func rightButtonClick(){
//        for itemModel in (self.noteImteView!.titleModel?.itemModelArray)!{
//            XTDB.updateItemWithItemModel(noteImteView)
//        }
        for i in 0..<(self.noteImteView?.titleViewArray?.count)!{
            let model = self.noteImteView?.itemModelArray![i]
            model?.answer = (noteImteView?.textViewArray![i].text)!
            XTDB.updateItemWithItemModel(model!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func functionViewClosure(view:XTNoteFunctionView,event:FunctionEventType){
        switch event{
        case .Return:
            
            break;
        case .Save:
            
            break;
        case .Cancel:
            
            break;
        case .Voice:
            self.voiceAction()
            break;
        }
    }
    
    func voiceAction(){
        let voiceVC = XTVoiceServiceController()
        
        var speakStr = self.titleModel!.title
        for itemModel in self.titleModel!.itemModelArray!{
            speakStr += itemModel.question
            speakStr += itemModel.answer
        }
        
        voiceVC.speakString = speakStr
        
        self.navigationController?.presentViewController(voiceVC, animated: true, completion: nil)
    }

    
    func keyboardWillChangeFrameNotification(notification:NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo!
        let rect:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue)!
        
        let keyboardHeight:CGFloat = CGRectGetHeight(rect)
        let keyboardDuration:Double = (userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue)!
        //        let collectionRect = collectionView.frame
        //        collectionView.frame = CGRectMake(collectionRect.origin.x, 64 - keyboardHeight , collectionRect.size.width, collectionRect.height)
        //        self.snp_updateConstraints { (make) -> Void in
        //            //            make.bottom.equalTo(-keyboardHeight)
        //            print(keyboardHeight)
        //        }
        functionView.snp_updateConstraints{ (make) -> Void in
            if rect.origin.y == kMainScreenHeight{
                make.bottom.equalTo(self.view.snp_bottom)
            }else{
                make.bottom.equalTo(self.view.snp_bottom).offset(-keyboardHeight)
            }
            
            // Scroll the active text field into view.
        }
        //
        //        itemContentView.snp_remakeConstraints { (make) -> Void in
        //            make.top.equalTo(titleLabel.snp_bottom)
        //            make.left.right.equalTo(self.contentView)
        if rect.origin.y == kMainScreenHeight{
            //                make.bottom.equalTo(self.contentView.snp_bottom) //.offset(-15)
            //                        self.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight - 22)
        }else{
            //                make.bottom.equalTo(self.contentView.snp_bottom).offset(-100)
            //                        self.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight - keyboardHeight - 22)
        }
        //        }
        
        
        
        UIView.animateWithDuration(keyboardDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    deinit {        // 控制器销毁时，移除消息通知监听(必须)
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
}
