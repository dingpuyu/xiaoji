//
//  XTGroupTitleView.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/5/2.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import Foundation
import SnapKit

class XTGroupTitleView: UITableViewHeaderFooterView {
    var titleLabel:UILabel = UILabel()
    
    override func didMoveToSuperview() {
        self.addSubview(titleLabel)
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
    }
    
    
    
    
}
