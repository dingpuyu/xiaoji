//
//  XTSearchNoteController.swift
//  xiaoji
//
//  Created by xiaotei's on 16/4/7.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

class XTSearchNoteController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView! = {
        var view = UITableView()
        return view
    }()
    
    var resultArray:NSArray?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var searchView:XTSearchBarView! = {
        var view = XTSearchBarView()
        view.frame = CGRectMake(0,20,kMainScreenWidth - 54,44)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        // Do any additional setup after loading the view.
        self.view.addSubview(searchView)
        searchView.initWithClosure(searchChangeClosure)
        let backBtn = UIButton(frame: CGRect(x: kMainScreenWidth - 52, y: 25.5, width:42 , height: 33))
        self.view.addSubview(backBtn)
        backBtn.setTitle("取消", forState: .Normal)
        backBtn.setTitleColor(lightGreenColor, forState: .Normal)
        backBtn.addTarget(self, action: Selector("backButtonClick:"), forControlEvents: .TouchUpInside)
        self.title = "检索日记"
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame) + 20, kMainScreenWidth, kMainScreenHeight - CGRectGetMaxY(searchView.frame) - 20)
        
        
        tableView.registerNib(UINib(nibName: String(XTSearchResultCell), bundle: nil), forCellReuseIdentifier: String(XTSearchResultCell))
        
        resultArray = []
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultArray?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(XTSearchResultCell)) as! XTSearchResultCell
        cell.viewModel = XTSearchResultViewModel.searchResultViewModelWith(resultArray![indexPath.row] as! NoteItemModel)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonClick(button:UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchChangeClosure(text:String) -> Void{
       print(text)
        weak var weakSelf = self
        DataService.searchNoteWithText(text) { (resultArray:[NoteItemModel]) -> Void in
            print(resultArray)
            weakSelf?.resultArray = resultArray
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
