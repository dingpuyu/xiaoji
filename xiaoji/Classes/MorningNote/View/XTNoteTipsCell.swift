//
//  XTNoteTipsCell.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/12.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import SnapKit


//日记cell事件回调，删除，退出,保存
enum NoteCellEventType{
    case Delete,Quit,Save,Cancel,Voice
}


typealias noteCellActionClosure=(cellView:XTNoteTipsCell,model:TitleModel,type:NoteCellEventType) -> Void



class XTNoteTipsCell: UICollectionViewCell ,UITextViewDelegate{
    
    var functionView:XTNoteFunctionView = {
        var funcView = XTNoteFunctionView()
        return funcView
    }()
    
    lazy var itemContentView:XTNoteItemView = {
        var itemView = XTNoteItemView()
        return itemView
    }()
    
    var isFullScreen:Bool?{
        didSet{
             functionView.hidden = !isFullScreen!
             itemContentView.isFullScreen = isFullScreen
            
            var hightLightColor:Bool = false
            for model in self.titleModel.itemModelArray!{
                if model.answer.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0{
                    hightLightColor = true
                }
            }
        
            
            if isFullScreen == false && hightLightColor == false{
                titleLabel.textColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0)
            }else{
                 titleLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
            for textView in itemContentView.textViewArray!{
                textView.userInteractionEnabled = false
            }
            
             itemContentView.snp_updateConstraints { (make) -> Void in
                if isFullScreen == false{
                    make.bottom.equalTo(contentView.snp_bottom)
                }else{
                    make.bottom.equalTo(contentView.snp_bottom).offset(-functionViewHeight)
                }
            }
        }
    }
    
    var closure:noteCellActionClosure?
    
    var indexPath:NSIndexPath?
    
