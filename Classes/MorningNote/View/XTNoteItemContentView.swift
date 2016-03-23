//
//  XTNoteItemView.swift
//  xiaoji
//
//  Created by xiaotei's on 16/3/16.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import SnapKit

let fontSize:CGFloat = 15.0

class XTNoteItemView: UIView,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate{
    
    private var  firstTextView:UITextView?
    
    private var editingTextView:UITextView?

    private var oldContentOffsetY:CGFloat? = 0.0
    
    var textViewArray:[UITextView]? = []
    var titleViewArray:[UILabel]? = []
    
    var editStatus:Bool?{
        didSet{
            if editStatus == true{
                
//                firstTextView?.becomeFirstResponder()
            }else{
//                firstTextView?.endEditing(true)
            }
            
        }
    }
    
    var isFullScreen:Bool?{
        didSet{
            for i in 0..<(textViewArray?.count)!{
                let view = textViewArray![i]
                let titleView = titleViewArray![i]
                view.snp_updateConstraints(closure: { (make) -> Void in
                    if isFullScreen == true{
                        make.height.equalTo(50)
                    }else{
                        make.height.equalTo(15)
                    }
                })
                if isFullScreen == true{
                    titleView.textColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1.0)
                }else{
                    titleView.textColor = UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 1.0)
                }
            }
            
        }
    }
    
    private var scrollView:UIScrollView!
    private var contentView:UIView!
    
    var titleModel:TitleModel?{
        didSet{
            for view in self.subviews{
                view.removeFromSuperview()
            }
            
            self.itemModelArray = titleModel?.itemModelArray
            
        }
    }
    
    var itemModelArray:[NoteItemModel]?{
        didSet{
            
            
            
            scrollView = UIScrollView()
            scrollView.delegate = self
            scrollView.backgroundColor = UIColor.clearColor()
            contentView = UIView()
            contentView.backgroundColor = UIColor.clearColor()
            
            if itemModelArray == nil || itemModelArray?.count <= 0{
                return
            }

            self.addSubview(scrollView!)
            scrollView.addSubview(contentView)
            self.userInteractionEnabled = true
            scrollView.snp_remakeConstraints{ (make) -> Void in
                make.edges.equalTo(self)
            }
            
            contentView.snp_remakeConstraints { (make) -> Void in
                make.edges.equalTo(scrollView)
                make.width.equalTo(self.scrollView.snp_width)
            }
            
//            let titleLabel = UILabel()
//            contentView.addSubview(titleLabel)
            
//            titleLabel.snp_remakeConstraints { (make) -> Void in
//                make.top.equalTo(contentView.snp_top)
//                make.left.right.equalTo(contentView)
//                make.height.greaterThanOrEqualTo(15)
//            }
//            titleLabel.text = titleModel?.title
            if itemModelArray?.count <= 0{
                if titleModel == nil{
                    return
                }
            
                return
            }
//            XTDB.insertItemWithItemModel(NoteItemModel(question: "我是谁aaaaaaaaa?", answer: "一般是在 Finder 中删除了文件而不是在15:05:05.210 xiaoji[25283:284101] Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.", type: 2, titleID:titleModel!.titleID, dateTime: titleModel!.dateTime, sortNumber: 0))
            var model = itemModelArray![0]
            var label = UILabel()
            label.font = UIFont(name: fontName, size: 14)
            label.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
            var lastTextView = UITextView()
            textViewArray = []
            textViewArray?.append(lastTextView)
            titleViewArray = []
            titleViewArray?.append(label)
            lastTextView.backgroundColor = UIColor.whiteColor()
            label.userInteractionEnabled = true
            lastTextView.delegate = self
//            lastTextView.delegate = self
            self.contentView.addSubview(label)
            self.contentView.addSubview(lastTextView)
            
            lastTextView.userInteractionEnabled = true
            lastTextView.sizeToFit()
            lastTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
            lastTextView.layer.borderWidth = 0.5
            
            label.numberOfLines = 0
            label.sizeToFit()
            
            label.text = "\(model.question):"
            lastTextView.text = model.answer
            lastTextView.scrollsToTop = true
            firstTextView = lastTextView
            
            label.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo(contentView.snp_top)
                make.left.equalTo(contentView.snp_left).offset(8)
                make.right.equalTo(contentView.snp_right).offset(-8)
                make.bottom.equalTo(lastTextView.snp_top)
            }
            
            lastTextView.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo(label.snp_bottom)
                make.left.equalTo(contentView.snp_left).offset(8)
                make.right.equalTo(contentView.snp_right).offset(-8)
                make.height.equalTo(50)
                if itemModelArray?.count == 1{
                    make.bottom.lessThanOrEqualTo(contentView.snp_bottom)
                }
            }
            
            for i in 1..<itemModelArray!.count{
                model = itemModelArray![i]
                label = UILabel()
                titleViewArray?.append(label)
                label.font = UIFont(name: fontName, size: 14)
                label.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
                label.numberOfLines = 0
                label.sizeToFit()
                let textView = UITextView()
                textView.backgroundColor = UIColor.whiteColor()
                textView.delegate = self
                textView.sizeToFit()
                contentView.addSubview(label)
                contentView.addSubview(textView)
                label.text = "\(model.question):"
                textView.text = model.answer
                label.snp_remakeConstraints(closure: { (make) -> Void in
                    make.left.equalTo(contentView.snp_left).offset(8)
                    make.right.equalTo(contentView.snp_right).offset(-8)
                    make.top.equalTo(lastTextView.snp_bottom)
                    make.bottom.equalTo(textView.snp_top)
                })
                
                textView.snp_remakeConstraints(closure: { (make) -> Void in
                    make.top.equalTo(label.snp_bottom)
                    make.left.equalTo(contentView.snp_left).offset(8)
                    make.right.equalTo(contentView.snp_right).offset(-8)
                    make.height.equalTo(50)
                    if i == (itemModelArray?.count)! - 1{
                        make.bottom.equalTo(contentView.snp_bottom)
                    }else{
                        
                    }
                })
                
                lastTextView = textView
                textViewArray?.append(lastTextView)
                lastTextView.userInteractionEnabled = true
            lastTextView.scrollsToTop = true
                lastTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
                lastTextView.layer.borderWidth = 0.5
            }
        }
    }
    
   override init(frame: CGRect) {
        super.init(frame: frame)
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillChangeFrameNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        return true
    }
    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n"{
