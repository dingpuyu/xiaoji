//
//  XTNoteFunctionView.swift
//  xiaoji
//
//  Created by xiaotei's on 16/3/17.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

enum FunctionEventType{
    case Return,Save,Cancel,Voice,Listen
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
        btn1.addTarget(self, action: #selector(XTNoteFunctionView.returnActionTouch(_:)), forControlEvents: .TouchUpInside)

        self.addSubview(btn1)
        let btn2 = UIButton()

        btn2.setTitle("播放", forState: .Normal)

        btn2.addTarget(self, action: #selector(XTNoteFunctionView.voiceActionTouch(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(btn2)
        let btn3 = UIButton()
        btn3.addTarget(self, action: #selector(XTNoteFunctionView.saveActionTouch(_:)), forControlEvents: .TouchUpInside)
        btn3.setTitle("确认", forState: .Normal)
        self.addSubview(btn3)
        let btn4 = UIButton()
        btn4.setTitle("语音", forState: .Normal)
        btn4.addTarget(self, action: #selector(listenAction(_:)), forControlEvents: .TouchUpInside)
        
        self.addSubview(btn4)
        btn1.setTitleColor(lightGreenColor, forState: .Normal)
        btn2.setTitleColor(lightGreenColor, forState: .Normal)
        btn3.setTitleColor(lightGreenColor, forState: .Normal)
        btn4.setTitleColor(lightGreenColor, forState: .Normal)
        
        btn1.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left)
            make.top.bottom.equalTo(self)
            make.right.equalTo(btn2.snp_left)
            make.width.equalTo(btn2.snp_width)

        }
        btn2.snp_makeConstraints { (make) in
            make.left.equalTo(btn1.snp_right)
            make.top.bottom.equalTo(self)
            make.right.equalTo(btn3.snp_left)
            make.width.equalTo(btn3.snp_width)
        }
        btn3.snp_makeConstraints { (make) in
            make.left.equalTo(btn2.snp_right)
            make.top.bottom.equalTo(self)
            make.right.equalTo(btn4.snp_left)
            make.width.equalTo(btn4.snp_width)
        }
        btn4.snp_makeConstraints { (make) in
            make.left.equalTo(btn3.snp_right)
            make.top.bottom.equalTo(self)
            make.right.equalTo(self.snp_right)
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
    func voiceActionTouch(button:UIButton){
        if closure != nil{
            closure!(funcView: self, event: .Voice)
        }
    }
    func listenAction(button:UIButton) {
        if closure != nil{
            closure!(funcView:self,event:.Listen)
        }
    }
}
