//
//  XTVoiceServiceController.swift
//  xiaoji
//
//  Created by xiaotei's on 16/3/30.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

class XTVoiceServiceController: XTBaseViewController,IFlySpeechSynthesizerDelegate {

    var iFlySpeechSynthesizer:IFlySpeechSynthesizer?
    
    var speakString:String! = ""
    
    var circleView:UIView?
    
    var cancelButton:UIButton! = {
        let button = UIButton()
        button.setTitle("结束", forState: .Normal)
        button.setTitleColor(hightGreenColor, forState: .Normal)
        button.setTitleColor(lightGreenColor, forState: .Highlighted)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
//1.创建合成对象
        iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance() as? IFlySpeechSynthesizer

        iFlySpeechSynthesizer?.delegate = self
        //2.设置合成参数
        //设置在线工作方式
        iFlySpeechSynthesizer!.setParameter(IFlySpeechConstant.TYPE_CLOUD(), forKey: IFlySpeechConstant.ENGINE_TYPE())
    
        //音量,取值范围 0~100
        iFlySpeechSynthesizer!.setParameter("50", forKey: IFlySpeechConstant.VOLUME())
        
        //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表” [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]]; //保存合成文件名,如不再需要,设置设置为nil或者为空表示取消,默认目录位于 library/cache下
        iFlySpeechSynthesizer!.setParameter("xiaoyan", forKey: IFlySpeechConstant.VOICE_NAME())
        iFlySpeechSynthesizer!.setParameter("tts.pcm", forKey: IFlySpeechConstant.TTS_AUDIO_PATH())

        //3.启动合成会话
        iFlySpeechSynthesizer!.startSpeaking(speakString)
        
        circleView = UIView()
        self.view.addSubview(circleView!)
        circleView?.snp_makeConstraints(closure: { (make) -> Void in
            make.center.equalTo(self.view.snp_center)
            make.size.equalTo(CGSizeMake(200, 200))
        })
        circleView!.layer.cornerRadius = 100
        circleView!.backgroundColor = UIColor(red: 0.24, green: 0.88, blue: 0.80, alpha: 0.1)
        circleView?.clipsToBounds = true
        
        
        
        self.view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: Selector("cancelVoiceProcess"), forControlEvents: .TouchUpInside)
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(44)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(33)
        }
        
    }
    
    func startAnimation(){
        
        let keyAnimation = CAKeyframeAnimation(keyPath: "transform")

        let scale1 = CATransform3DMakeScale(0.5, 0.5, 1)
        let scale2 = CATransform3DMakeScale(1.2, 1.2, 1)
        
        let array = [NSValue(CATransform3D: scale1),NSValue(CATransform3D: scale2)]
        keyAnimation.values = array
        keyAnimation.fillMode = kCAFillModeForwards
        keyAnimation.duration = 1.5
        keyAnimation.repeatCount = MAXFLOAT
        self.circleView?.layer.addAnimation(keyAnimation, forKey: "ScaleAnimation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: synthesizeDelegate
    //结束代理
    func onCompleted(error: IFlySpeechError!)
    {
        self.circleView?.layer.removeAnimationForKey("ScaleAnimation")
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    func onSpeakBegin() {
        self.startAnimation()
    }
    //合成缓冲进度
    func onBufferProgress(progress: Int32, message msg: String!) {
//        print("BufferProgress:\(progress) message:\(msg)")
    }
    
    func onSpeakProgress(progress: Int32) {
//        print("progress:\(progress)")
    }

    //#pragma mark 取消播放
    func cancelVoiceProcess(){
        self.iFlySpeechSynthesizer?.stopSpeaking()
        self.navigationController?.dismissViewControllerAnimated(false, completion: nil)
    }
    

}