//            textView.endEditing(true)
//            return false
//        }
//        return true
//    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
//        contentView =
//        self.addSubview(self.contentView)

    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.endEditing(true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        oldContentOffsetY = scrollView.contentOffset.y
    }
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        editingTextView = textView
        return true
    }
    
    func keyboardWillChangeFrameNotification(notification:NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo!
        let rect:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue)!
        
//        let keyboardHeight:CGFloat = CGRectGetHeight(rect)
        let keyboardDuration:Double = (userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue)!
        
        if rect.origin.y == kMainScreenHeight{
            scrollView.contentOffset = CGPointMake(0, oldContentOffsetY!)
            oldContentOffsetY = scrollView.contentOffset.y            
        }else{
            if editingTextView == nil{
                return
            }
            let textViewY:CGFloat = CGRectGetMaxY((editingTextView?.frame)!) - scrollView.contentOffset.y + self.frame.origin.y + 22 + CGFloat(functionViewHeight)
            let distance:CGFloat = rect.origin.y - textViewY
            
            if distance >= 0.0{
                return
            }
            
            oldContentOffsetY = scrollView.contentOffset.y
            scrollView.contentOffset = CGPointMake(0, -distance + scrollView.contentOffset.y)
        }
        
        
        

        UIView.animateWithDuration(keyboardDuration) { () -> Void in
            self.layoutIfNeeded()
        }
    }
    deinit {        // 控制器销毁时，移除消息通知监听(必须)
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

}
