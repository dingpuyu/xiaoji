//
//  XTSearchBarView.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/7.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

typealias searchTextClosure=(text:String)->Void

class XTSearchBarView: UIView ,UITextFieldDelegate{

    
    var closure:searchTextClosure?
    
    var searchField:UITextField! = {
        var textField = UITextField()
        textField.placeholder = "请输入关键字"
        return textField
    }()
    
    var searchIconView:UIView! = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
        var imgView = UIImageView(image: UIImage(named: "icon_search"))
        view.addSubview(imgView)
        imgView.frame = CGRect(x: 8.5, y: 8.5, width: 16, height: 16)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        
        self.addSubview(searchField)
        searchField.leftView = searchIconView
        searchField.leftViewMode = .Always
        
        searchField.returnKeyType = .Search
        
        searchField.delegate = self
        
        searchField.borderStyle = .RoundedRect
        
        searchField.addTarget(self, action: Selector("textFieldDidChange"), forControlEvents: .EditingChanged)
    }
    
    func initWithClosure(closure:searchTextClosure){
        self.closure = closure
    }

    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidChange(){
        if closure != nil{
            closure!(text: self.searchField!.text!)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if closure != nil{
            closure!(text: self.searchField!.text!)
        }
        return true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        searchField.frame = CGRectMake(8, (self.frame.size.height - 33)/2.0, self.frame.size.width - 16, 33)
        
    }
    
}
