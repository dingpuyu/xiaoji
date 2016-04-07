//
//  XTSearchResultViewModel.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/7.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import Foundation

class XTSearchResultViewModel: NSObject {
    var questionStr:String! = ""
    var answerStr:String! = ""
    var questionLabelFont:UIFont! = UIFont(name: fontName, size: 16)
    var answerLabelFont:UIFont! = UIFont(name: fontName, size: 13)
    class func searchResultViewModelWith(model:NoteItemModel) -> XTSearchResultViewModel{
        let viewModel = XTSearchResultViewModel()
        viewModel.questionStr = model.question
        viewModel.answerStr = model.answer
        
        return viewModel
    }
}
