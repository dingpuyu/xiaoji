//
//  XTAddTitleItemController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/22.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import PKHUD

protocol AddTitleItemControllerDelegate:NSObjectProtocol{
    
    func addTitleItemController(controller:XTAddTitleItemController,reloaddate dateStr:String)
    
}

class XTAddTitleItemController: XTBaseViewController,UITableViewDataSource,UITableViewDelegate {

    var dateString:String?
    
    var questionArray:[String] = [""]
    
    weak var delegate:AddTitleItemControllerDelegate?
    
    var headerView:XTAddNoteTitleHeaderCell?
    
    var tableView:UITableView? = {
        var tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "添加问题"
        
        
        self.commonInit()
        
    }
    
    func commonInit(){
        self.view.addSubview(tableView!)
        tableView?.delegate = self;
        tableView?.dataSource = self;
    
        tableView?.registerClass(XTAddNoteQuestionCell.classForCoder(), forCellReuseIdentifier: String(XTAddNoteQuestionCell))
        
        tableView?.registerClass(XTNoteItemAddButtonCell.classForCoder(), forCellReuseIdentifier: String(XTNoteItemAddButtonCell))
        
        tableView?.registerClass(XTAddNoteTitleHeaderCell.classForCoder(), forHeaderFooterViewReuseIdentifier: String(XTAddNoteTitleHeaderCell))
        
        tableView?.frame = self.view.bounds
        
        tableView?.separatorStyle = .None
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: "saveButtonClick:")
    }
    
    //tableview delegate datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == questionArray.count{
            cell = tableView.dequeueReusableCellWithIdentifier(String(XTNoteItemAddButtonCell)) as! XTNoteItemAddButtonCell
            (cell as! XTNoteItemAddButtonCell).initWithClosure(addQuestionClosure)
            
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier(String(XTAddNoteQuestionCell)) as! XTAddNoteQuestionCell
            (cell as! XTAddNoteQuestionCell).initWithClosure(QuestionCellClosure)
            (cell as! XTAddNoteQuestionCell).indexPath = indexPath
            
            if indexPath.row == questionArray.count - 1{
                (cell as! XTAddNoteQuestionCell).becomeFirstResponder()
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(XTAddNoteTitleHeaderCell)) as! XTAddNoteTitleHeaderCell
        headerView = header
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
//    删除cell回调
    func QuestionCellClosure(cell:XTAddNoteQuestionCell,type:QuestionCellEventType){
        
        switch type{
        case .Delete:
            questionArray.removeAtIndex((cell.indexPath?.row)!)
            tableView?.reloadData()
            break;
        case .Edit:
            if questionArray.count > cell.indexPath?.item{
                questionArray.removeAtIndex((cell.indexPath?.item)!)
                questionArray.insert((cell.textField?.text)!, atIndex: (cell.indexPath?.item)!)
            }
            break;
        }

    }

    func addQuestionClosure(cell:XTNoteItemAddButtonCell){
        if questionArray.count >= 5{
            HUD.flash(.Label("选择最重要的五个问题啦！"), delay: 0.35)
            return
        }
        questionArray.append("")
        tableView?.reloadData()
    }
    
    //保存按钮点击
    func saveButtonClick(btn:UIBarButtonItem){
        
        tableView?.endEditing(true)
        
        if headerView?.textField?.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0{
            HUD.flash(.Label("请输入问题范围!"), delay: 0.45)
            return
        }
        
        for string in questionArray{
            if string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0{
                HUD.flash(.Label("不要写空的题目嘛！"), delay: 0.45)
                return
            }
            
        }
        var titleID:Int = 0
        var oldModel = XTDB.selectTitleWithTitle((headerView?.textField?.text)!)
        if oldModel?.title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0{
            titleID = (oldModel?.titleID)!
        }else{
            let titleModel = TitleModel()
            titleModel.dateTime = dateString!
            titleModel.title = (headerView?.textField?.text)!
            titleModel.type = 1
            XTDB.insertTitle(titleModel)
            oldModel = XTDB.selectTitleWithTitle((headerView?.textField?.text)!)
            titleID = (oldModel?.titleID)!
        }
        for question in questionArray{
            let itemModel = NoteItemModel()
            itemModel.titleID = titleID
            itemModel.question = question
            itemModel.type = 2
            itemModel.dateTime = dateString!
            XTDB.insertItemWithItemModel(itemModel)
        }
        if titleID > 0{
            if self.delegate != nil{
                if self.delegate!.respondsToSelector(Selector("addTitleItemController:reloaddate:")){
                    self.delegate!.addTitleItemController(self, reloaddate: dateString!)
                }
            }
            HUD.flash(.Label("添加成功"), delay: 0.55) { (status:Bool) -> Void in
                
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        }

    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let tableRowAction = UITableViewRowAction(style: .Default, title: "删除") { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            self.questionArray.removeAtIndex(indexPath.row)
            tableView.reloadData()
        };
        return [tableRowAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            questionArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}
