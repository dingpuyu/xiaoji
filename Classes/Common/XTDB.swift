//
//  XTDB.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/12.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

private let dateFormatter = "yyyy-MM-dd HH:mm:ss"

class XTDB: NSObject {

    class func getDb()->FMDatabase{
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        let databasePath = docsDir.stringByAppendingString(
        "/xjnotedb.db")
        if !filemgr.fileExistsAtPath(databasePath) {
            let db = FMDatabase(path: databasePath)
            if db == nil {
                print("Error: \(db.lastErrorMessage())")
            }
            if db.open() {
                var sql_stmt = "CREATE TABLE IF NOT EXISTS TITLETABLE(TITLEID INTEGER PRIMARY KEY autoincrement, SORTNUMBER INTEGER, TYPE INTEGER,TITLE TEXT, SUBTITLE TEXT,DATETIME TEXT)"
                if !db.executeStatements(sql_stmt) {
                    print("Error: \(db.lastErrorMessage())")
                }
                sql_stmt = "CREATE TABLE IF NOT EXISTS ITEMTABLE(ITEMID INTEGER PRIMARY KEY autoincrement, SORTNUMBER INTEGER, TYPE INTEGER,QUESTION TEXT, ANSWER TEXT,DATETIME TEXT,TITLEID INTEGER)"
                if !db.executeStatements(sql_stmt) {
                    print("Error: \(db.lastErrorMessage())")
                }
                db.close()
            } else {
                print("Error: \(db.lastErrorMessage())")
            }
        }
        let feedDb = FMDatabase(path: databasePath)
        return feedDb
    }
    
//标题相关数据表操作
    class func insertTitle(model:TitleModel){
        let sql="INSERT INTO TITLETABLE(SORTNUMBER,TYPE,TITLE,SUBTITLE,DATETIME) "+"VALUES(?,?,?,?,?)"
        let db = XTDB.getDb()
        db.open()
        
        db.executeUpdate(sql, withArgumentsInArray: [self.titleCountWithTimeStr(model.dateTime),model.type,model.title,model.subTitle,model.dateTime])
        db.close()
    }
    
    class func removeTitle(id:Int){
        let sql = "DELETE FROM TITLETABLE WHERE TITLEID = ?"
        let sql2 = "DELETE FROM ITEMTABLE WHERE TITLEID = ?"
        let db = XTDB.getDb()
        db.open()
        db.executeUpdate(sql, withArgumentsInArray: [id])
        db.executeUpdate(sql2, withArgumentsInArray: [id])
        db.close()
    }
    
    class func selectTitleWithID(id:Int)->TitleModel?{
        let sql = "SELECT * FROM TITLETABLE WHERE TITLEID = ?"
        let db = XTDB.getDb()
        db.open()
        let rs = db.executeQuery(sql, withArgumentsInArray: [id])
        let model = TitleModel()
        while rs.next() {
            model.titleID = Int(rs.intForColumn("TITLEID"))
            model.sortNumber = Int(rs.intForColumn("SORTNUMBER"))
            model.type = Int(rs.intForColumn("TYPE"))
            model.title = rs.stringForColumn("TITLE")
            model.subTitle = rs.stringForColumn("SUBTITLE")
            model.dateTime = rs.stringForColumn("DATETIME")
        }
        db.close()
        return model    
    }
    
    class func selectTitleWithTitle(title:String)->TitleModel?{
        let sql = "SELECT * FROM TITLETABLE WHERE TITLE = ?"
        let db = XTDB.getDb()
        db.open()
        let rs = db.executeQuery(sql, withArgumentsInArray: [title])
        let model = TitleModel()
        while rs.next() {
            model.titleID = Int(rs.intForColumn("TITLEID"))
            model.sortNumber = Int(rs.intForColumn("SORTNUMBER"))
            model.type = Int(rs.intForColumn("TYPE"))
            model.title = rs.stringForColumn("TITLE")
            model.subTitle = rs.stringForColumn("SUBTITLE")
            model.dateTime = rs.stringForColumn("DATETIME")
        }
        db.close()
        return model
    }
    
    class func updateTitleSortNumberWith(id:Int,sortNumber:Int) {
        let sql = "UPDATE TITLETABLE SET SORTNUMBER=? WHERE TITLEID=?"
        
        let db = XTDB.getDb()
        db.open()
        db.executeUpdate(sql, withArgumentsInArray: [sortNumber,id])
        db.close()
    }
    
    class func selectTitleWithDateTime(time:String)->[TitleModel]?{
        let sql = "SELECT * FROM TITLETABLE WHERE DATETIME = ?"
        let db = XTDB.getDb()
        db.open()
        let rs = db.executeQuery(sql, withArgumentsInArray: [time])
        var arrayM = [TitleModel]()
        while rs.next() {
            let model = TitleModel()
            model.titleID = Int(rs.intForColumn("TITLEID"))
            model.sortNumber = Int(rs.intForColumn("SORTNUMBER"))
            model.type = Int(rs.intForColumn("TYPE"))
            model.title = rs.stringForColumn("TITLE")
            model.subTitle = rs.stringForColumn("SUBTITLE")
            model.dateTime = rs.stringForColumn("DATETIME")
            arrayM.append(model)
        }
        db.close()
        arrayM.sortInPlace { (model1:TitleModel, model2:TitleModel) -> Bool in
            return model1.sortNumber < model2.sortNumber
        }
        return arrayM
    }

