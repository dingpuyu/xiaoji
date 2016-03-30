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
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: synthesizeDelegate
    //结束代理
    func onCompleted(error: IFlySpeechError!)

    //合成开始
    //合成开始
    func onSpeakBegin() {
        
    }
    //合成缓冲进度
    func onBufferProgress(progress: Int32, message msg: String!) {
        
    }
    
    func onSpeakProgress(progress: Int32) {
        
    }

    

}
