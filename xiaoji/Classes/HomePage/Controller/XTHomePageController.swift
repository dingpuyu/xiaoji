//
//  XTHomePageController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/2.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit
import CoreLocation
import PKHUD
import Alamofire

class XTHomePageController: XTBaseViewController,CLLocationManagerDelegate {
    
    let url = "http://api.map.baidu.com/telematics/v3/weather"//天气API
    
    let ak = "E61e6f29f6048bb5327dcacdb4426b32"//百度API ak
    
    var pcmFilePath:String? = nil
    
    var uploader:IFlyDataUploader? = nil
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"56dc14e0"];
//        var initString = String("appid=56dc14e0")
        // Do any additional setup after loading the view.
//        [IFlySpeechUtility createUtility:initString];
        self.tabBarController?.tabBar.tintColor = hightGreenColor
        self.commonInit()
    }
    
    func commonInit(){
        self.title = "首页"
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count-1] as CLLocation
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            updateWeatherInfo(location.coordinate)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
         print("Update Location Error : \(error.description)")
    }
    
    func updateWeatherInfo(coordinate:CLLocationCoordinate2D){
       let parameters = ["location":"\(coordinate.latitude),\(coordinate.longitude)", "output":"json","ak":ak]
        
        Alamofire.request(.GET, url, parameters: parameters,encoding: .URLEncodedInURL)
            .responseJSON { response in
            
        }
    }

}
