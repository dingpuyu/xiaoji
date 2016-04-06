//
//  XTToolBoxController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/6.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

class XTToolBoxController: XTBaseViewController,UITableViewDelegate,UITableViewDataSource{

    var tableView:UITableView! = {
        var view = UITableView()
        view.separatorStyle = .None
        return view
    }()
    
    var cellTitleArray:NSArray! = {
        return ["头像","账户与密码管理","个人资料","语音助手设置","退出当前账户"]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        
        self.commonInit()
    }
    
    func commonInit(){
        self.title = "个人中心";
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(64)
            make.left.right.bottom.equalTo(self.view)
        }
        
        
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: String(UITableViewCell))
        
        tableView.registerNib(UINib(nibName: String(XTQuitLogInCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(XTQuitLogInCell))
        
        tableView.registerNib(UINib(nibName: String(XTUserInfoCell), bundle: nil), forCellReuseIdentifier: String(XTUserInfoCell))
    }

    
//#pragma mark talbeViewDelegate datasource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(String(XTUserInfoCell)) as! XTUserInfoCell
            return cell
        }
        if indexPath.row == cellTitleArray.count - 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(String(XTQuitLogInCell)) as! XTQuitLogInCell
            cell.initWithClosure(logOutActionClosure)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell))
        cell?.textLabel?.text = cellTitleArray[indexPath.row] as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 64
        }
        return 55
    }
    
    func logOutActionClosure() -> Void{
        NSUserDefaults.standardUserDefaults().setBool(false, forKey:isLogInKey)
        
        self.performSegueWithIdentifier("LogIn", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
