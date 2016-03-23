//
//  XTNoteCollectionReusableView.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/12.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

typealias actionClosure=()->Void

class XTNoteCollectionReusableView: UICollectionReusableView {

    var myClosure:actionClosure?
    @IBAction func actionButtonClick(sender: AnyObject) {
        
        if (myClosure != nil){
            myClosure!()
        }
    }
    
    func initWithClosure(closure:actionClosure){
        myClosure = closure
    }
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
