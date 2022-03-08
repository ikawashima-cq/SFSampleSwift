//
//  UserData.swift
//  SFSampleAppSwift
//
//  Created by Daichi Mizoguchi on 2014/12/10.
//  Copyright (c) 2014年 Daichi Mizoguchi. All rights reserved.
//

import Foundation

class AccountModel: BaseModel {
    
    var salesforceId: String?
    var accountName: String?
    var phone: String?
    var billingAddress: String?
    
    
    override init(record: NSDictionary) {
        super.init(record: record)
        self.setModel(model: record)
    }
    
    override func setModel(model account: NSDictionary){
        let salesforceId: AnyObject?   = account["Id"] as! String as AnyObject
        let accountName: AnyObject? = account["Name"] as! String as AnyObject
        let phone: AnyObject? = account["phone"] as! String as AnyObject
        let billingAddress: AnyObject? = account["BillingAddress"] as! String as AnyObject

        self.salesforceId   = salesforceId as? String
        self.accountName = accountName as? String
        self.phone = phone as? String
        self.billingAddress = billingAddress as? String
    }
}
