//
//  XTNoteItemAddButtonCell.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/22.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

//点击添加按钮回调
typealias AddQuestionCellActionClosure=(cell:XTNoteItemAddButtonCell) -> Void

//添加按钮cell
class XTNoteItemAddButtonCell: UITableViewCell {

    var closure:AddQuestionCellActionClosure?
    
    func initWithClosure(closure:AddQuestionCellActionClosure){
        self.closure = closure
    }
    
    var addButton:UIButton? = {
        let button = UIButton()
        button.setTitle("添加", forState: .Normal)
        button.setTitleColor(lightGreenColor, forState: .Normal)
        button.setTitleColor(hightGreenColor, forState: .Highlighted)
        return button
    }()

    override func didMoveToSuperview() {
        self.commonInit()
    }
    
    func commonInit(){
        self.contentView.addSubview(addButton!)
        addButton?.addTarget(self, action: "addButtonClick:", forControlEvents: .TouchUpInside)
        addButton?.snp_makeConstraints(closure: { (make) -> Void in
            make.center.equalTo(self.contentView.snp_center)
            make.width.equalTo(self.contentView.snp_width).multipliedBy(0.33)
            make.height.equalTo(self.contentView.snp_height)
        })
    }
    
    func addButtonClick(btn:UIButton){
        if closure != nil{
            self.closure!(cell:self)
        }
    }
}
