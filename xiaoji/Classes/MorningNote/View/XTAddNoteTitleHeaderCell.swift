//
//  XTAddNoteTitleHeaderCell.swift
//  xiaoji
//
//  Created by xiaotei's on 16/3/23.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit


typealias AddNoteTitleHeaderClosure=(view:XTAddNoteTitleHeaderCell) -> Void

class XTAddNoteTitleHeaderCell: UITableViewHeaderFooterView {
    
    private var titleLabel:UILabel? = {
        var label = UILabel()
        label.text = "范围:"
        return label
    }()
    
    var textField:UITextField? = {
        var field = UITextField()
        field.placeholder = "请输入问题范围"
        return field
    }()
    

    override func didMoveToSuperview() {
        self.addSubview(titleLabel!)
        self.addSubview(textField!)
        
    
        titleLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self).offset(8)
            make.centerY.equalTo(self.snp_centerY)
            make.width.equalTo(50)
            make.height.equalTo(self.snp_height)
        })
        
        textField?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(titleLabel!.snp_right).offset(4)
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(self.snp_right).offset(-4)
            make.height.equalTo(self.snp_height)
        })
    }

}
