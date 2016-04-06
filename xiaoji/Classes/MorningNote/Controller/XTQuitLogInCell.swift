//
//  XTQuitLogInCell.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/6.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit


class XTQuitLogInCell: UITableViewCell {

    var closure:actionClosure?
    
    func initWithClosure(closure:actionClosure){
        self.closure = closure
    }
    
    @IBAction func QuitAction(sender: UIButton) {
        if self.closure != nil{
            closure!()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
