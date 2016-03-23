//
//  XTAddNoteQuestionCell.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/22.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

enum QuestionCellEventType{
    case Edit,Delete
}

typealias AddNoteQuestionCellDeleteClosure=(cell:XTAddNoteQuestionCell,type:QuestionCellEventType) -> Void

class XTAddNoteQuestionCell: UITableViewCell ,UITextFieldDelegate{
    
    var indexPath:NSIndexPath?
    
    private var closure:AddNoteQuestionCellDeleteClosure?
    
    var tipsLabel:UILabel? = {
        let label = UILabel()
        label.text = "问题:"
        return label
    }()
    
    var textField:UITextField?={
       let field = UITextField()
        field.placeholder = "请输入您的问题！"
        field.returnKeyType = .Done
        return field
    }()
    
    var deleteBtn:UIButton? = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "set_btn_del_"), forState: .Normal)
        btn.setImage(UIImage(named: "set_btn_del_pre_"), forState: .Highlighted)
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    func initWithClosure(closure:AddNoteQuestionCellDeleteClosure){
        self.closure = closure
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit(){
        self.contentView.addSubview(tipsLabel!)
        self.contentView.addSubview(textField!)
//        self.contentView.addSubview(deleteBtn!)
        textField?.delegate = self
        deleteBtn?.addTarget(self, action: "deleteBtnClick:", forControlEvents: .TouchUpInside)
        tipsLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self.contentView.snp_left).offset(8)
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.width.equalTo(50)
            make.height.equalTo(18)
        })
        
        
        textField?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(tipsLabel!.snp_right).offset(4)
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.height.equalTo(self.contentView.snp_height)
            make.right.equalTo(self.contentView.snp_right).offset(-4)
        })
    }

    func deleteBtnClick(btn:UIButton){
        if closure != nil{
            closure!(cell: self,type: .Delete)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if closure != nil{
            closure!(cell: self, type: .Edit)
        }
    }
}
