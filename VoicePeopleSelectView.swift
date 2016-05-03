//
//  VoicePeopleSelectView.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/5/2.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

enum PickerViewType {
    case VoiceFangYan,VoicePeoPle,VoiceLanguage
}


class VoicePeopleSelectView: UIView ,UIPickerViewDelegate,UIPickerViewDataSource{

    var selectionView:UIPickerView = UIPickerView()
    
    var cancelButton:UIButton = UIButton()
    
    var saveButton:UIButton = UIButton()
    
    var selectRow:Int = 8
    
    var style:PickerViewType = .VoicePeoPle

    var peopleArray:NSArray! = {
        ["小燕","小宇","凯瑟琳","亨利","玛丽","小研","小琪","小峰","小梅","小莉","小蓉(四川话)","小芸","小坤","小强","小莹","小新","老楠","老孙"]
    }()
    
    
    override func didMoveToSuperview() {
        self.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
        self.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(VoicePeopleSelectView.didTouchSelf))
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        
        
        selectionView.delegate = self
        selectionView.dataSource = self
        selectionView.backgroundColor = UIColor.whiteColor()
        self.addSubview(selectionView)
        
//        selectionView.frame = CGRect(x: 0, y: kMainScreenHeight - 180, width: kMainScreenWidth, height: 180)
        
        selectionView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp_bottom)
            make.height.equalTo(170)
        }
        
        
        self.addSubview(cancelButton)
        self.addSubview(saveButton)
        
        
        cancelButton.setTitle("取消", forState: .Normal)
        cancelButton.setTitleColor(hightGreenColor, forState: .Normal)
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.addTarget(self, action: #selector(VoicePeopleSelectView.didTouchSelf), forControlEvents: .TouchUpInside)
        
        
        saveButton.setTitle("确认", forState: .Normal)
        saveButton.setTitleColor(hightGreenColor, forState: .Normal)
        saveButton.backgroundColor = UIColor.whiteColor()
        saveButton.addTarget(self, action: #selector(VoicePeopleSelectView.saveAction), forControlEvents: .TouchUpInside)
        
        cancelButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left)
            make.bottom.equalTo(selectionView.snp_top)
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        saveButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_right)
            make.bottom.equalTo(selectionView.snp_top)
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        
        
        switch(style){
        case .VoiceFangYan:
            peopleArray =  ["普通话","粤语","河南话"]
            selectRow = 0
            break
        case .VoicePeoPle:
            selectRow = 8
            break
        case .VoiceLanguage:
            peopleArray = ["汉语","英语"]
            selectRow = 0
            
            break
        default:
            break
        }
        
        selectionView.selectRow(selectRow, inComponent: 0, animated: false)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return peopleArray.count
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = row
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(component)"
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
       return NSAttributedString(string: peopleArray[row] as! String, attributes:[NSForegroundColorAttributeName:hightGreenColor])
    }
    
    
    func didTouchSelf() -> Void {
        NSNotificationCenter.defaultCenter().postNotificationName("ReloadVoiceSetting", object: nil)
        self.removeFromSuperview()
    }
    
    func saveAction() -> Void {
        var string = "xiaoyan"
        
        if style == .VoicePeoPle{
        
        switch selectRow {
        case 0:
            string = "xiaoyan"
            break
        case 1:
            string = "xiaoyu"
            break
        case 2:
            string = "catherine"
            break
        case 3:
            string = "henry"
            break
        case 4:
            string = "vimary"
            break
        case 5:
            string = "vixy"
            break
        case 6:
            string = "vixq"
            break
        case 7:
            string = "vixf"
            break
        case 8:
            string = "vixl"
            break
        case 9:
            string = "vixq"
            break
        case 10:
            string = "vixr"
            break
        case 11:
            string = "vixyun"
            break
        case 12:
            string = "vixk"
            break
        case 13:
            string = "vixqa"
            break
        case 14:
            string = "vixying"
            break
        case 15:
            string = "vixx"
            break
        case 16:
            string = "vinn"
            break
        case 17:
            string = "vils"
            break
        default:
            string = "xiaoyan"
            break
        }
        
        XJUserDefault.sharedInstance.setVoicePeople(string)
        }else if style == .VoiceFangYan{
            switch selectRow {
            case 0:
                string = PUTONGHUA
                break
            case 1:
                string = YUEYU
                break
            case 2:
                string = HENANHUA
                break
            default:
                string = PUTONGHUA
                break
            }
            XJUserDefault.sharedInstance.setFangYan(string)
        }else if style == .VoiceLanguage{
            switch selectRow {
            case 0:
                string = CHINESE
                break
            case 1:
                string = ENGLISH
                break
            default:
                string = CHINESE
                break
            }
            XJUserDefault.sharedInstance.setVoiceLanguage(string)
        }
        didTouchSelf()
    }
}