    var deleteButton:UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "set_btn_del_"), forState: .Normal)
        btn.setImage(UIImage(named: "set_btn_del_pre_"), forState: .Highlighted)
        return btn
    }()
    
    var isEdit:Bool?{
        willSet(newValue){
            

        }
        didSet{
            deleteButton.hidden = !isEdit! && !isFullScreen!

            deleteButton.snp_updateConstraints(closure: { (make) -> Void in
                if isEdit! == true{
                    make.width.equalTo(16)
                    make.height.equalTo(16.5)
                }else{
                    make.width.equalTo(16)
                    make.height.equalTo(0)
                }
            })
            UIView.animateWithDuration(0.35) { () -> Void in
                self.contentView.layoutIfNeeded()
            }

        }
    }
    
    var oldRect:CGRect?
    
    var titleModel:TitleModel = TitleModel(){
        didSet{
            
            self.contentView.addSubview(titleLabel)
            self.contentView.addSubview(saveButton)
            self.contentView.addSubview(deleteButton)
//            self.contentView.userInteractionEnabled = true
            deleteButton.hidden = !isEdit! && !isFullScreen!
            saveButton.hidden = !isFullScreen!
            saveButton.addTarget(self, action: #selector(XTNoteTipsCell.saveButtonClick(_:)), forControlEvents: .TouchUpInside)
            deleteButton.addTarget(self, action: #selector(XTNoteTipsCell.deleteButtonClick(_:)), forControlEvents: .TouchUpInside)
            titleLabel.snp_remakeConstraints(closure: { (make) -> Void in
                make.top.equalTo(deleteButton.snp_bottom)
                make.left.equalTo(self.contentView).offset(8)
                make.right.lessThanOrEqualTo(self.contentView).offset(-8)
                make.bottom.lessThanOrEqualTo(self.contentView.snp_bottom)
                
                if isFullScreen == false{
                    
                }
//                    make.height.equalTo(15)
            })

            saveButton.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo(self.contentView.snp_top).offset(4)
                make.right.equalTo(self.contentView.snp_right).offset(-8)
                make.width.equalTo(55)
                make.height.equalTo(18)
            }
        
            deleteButton.snp_remakeConstraints { (make) -> Void in
                make.top.left.equalTo(self.contentView).offset(1.5)
                make.width.equalTo(16)
                make.height.equalTo(0)
            }
            
            
            self.contentView.addSubview(itemContentView)
            self.contentView.addSubview(functionView)
//            functionView.userInteractionEnabled = true
            functionView.initWithClosure(functionViewClosure)

//
            
            itemContentView.titleModel = titleModel
            itemContentView.snp_remakeConstraints{ (make) -> Void in
                make.top.equalTo(titleLabel.snp_bottom)
                make.left.right.equalTo(self.contentView)
                make.bottom.equalTo(contentView.snp_bottom)
            }
            
            
            
            functionView.snp_remakeConstraints { (make) -> Void in
                make.left.right.equalTo(self.contentView)
//                make.top.equalTo(itemContentView.snp_bottom)
                make.bottom.equalTo(self.contentView.snp_bottom)
                make.height.equalTo(functionViewHeight)
            }

            
//            self.setNeedsDisplay()
        }
//        willSet{
//        }
    }
    var saveButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("保存", forState: .Normal)
        btn.setTitleColor(lightGreenColor, forState: .Normal)
        btn.setTitleColor(hightGreenColor, forState: .Highlighted)
        return btn
    }()
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont(name: fontName, size: fontSize)
        return label
    }()

    func saveButtonClick(sender: UIButton) {
        if closure != nil{
            isFullScreen = false
            saveButton.hidden = !isFullScreen!
            for i in 0..<(titleModel.itemModelArray?.count)!{
                let textView = itemContentView.textViewArray![i]
                let itemModel = titleModel.itemModelArray![i]
                if  itemModel.answer != textView.text{
                    itemModel.answer = textView.text
                    XTDB.updateItemWithItemModel(itemModel)
                }
            }
            
//            itemContentView.titleModel = titleModel
//            XTDB.insertItemWithItemModel(NoteItemModel(question: "我是谁?", answer: "一个逗比", type: 2, titleID:titleModel.titleID, dateTime: titleModel.dateTime, sortNumber: 0))
            self.closure!(cellView:self,model: titleModel,type: .Save)
            
        }
    }
    
    func deleteButtonClick(sender:UIButton){
        if closure != nil{
            isFullScreen = false
            saveButton.hidden = !isFullScreen!
            self.closure!(cellView:self,model: titleModel,type: .Delete)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isEdit = false
        isFullScreen = false
//        self.userInteractionEnabled = true
//        self.contentView.userInteractionEnabled = true
//        self.contentView.snp_makeConstraints { (make) -> Void in
//            make.edges.equalTo(self)
//        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(XTNoteTipsCell.keyboardWillChangeFrameNotification(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initWithClosure(closure:noteCellActionClosure){
        self.closure = closure
    }
    
    func moveToWindow() -> Void{
        self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + 64), size: self.frame.size)
        UIApplication.sharedApplication().keyWindow?.addSubview(self)

        isFullScreen = true
        [UIView.animateWithDuration(0.55) { () -> Void in
        self.frame = CGRect(x: 0, y: 22, width: kMainScreenWidth, height: kMainScreenHeight - 22)            
            self.itemContentView.editStatus = true
            UIApplication.sharedApplication().statusBarHidden = true
        }]
    }
    
    func functionViewClosure(view:XTNoteFunctionView,event:FunctionEventType){
        switch event{
        case .Return:
            itemContentView.endEditing(true)
            self.saveButtonClick(UIButton())
            break;
        case .Save:
            itemContentView.endEditing(true)
            break;
        case .Cancel:
            self.closure!(cellView:self,model: titleModel,type: .Cancel)
            break;
        case .Voice:
            self.closure!(cellView: self, model: titleModel, type: .Voice)
            break;
        default:
            break;
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        
//        titleLabel.font = UIFont(name: fontName, size: 14)
        titleLabel.text = titleModel.title
        
        saveButton.hidden = !isFullScreen!
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        isFullScreen = false

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
                make.bottom.equalTo(self.contentView.snp_bottom)
            }else{
                make.bottom.equalTo(self.contentView.snp_bottom).offset(-keyboardHeight)
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
            self.layoutIfNeeded()
        }
    }
    deinit {        // 控制器销毁时，移除消息通知监听(必须)
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

}
