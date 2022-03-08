//
//  BaseViewController.swift
//  SFSampleAppSwift
//
//  Created by Daichi Mizoguchi on 2014/12/11.
//  Copyright (c) 2014年 Daichi Mizoguchi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func requestQuery (queryString: String, tag: Int) {
        SFRestAPI.sharedInstance().performSOQLQuery(queryString,
                                                    fail: {(e: NSError!) -> () in self.queryFailed(e: e)} as! SFRestFailBlock,
                                                    complete: {(result :[NSObject:AnyObject]!) -> () in self.queryCompleted(result: result, tag: tag)} as! SFRestDictionaryResponseBlock)
    }
    
    
    // 各ViewControllerでオーバーライドし、処理を記述する
    func queryCompleted(result :[NSObject:AnyObject]!, tag :Int) {}
    
    
    func queryFailed(e: NSError) {
        let alertController = UIAlertController(title: "クエリエラー", message: e.localizedDescription, preferredStyle: .alert)
        let returnAction = UIAlertAction(title: "OK", style: .default) {
            action in print(e.localizedDescription)
        }
        alertController.addAction(returnAction)
        present(alertController, animated: true, completion: nil)
    }
}
