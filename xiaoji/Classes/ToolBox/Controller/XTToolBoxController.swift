//
//  XTToolBoxController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/6.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

class XTToolBoxController: XTBaseViewController,UITableViewDelegate,UITableViewDataSource{

    private var userInfoModel = UserInfoModel()
    
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
        self.tableView.separatorStyle = .None
        
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
        
        tableView.registerNib(UINib(nibName: String(XTUserSettingCell), bundle: nil), forCellReuseIdentifier: String(XTUserSettingCell))
        
        
        weak var weakSelf = self
        DataService.shareInstance().RequestUserInfo { (resultModel) in
            weakSelf?.userInfoModel = resultModel
            weakSelf?.tableView.reloadData()
        }
        
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
            cell.userinfoModel = self.userInfoModel
            return cell
        }
        if indexPath.row == cellTitleArray.count - 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(String(XTQuitLogInCell)) as! XTQuitLogInCell
            cell.initWithClosure(logOutActionClosure)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(String(XTUserSettingCell)) as! XTUserSettingCell
        cell.titleLabel.text = (cellTitleArray[indexPath.row] as! String)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 64
        }
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            self.performSegueWithIdentifier("UserInfoDetail", sender: nil)
        }
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
