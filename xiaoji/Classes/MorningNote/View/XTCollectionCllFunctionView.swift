//
//  XTCollectionCllFunctionView.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/20.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import Foundation

enum collectionEditType{
    case Add,End
}

typealias collectionFunctionClosure=(functionView:XTCollectionCellFunctionView,type:collectionEditType)->Void

class XTCollectionCellFunctionView: UIView {
    var closure:collectionFunctionClosure?
    
    func initWithClosure(closure:collectionFunctionClosure){
        self.closure = closure
    }
    
    
    var addButton:UIButton? = {
        var btn = UIButton()
        btn.setTitle("添加", forState: .Normal)
        btn.setTitleColor(lightGreenColor, forState: .Normal)
        btn.setTitleColor(hightGreenColor, forState: .Highlighted)
        return btn
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(addButton!)
        addButton?.addTarget(self, action: "addBtnClick:", forControlEvents: .TouchUpInside)
        
        addButton?.snp_makeConstraints(closure: { (make) -> Void in
            make.center.equalTo(self.snp_center)
            make.width.equalTo(50)
            make.height.equalTo(30)
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    func addBtnClick(btn:UIButton){
        print("add btn click")
        if closure != nil{
            closure!(functionView: self,type: .Add)
        }
    }
    
}
