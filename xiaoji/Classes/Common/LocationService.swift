//
//  LocationService.swift
//  xiaoji
//
//  Created by xiaotei's on 16/3/18.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import Foundation
import CoreLocation


class LocationService: NSObject, CLLocationManagerDelegate {
    class var sharedInstance: LocationService {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            
            static var instance: LocationService? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LocationService()
        }
        return Static.instance!
    }
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.distanceFilter = 200
        self.locationManager?.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: AnyObject? = (locations as NSArray).lastObject
        
        self.currentLocation = location as? CLLocation
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        if (error != nil) {
            print("Update Location Error : \(error.description)")
        }
    }
    
    func updateLocation(currentLocation:CLLocation){
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
    }
}
