//
//  XTNoteFlowView.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/9.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD

protocol NoteFlowViewDelegate:NSObjectProtocol{

    func noteFlowViewAddTitleAction(view:XTNoteFlowView)
    //声音阅读
    func noteFlowViewVoiceShowAction(view:XTNoteFlowView,titleModel model:TitleModel)
    //选中了某个cell
    func noteFlowViewDidTouchCell(view:XTNoteFlowView,titleModel model:TitleModel)
//    选中了头视图
    func noteFlowViewDidTouchHeaderView(view:XTNoteFlowView)
}


typealias noteFlowViewActionClosure=(view:XTNoteFlowView,model:TitleModel) -> Void

class XTNoteFlowView: UIView, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate{
    var collectionView:UICollectionView!
    private var longPressGesture: UILongPressGestureRecognizer!
    
    var collectionViewFunctionView:XTCollectionCellFunctionView? = {
        var view = XTCollectionCellFunctionView()

        return view
    }()
    
    weak var superDelegate:NoteFlowViewDelegate!
    
    var isEdit:Bool?{
        didSet{
            for cell in collectionView.subviews{
                if cell.isKindOfClass(XTNoteTipsCell.classForCoder()){
                    (cell as! XTNoteTipsCell).isEdit = isEdit
                }
            }
            if isEdit == true{
            collectionView.frame = CGRect(x: 0, y: 0, width: kMainScreenWidth, height: self.frame.size.height - 79)
            collectionViewFunctionView?.frame = CGRect(x: 0, y: self.frame.size.height - 79, width: kMainScreenWidth, height: 30)
            }else{
                collectionView.frame = self.bounds
                collectionViewFunctionView?.frame = CGRect(x: 0, y: self.frame.size.height - 30, width: kMainScreenWidth, height: 30)
            }
        }
    }
    
    var isFullScreen:Bool? = false
    
    var closure:noteFlowViewActionClosure?
    
    
    var dateString:String?{
        didSet{
            
        }
    }
    
//    var itemArray:[TitleModel]? = {
    
    
//    }()
    
