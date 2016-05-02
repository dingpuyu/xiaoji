//
//  XTMorningNoteController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/6.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

let dateTimeStr = "yyyy-MM-dd"




class XTMorningNoteController: XTBaseViewController,NoteFlowViewDelegate,AddTitleItemControllerDelegate {

    var MYDB:FMDatabase? = nil
    
    var dateString:String?
    
    var dateFormatter:NSDateFormatter{
        get{
            let formatter = NSDateFormatter()
            formatter.dateFormat = dateTimeStr
            return formatter
        }
    }
    
    var noteContentView:XTNoteFlowView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weakSelf = self
        // Do any additional setup after loading the view.
        self.commonInit()
    }
    
    func commonInit(){
        MYDB = XTDB.getDb()
//        self.navigationController?.navigationBar.hidden = true
        self.title = "晨记"
        dateString = dateFormatter.stringFromDate(NSDate())
        let rightButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(XTMorningNoteController.rightButtonAction(_:)))

        self.navigationItem.rightBarButtonItem = rightButtonItem

        
        noteContentView = XTNoteFlowView(frame: self.view.bounds)

        noteContentView?.dateString = dateString!
        self.view.addSubview(noteContentView!)

        noteContentView?.superDelegate = self
        
        let currentDate = NSDate()
        noteContentView?.initWithClosure(noteFlowViewAction)
        noteContentView?.dateString = dateFormatter.stringFromDate(currentDate)
//        print(dateFormatter.stringFromDate(currentDate))
        
        XTDB.initTitieAndItemWithDate(dateFormatter.stringFromDate(currentDate))
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(XTMorningNoteController.reloadCollectionHeaderView), name: "ReloadHeaderWeatherView", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    weak var weakSelf:XTMorningNoteController?
    func noteFlowViewAction(view:XTNoteFlowView,titleModel:TitleModel){
        let itemEditVC = XTNoteItemEditController()
        itemEditVC.titleModel = titleModel
        weakSelf?.navigationController?.pushViewController(itemEditVC, animated: true)
    }
    
    
    func rightButtonAction(barItem:UIBarButtonItem){
        noteContentView?.isEdit = !(noteContentView?.isEdit)!
    }
// #progma mark noteflowViewDelegate
    func noteFlowViewAddTitleAction(view: XTNoteFlowView) {
        let addTitleVC = XTAddTitleItemController()
        addTitleVC.dateString = view.dateString
        addTitleVC.delegate = self
        self.navigationController?.pushViewController(addTitleVC, animated: true)
    }
    
    func noteFlowViewVoiceShowAction(view: XTNoteFlowView, titleModel model: TitleModel) {
        let voiceVC = XTVoiceServiceController()
        
        var speakStr = model.title
        for itemModel in model.itemModelArray!{
            speakStr += itemModel.question
            speakStr += itemModel.answer
        }
        
        voiceVC.speakString = speakStr

    }
    
    func noteFlowViewDidTouchCell(view: XTNoteFlowView, titleModel model: TitleModel) {
        let detailController = XTnoteItemDetailController()
        detailController.titleModel = model
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailController, animated: true)
    }
//    点击了头部视图，编辑天气
    func noteFlowViewDidTouchHeaderView(view: XTNoteFlowView) {
//        let topEditVC = TopInfoBarViewController()
//        self.presentViewController(topEditVC, animated: true, completion: nil)
        self.performSegueWithIdentifier("TopInfoController", sender: self)
    }

    func addTitleItemController(controller: XTAddTitleItemController, reloaddate dateStr: String) {
        noteContentView?.dateString = dateString
        noteContentView?.collectionView.reloadData()
    }
    
    func reloadCollectionHeaderView(){
        self.noteContentView?.collectionView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TopInfoController"{
            let destVC = segue.destinationViewController as! TopInfoBarViewController
            destVC.dateString = self.dateString
        }
    }
    

    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


