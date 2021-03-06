//
//  RootViewController.swift
//  SFSampleAppSwift
//
//  Created by Daichi Mizoguchi on 2014/12/08.
//  Copyright (c) 2014年 Daichi Mizoguchi. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userTableView: UITableView!
    var accountItems: [AccountModel] = [AccountModel]()
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        requestQuery(queryString: "SELECT Id, Name, phone, BillingAddress FROM Account LIMIT 10",tag: 0)
    }
    
    
    func setupDesign () {
        self.title = "AccountTable"
        let logoutButton: UIBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(RootViewController.tapLogoutButton))
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    
    func setupTableView () {
        userTableView.delegate = self
        userTableView.dataSource = self
    }
    
    
    override func queryCompleted(result :[NSObject:AnyObject]!, tag: Int) {
        // モデルのタイプを指定してインスタンス化
        let userManager :ModelManager =  ModelManager(modelType: AccountModel.description())
        
        // クエリで返ってきたデータをモデルの配列にセット
        userManager.setRecords(records: result as! NSDictionary)
        
        // BaseModelクラスで返って来るので、指定したクラスにキャストする
        self.accountItems = userManager.getRecords() as! [AccountModel]
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.userTableView.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MyTestCell")
        
        cell.textLabel?.text = self.accountItems[indexPath.row].accountName
        cell.detailTextLabel?.text = self.accountItems[indexPath.row].salesforceId
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC: DetailViewController = DetailViewController(nibName:Util.className(ac: DetailViewController), accountItem: self.accountItems[indexPath.row])
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    func tapLogoutButton () {
        SFAuthenticationManager.shared().logout()
    }
    
}

