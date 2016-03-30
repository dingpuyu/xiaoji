//
//  XTToolBoxController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/6.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

class XTToolBoxController: XTBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        
        self.commonInit()
    }
    
    func commonInit(){
        self.title = "工具";
    }

    @IBAction func StartButtonClick(sender: UIButton) {
        let voiceVC = XTVoiceServiceController()
//        self.navigationController?.pushViewController(voiceVC, animated: true)
        voiceVC.speakString = "你是谁，你在干嘛咧，说书的岳云鹏你认识吗?据说哟个跟他长得很像的小胖子，呵呵"
        self.presentViewController(voiceVC, animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
