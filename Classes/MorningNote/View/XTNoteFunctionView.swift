//
//  XTNoteFunctionView.swift
//  xiaoji
//
//  Created by xiaotei's on 16/3/17.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

enum FunctionEventType{
    case Return,Save,Cancel
}


typealias FunctionViweClosure=(funcView:XTNoteFunctionView,event:FunctionEventType) -> Void

class XTNoteFunctionView: UIView {

    var functionBtnArray:[UIButton]?
    
    var closure:FunctionViweClosure?
    
    func initWithClosure(closure:FunctionViweClosure){
        self.closure = closure
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let btn1 = UIButton()
        btn1.setTitle("返回", forState: .Normal)
        btn1.addTarget(self, action: "returnActionTouch:", forControlEvents: .TouchUpInside)

        self.addSubview(btn1)
        let btn2 = UIButton()
        btn2.setTitle("取消", forState: .Normal)
        btn2.addTarget(self, action: "cancelActionTouch:", forControlEvents: .TouchUpInside)
        self.addSubview(btn2)
        let btn3 = UIButton()
        btn3.addTarget(self, action: "saveActionTouch:", forControlEvents: .TouchUpInside)
        btn3.setTitle("确认", forState: .Normal)
        self.addSubview(btn3)
        btn1.setTitleColor(lightGreenColor, forState: .Normal)
        btn2.setTitleColor(lightGreenColor, forState: .Normal)
        btn3.setTitleColor(lightGreenColor, forState: .Normal)
        
        
        btn1.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(self.snp_left).offset(8)
            make.width.equalTo(50)
            make.height.equalTo(self.snp_height)
        }
        
        btn3.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.size.equalTo(btn1.snp_size)
        }
        
        btn2.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(self.snp_right).offset(-8)
            make.size.equalTo(btn1.snp_size)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func returnActionTouch(button:UIButton){
        if closure != nil{
            closure!(funcView: self,event: .Return)
        }
    }
    func cancelActionTouch(button:UIButton){
        if closure != nil{
            closure!(funcView: self,event: .Cancel)
        }
    }
    func saveActionTouch(button:UIButton){
        if closure != nil{
            closure!(funcView: self,event: .Save)
        }
    }
}
