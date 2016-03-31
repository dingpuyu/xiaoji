//
//  XTNoteItemEditController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/16.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//


class XTNoteItemEditController: XTBaseViewController {

    var noteItemContentView:XTNoteItemView = {
        let noteView = XTNoteItemView()
        return noteView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.hidesBottomBarWhenPushed = true
    }
    
    var titleModel:TitleModel?{
        didSet{
            self.view.addSubview(noteItemContentView)
            noteItemContentView.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view.snp_top)
                make.left.right.bottom.equalTo(self.view)
            }
            noteItemContentView.titleModel = titleModel
        }
    }
    
}