    func itemArray() -> [TitleModel]{

        return XTDB.selectTitleAndItemsWithDateStr(dateString!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView?.frame = self.bounds;
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        weakSelf = self
        
        self.commonInit()
    }
    
    func initWithClosure(closure:noteFlowViewActionClosure){
        self.closure = closure
    }
    
    
    func commonInit(){
        let flowLayout = XTNoteFlowLayout()
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)

//        let nib = UINib(nibName: String(XTNoteTipsCell), bundle: nil)
//        collectionView.registerNib(nib, forCellWithReuseIdentifier: String(XTNoteTipsCell))
        collectionView.registerClass(XTNoteTipsCell.classForCoder(), forCellWithReuseIdentifier: String(XTNoteTipsCell))
        collectionView.registerNib(UINib(nibName: String(XTNoteCollectionReusableView), bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(XTNoteCollectionReusableView))
//        collectionView?.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier:String(XTNoteTipsCell))
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        self.addSubview(collectionView!)
        self.addSubview(collectionViewFunctionView!)
        collectionViewFunctionView!.initWithClosure(functionCellFunctionViewClosure)
        longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongGesture:")
        collectionView?.addGestureRecognizer(longPressGesture)
        
        isEdit = false
    }
    
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:

            guard let selectedIndexPath = self.collectionView.indexPathForItemAtPoint(gesture.locationInView(self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            collectionView.endInteractiveMovement()

            
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        if(itemArray.count == 1){
//            return CGSize(width: kMainScreenWidth, height: 100)
//        }else {
//            return CGSize(width: kMainScreenWidth / 2.0, height: 100)
//        }
//    }
    
    //实现UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //返回记录数
        return self.itemArray().count;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let count:Int = self.itemArray().count
        count / 2
        var width:CGFloat = kMainScreenWidth/2.0 - 0.5
        var height:CGFloat = 100.0
        
        
        
        let minHeight:CGFloat = (kMainScreenHeight - 49.0 - 64.0 - 55.0) / CGFloat(Int((CGFloat(count)) / 2.0  + 0.5))
        if minHeight > height{
            height = minHeight
        }
        if count <= 2{
            width = kMainScreenWidth - 1.0
            height = 200.0
        }

        return CGSize(width: width, height: height)
    }
    
    
    
    //实现UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let itemModel:TitleModel = self.itemArray()[indexPath.row]
        
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell  = collectionView.dequeueReusableCellWithReuseIdentifier(String(XTNoteTipsCell), forIndexPath: indexPath) as! XTNoteTipsCell

        
//        print("\(cell.contentView.subviews.count)")
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.titleModel = itemModel
        cell.initWithClosure(noteCellFunc)
        cell.indexPath = indexPath
        
        cell.contentView.userInteractionEnabled = false
        
        return cell;
    }
    
    
    
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let noteCell = collectionView.cellForItemAtIndexPath(indexPath) as! XTNoteTipsCell
//        noteCell.oldRect = UIView().convertRect(noteCell.frame, fromView: self.collectionView)

        if self.superDelegate!.respondsToSelector(Selector("noteFlowViewDidTouchCell:titleModel:")){
            self.superDelegate.noteFlowViewDidTouchCell(self, titleModel: noteCell.titleModel)
        }
//        noteCell.backgroundColor = UIColor.lightGrayColor()
        
//        self.bringSubviewToFront(noteCell)
//        if closure != nil{
//            closure!(view:self,model:noteCell.titleModel)
//        }

//        noteCell.moveToWindow()
//        self.itemArray.removeAtIndex(indexPath.item)
//        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    func noteCellFunc(tipsCell:XTNoteTipsCell,model:TitleModel,type:NoteCellEventType)->Void{
        self.addSubview(tipsCell)

        switch type{

        case .Save:
            UIView.animateWithDuration(0.65, delay:0.00,
                options:UIViewAnimationOptions.TransitionFlipFromLeft, animations:
                {
                    ()-> Void in
                    //在动画中，数字块有一个角度的旋转。
                    tipsCell.frame = tipsCell.oldRect!
                },
                completion:{
                    (finished:Bool) -> Void in
                    UIView.animateWithDuration(0, animations:{
                        ()-> Void in
                        //        self.collectionView.reloadData()            //完成动画时，数字块复原
                        self.collectionView.reloadItemsAtIndexPaths([tipsCell.indexPath!])
                        tipsCell.removeFromSuperview()
                    })
            })
            break
        case .Quit: break
        
        case .Delete:
            if XTDB.selectTitleWithDateTime(model.dateTime)?.count <= 1{
                HUD.flash(.Label("留一个嘛！"), delay: 1.2)
            }else{
                XTDB.removeTitle(model.titleID)
            }
            
            collectionView.reloadData()
            break
        case .Cancel:
            break;
        case .Voice:
            if self.superDelegate!.respondsToSelector(Selector("noteFlowViewVoiceShowAction:titleModel:")){
                self.superDelegate!.noteFlowViewVoiceShowAction(self, titleModel: model)
            }
            break;
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        var itemArray = self.itemArray()
        let temp = itemArray.removeAtIndex(sourceIndexPath.item)
        itemArray.insert(temp, atIndex: destinationIndexPath.item)
        for i in 0 ..< itemArray.count{
//            object.sortNumber = sortNumber++
            let itemModel = itemArray[i]
            XTDB.updateTitleSortNumberWith(itemModel.titleID, sortNumber: i+1)
            
        }
        collectionView.reloadData() 
    }
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kMainScreenWidth, height: 55)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var view = XTNoteCollectionReusableView()
        if kind == UICollectionElementKindSectionHeader{
//            let headerV = UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 80))
            
            view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: String(XTNoteCollectionReusableView), forIndexPath: indexPath) as! XTNoteCollectionReusableView
            view.initWithClosure(headActionClosure)
            view.textLabel.text = dateString
            view.dateString = dateString
            return view
        }
        return view;
    }
    weak var delegate:UICollectionViewDelegate?
//    头视图回调函数
    var sortNumber = 1
    weak var weakSelf:XTNoteFlowView? = nil
    func headActionClosure() -> Void{
        
    
        if self.superDelegate.respondsToSelector(Selector("noteFlowViewDidTouchHeaderView:")){
            self.superDelegate.noteFlowViewDidTouchHeaderView(self)
        }
        
//        let titleModel =  TitleModel(title: "梦想与现实，执着与超越", subtitle: "", sortNumber: self.itemArray().count+1, type: 1, dateTime: dateString!)
//        XTDB.insertTitle(titleModel)
        
//      weakSelf?.collectionView.reloadData() 
    }
    
    
//    collectionViewfunctionviewclosure
    func functionCellFunctionViewClosure(funcview:XTCollectionCellFunctionView,type:collectionEditType)->Void{
        if superDelegate != nil && superDelegate!.respondsToSelector("noteFlowViewAddTitleAction:") {
            superDelegate.noteFlowViewAddTitleAction(self)
        }
    }
    
}