    class func insertItemWithItemModel(itemModel:NoteItemModel) -> Bool{
        let sql="INSERT INTO ITEMTABLE(SORTNUMBER, TYPE,QUESTION, ANSWER,DATETIME,TITLEID) "+"VALUES(?,?,?,?,?,?)"
        let db = XTDB.getDb()
        db.open()
        
       let success = db.executeUpdate(sql, withArgumentsInArray: [self.itemCountWithTitleID(itemModel.titleID),2,itemModel.question,itemModel.answer,itemModel.dateTime,itemModel.titleID])
        db.close()
        return success
    }
    
    class func removeItem(id:Int){
        let sql = "DELETE FROM ITEMTABLE WHERE ITEMID = ?"
        let db = XTDB.getDb()
        db.open()
        db.executeUpdate(sql, withArgumentsInArray: [id])
        db.close()
    }
    
    class func selectItemWithID(id:Int)->NoteItemModel?{
        let sql = "SELECT * FROM ITEMTABLE WHERE ITEMID = ?"
        let db = XTDB.getDb()
        db.open()
        let rs = db.executeQuery(sql, withArgumentsInArray: [id])
        let model = NoteItemModel()
        while rs.next() {
            model.itemID = Int(rs.intForColumn("ITEMID"))
            model.titleID = Int(rs.intForColumn("TITLEID"))
            model.sortNumber = Int(rs.intForColumn("SORTNUMBER"))
            model.type = Int(rs.intForColumn("TYPE"))
            model.question = rs.stringForColumn("QUESTION")
            model.answer = rs.stringForColumn("ANSWER")
            model.dateTime = rs.stringForColumn("DATETIME")
        }
        db.close()
        return model
    }
    
    class func itemCountWithTitleID(id:Int) -> Int{
        return self.selectItemWithTitleID(id)!.count
    }
    
    class func titleCountWithTimeStr(str:String) -> Int{
        return self.selectTitleWithDateTime(str)!.count
    }
    
    class func selectItemWithTitleID(id:Int)->[NoteItemModel]?{
        let sql = "SELECT * FROM ITEMTABLE WHERE TITLEID = ?"
        let db = XTDB.getDb()
        db.open()
        let rs = db.executeQuery(sql, withArgumentsInArray: [id])
        if rs == nil{
            return []
        }
        var arrayM = [NoteItemModel]()
        while rs.next() {
            let model = NoteItemModel()
            model.itemID = Int(rs.intForColumn("ITEMID"))
            model.titleID = Int(rs.intForColumn("TITLEID"))
            model.sortNumber = Int(rs.intForColumn("SORTNUMBER"))
            model.type = Int(rs.intForColumn("TYPE"))
            model.question = rs.stringForColumn("QUESTION")
            model.answer = rs.stringForColumn("ANSWER")
            model.dateTime = rs.stringForColumn("DATETIME")
            arrayM.append(model)
        }
        db.close()
        arrayM.sortInPlace { (model1:NoteItemModel, model2:NoteItemModel) -> Bool in
            return model1.sortNumber < model2.sortNumber
        }
        return arrayM
    }
    
    class func selectTitleAndItemsWithDateStr(time:String) -> [TitleModel] {
        let titleArray = self.selectTitleWithDateTime(time)
        if titleArray == nil || titleArray?.count <= 0{
            return []
        }
        for titleModel in titleArray!{
            titleModel.itemModelArray = self.selectItemWithTitleID(titleModel.titleID)
        }
        return titleArray!
    }
    
    class func updateItemWithItemModel(model:NoteItemModel) -> Bool{
        let sql = "UPDATE ITEMTABLE SET QUESTION=?,ANSWER=? WHERE ITEMID=?"
        let db = XTDB.getDb()
        db.open()
        let success:Bool = db.executeUpdate(sql, withArgumentsInArray: [model.question,model.answer,model.itemID])
        db.close()
        return success
    }
    
    class func initTitieAndItemWithDate(dateStr:String) -> Bool{
        let bundlePath = NSBundle.mainBundle().pathForResource("XJContentList.plist", ofType: nil)
        
//        var data:NSData = NSData(contentsOfFile: bundlePath!)!
        var success = true
        let array:NSArray = NSArray(contentsOfFile: bundlePath!)!
        
       let titleCount = self.selectTitleWithDateTime(dateStr)!.count
        if titleCount > 0{
            return false
        }
        if array.count <= 0{
            print("Failed to read XJContentList.plist")
            success = false
        }else{
            for i in 0..<array.count{
                let dict = array[i]
                let titleModel = TitleModel()
                titleModel.title = dict["title"] as! String
                titleModel.type = 1
                titleModel.dateTime = dateStr
                
                var itemStrArray:[String] = dict["itemArray"] as! [String]
                self.insertTitle(titleModel)
                let newTitleModel = self.selectTitleWithTitle(titleModel.title)
                
                for j in 0..<itemStrArray.count{
                    let question = itemStrArray[j]
                    let itemModel = NoteItemModel(question: question, answer: "", type: 2, titleID: newTitleModel!.titleID, dateTime:dateStr, sortNumber: 0)
                    self.insertItemWithItemModel(itemModel)
                }
            }
        }
        
        

        return success
    }
    
}
