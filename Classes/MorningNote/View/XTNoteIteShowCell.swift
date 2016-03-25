//
//  XTNoteIteShowCell.swift
//  xiaoji
//
//  Created by xiaotei's on 16/3/24.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

class XTNoteItemShowCell: UITableViewCell {

    var noteItemModel:NoteItemModel?{
        didSet{
            self.questionLabel?.text = noteItemModel?.question
            self.answerLabel?.text  = noteItemModel?.answer
            questionLabel?.snp_remakeConstraints(closure: { (make) -> Void in
                make.left.top.equalTo(self.contentView).offset(3.5)
                make.right.lessThanOrEqualTo(self.contentView.snp_right)
                make.height.equalTo(18)
            })
            
            answerLabel?.snp_remakeConstraints(closure: { (make) -> Void in
                make.left.equalTo((questionLabel?.snp_left)!)
                make.top.equalTo((questionLabel?.snp_bottom)!).offset(4)
                make.right.equalTo(self.contentView.snp_right).offset(-3.5)
            })
        }
    }
    
    var questionLabel:UILabel? = {
        var label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var answerLabel:UILabel? = {
        var label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       commonInit()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }  
    
//    初始化操作
    func commonInit(){
        self.contentView.addSubview(questionLabel!)
        self.contentView.addSubview(answerLabel!)
        
        questionLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.top.equalTo(self.contentView).offset(3.5)
            make.right.lessThanOrEqualTo(self.contentView.snp_right)
            make.height.equalTo(18)
        })
        
        answerLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo((questionLabel?.snp_left)!)
            make.top.equalTo((questionLabel?.snp_bottom)!).offset(4)
            make.right.equalTo(self.contentView.snp_right).offset(-3.5)
        })
        
    }
    
    
    class func heightWithModel(itemModel:NoteItemModel) -> CGFloat {
        let noteCell = XTNoteItemShowCell(style: .Default, reuseIdentifier: "");
        noteCell.noteItemModel = itemModel
        noteCell.layoutIfNeeded()
        return noteCell.answerLabel!.frame.size.height + 21.5
    }

}
