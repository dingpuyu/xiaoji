//
//  XTVoiceSettingController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/5/2.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

let PUTONGHUA = "mandarin"
let YUEYU     = "cantonese"
let HENANHUA   = "henanese"
let ENGLISH = "en_us"
let CHINESE = "zh_cn"

class XTVoiceSettingController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: String(UITableViewCell))
        
        tableView.registerClass(XTGroupTitleView.classForCoder(), forHeaderFooterViewReuseIdentifier: String(XTGroupTitleView))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(XTVoiceSettingController.reloadVoiceSetting), name: "ReloadVoiceSetting", object: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        
        if XJUserDefault.sharedInstance.voiceLanguage() == ENGLISH{
            return 1
        }
        return 2;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell))
        if indexPath.section == 0{
            cell?.textLabel?.text = "播音人声"
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                cell?.textLabel?.text = "语言"
            }else if indexPath.row == 1{
                cell?.textLabel?.text = "方言"
            }
        }
        
    
        
        return cell!
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(XTGroupTitleView)) as! XTGroupTitleView
//        
//        if section == 0{
//            headerView.titleLabel.text = "语音播放设置"
//        }else if section == 1{
//            headerView.titleLabel.text = "语音识别设置"
//        }
//        
//        return headerView
//    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "语音播放设置"
        }
        return "语音识别设置"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0{
              let peopleSelectView = VoicePeopleSelectView(frame: self.view.frame)
                peopleSelectView.style = .VoicePeoPle
            UIApplication.sharedApplication().keyWindow?.addSubview(peopleSelectView)
            
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                let peopleSelectView = VoicePeopleSelectView(frame: self.view.frame)
                peopleSelectView.style = .VoiceLanguage
                UIApplication.sharedApplication().keyWindow?.addSubview(peopleSelectView)
            }else if indexPath.row == 1{
                let peopleSelectView = VoicePeopleSelectView(frame: self.view.frame)
                peopleSelectView.style = .VoiceFangYan
                UIApplication.sharedApplication().keyWindow?.addSubview(peopleSelectView)
            }
        }
    }
    
    func reloadVoiceSetting(){
        self.tableView.reloadData()
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
