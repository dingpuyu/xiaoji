//
//  TopInfoBarViewController.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/6.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import PKHUD



class TopInfoBarViewController: UIViewController {

    
    var dateString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
    }

    @IBAction func weatherButtonClick(sender: UIButton) {
        //冰雹（2001），雾霾（2002），多云（2003），雨（2004），雪（2005），雷（2006），晴天（2007），大风（2008）
        var showStr:String = "冰雹"
        switch sender.tag{
        case 2001:
            showStr = "冰雹"
            XTDB.updateWeatherTypeWithDateString(dateString!, type: 1)
            break
        case 2002:
            showStr = "雾霾"
            XTDB.updateWeatherTypeWithDateString(dateString!, type: 2)
            break
        case 2003:
            showStr = "多云"
            XTDB.updateWeatherTypeWithDateString(dateString!, type: 3)
            break
        case 2004:
            showStr = "雨"
            XTDB.updateWeatherTypeWithDateString(dateString!, type: 4)
            break
        case 2005:
            showStr = "雪"
            XTDB.updateWeatherTypeWithDateString(dateString!, type: 5)
            break
        case 2006:
            showStr = "雷"
            XTDB.updateWeatherTypeWithDateString(dateString!, type: 6)
            break
        case 2007:
            showStr = "晴天"
            XTDB.updateWeatherTypeWithDateString(dateString!, type: 7)
            break
        case 2008:
            showStr = "大风"
            XTDB.updateWeatherTypeWithDateString(dateString!, type: 8)
            break
        default:
            showStr = ""
            break
        }
        
        HUD.flash(.Label(showStr), delay: 1.5)
        NSNotificationCenter.defaultCenter().postNotificationName("ReloadHeaderWeatherView", object: self)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
