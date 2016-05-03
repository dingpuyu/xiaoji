//
//  XTVoiceListenController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/5/1.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

protocol VoiceListenDelegate:NSObjectProtocol{
    
    func didEndListen(result:NSString)
    
}


class XTVoiceListenController: XTBaseViewController,IFlySpeechRecognizerDelegate{
//    IFlySpeechRecognizer *iFlySpeechRecognizer;
    
    weak var delegate:VoiceListenDelegate?
    
    var volumeLabel:UILabel = UILabel()
    
    var iFlySpeechRecognizer:IFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance()
 as! IFlySpeechRecognizer    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = lightGreenColor
//        [iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        iFlySpeechRecognizer.delegate = self
        iFlySpeechRecognizer.setParameter("iat", forKey: IFlySpeechConstant.IFLY_DOMAIN())
//        [iFlySpeechRecognizer setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        iFlySpeechRecognizer.setParameter("asrview.pcm", forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
        
        //设置语言
        iFlySpeechRecognizer.setParameter(XJUserDefault.sharedInstance.voiceLanguage(), forKey: IFlySpeechConstant.LANGUAGE())
        //设置方言
        iFlySpeechRecognizer.setParameter(XJUserDefault.sharedInstance.voiceFangYan(), forKey: IFlySpeechConstant.ACCENT())
    iFlySpeechRecognizer.startListening()
        self.view.addSubview(volumeLabel)
        volumeLabel.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: kMainScreenWidth, height: 30))
            make.center.equalTo(self.view.snp_center)
        }
        volumeLabel.text = "音量:0"
        volumeLabel.textAlignment = .Center
    }
    /**
     停止录音回调
     ****/
    func onEndOfSpeech() {
//        self.dismissViewControllerAnimated(true, completion: nil)
        iFlySpeechRecognizer.stopListening()
    }
    /*识别会话结束返回代理
     @ param error 错误码,error.errorCode=0表示正常结束,非0表示发生错误。 */
    func onError(errorCode: IFlySpeechError!) {
        iFlySpeechRecognizer.stopListening()
    }
    /**
     开始识别回调
     ****/
    func onBeginOfSpeech() {
        
    }
    
    func onVolumeChanged(volume: Int32) {
        volumeLabel.text = "音量:\(volume)"
    }
    
    func onResults(results: [AnyObject]!, isLast: Bool) {
        var resultString = NSMutableString()
        
        if results != nil{
            let dic = results[0] as! NSDictionary
            for (key,value) in dic {
                resultString.appendString(key as! String)
            }
            
            let resultFromJson =  ISRDataHelper.stringFromJson(resultString as String)
            
            
            if (isLast){
                print(resultFromJson)
            }
            if ((self.delegate?.respondsToSelector(Selector("didEndListen:"))) != nil){
                self.delegate?.didEndListen(resultFromJson)
            }
            
        }
        iFlySpeechRecognizer.stopListening()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    (void) onResults:(NSArray *) results isLast:(BOOL)isLast
   
//    - (void)onError: (IFlySpeechError *) error{}

//    - (void) onEndOfSpeech {}

//    - (void) onBeginOfSpeech {}
//    - (void) onVolumeChanged: (int)volume {}
}
