//
//  XTSearchResultCell.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/7.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

class XTSearchResultCell: UITableViewCell {

    var viewModel:XTSearchResultViewModel?{
        didSet{
            questionLabel.font = viewModel?.questionLabelFont
            questionLabel.text = viewModel?.questionStr
            answerLabel.font = viewModel?.answerLabelFont
            answerLabel.text = viewModel?.answerStr
        }
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
