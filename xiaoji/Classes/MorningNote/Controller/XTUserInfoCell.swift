//
//  XTUserInfoCell.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/6.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import SDWebImage

class XTUserInfoCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var signatureLabel: UILabel!
    
    var userinfoModel: UserInfoModel? {
        didSet{
            avatarImageView.sd_setImageWithURL(NSURL(string: (userinfoModel?.avatar)!))
            nickNameLabel.text = userinfoModel?.nickName
            signatureLabel.text = userinfoModel?.signature
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
//        avatarImageView.setImageWithURL(<#T##url: NSURL!##NSURL!#>, placeholderImage: <#T##UIImage!#>)
        
    }
    
}
