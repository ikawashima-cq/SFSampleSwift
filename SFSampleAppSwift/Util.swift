//
//  Util.swift
//  SFSampleAppSwift
//
//  Created by Daichi Mizoguchi on 2014/12/11.
//  Copyright (c) 2014年 Daichi Mizoguchi. All rights reserved.
//

import Foundation

class Util : NSObject {
    
    override init() {
        super.init()
    }
    
    
    class func className(ac: AnyClass) -> String {
        let className = NSStringFromClass(ac)
        let range = className.range(of: ".")
        return ""
    }
}
