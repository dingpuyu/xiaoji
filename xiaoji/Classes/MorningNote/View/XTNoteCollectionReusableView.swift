//
//  XTNoteCollectionReusableView.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/12.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

typealias actionClosure=()->Void

class XTNoteCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var weatherImageView: UIImageView!
    
    var myClosure:actionClosure?
    
    var dateString:String?{
        didSet{
            let type = XTDB.selectWeatherTypeWithDateString(dateString!)
            var imageString = ""
            switch type{
            case 1:
                imageString = "Hail-back"
                break
            case 2:
                imageString = "Haze-back"
                break
            case 3:
                imageString = "PartlySunny-back"
                break
            case 4:
                imageString = "Rain-back"
                break
            case 5:
                imageString = "Snow-back"
                break
            case 6:
                imageString = "Storm-back"
                break
            case 7:
                imageString = "Sun-back"
                break
            case 8:
                imageString = "Tornado-back"
                break
            default:
                break
            }
            self.weatherImageView.image = UIImage(named: imageString)
        }
    }
    
    @IBAction func actionButtonClick(sender: AnyObject) {
        
        if (myClosure != nil){
            myClosure!()
        }
    }
    
    func initWithClosure(closure:actionClosure){
        myClosure = closure
    }
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
