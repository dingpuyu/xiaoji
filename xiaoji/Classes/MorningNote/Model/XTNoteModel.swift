//
//  XTNoteModel.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/13.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

class TitleModel : NSObject{
    var titleID:Int = 0
    var title:String = ""
    var subTitle:String = ""
    var sortNumber:Int = 0
    var type:Int = 0
    var dateTime:String = ""
    var itemModelArray:[NoteItemModel]?
    
    func describe()-> String{
        return "titleID:\(titleID),title:\(title),subtitle:\(subTitle),sortNumber:\(sortNumber),type:\(type),dateTime:\(dateTime)"
    }
    override init() {
        super.init()
        itemModelArray = []
    }
    init(title:String,subtitle:String,sortNumber:Int,type:Int,dateTime:String){
        super.init()    
        self.title = title
        self.subTitle = subtitle
        self.sortNumber = sortNumber
        self.type = type
        self.dateTime = dateTime
    }
};

class NoteItemModel : NSObject{
    var itemID:Int = 0
    var question:String = ""
    var answer:String = ""
    var type:Int = 2
    var titleID:Int = 0
    var dateTime:String = ""
    var sortNumber:Int = 0
    
    override init(){
        super.init()
    }
    
    init(question:String,answer:String,type:Int,titleID:Int,dateTime:String,sortNumber:Int) {
        super.init()
        self.question = question
        self.answer = answer
        self.type = type
        self.titleID = titleID
        self.dateTime = dateTime
        self.sortNumber = sortNumber
    }
}
