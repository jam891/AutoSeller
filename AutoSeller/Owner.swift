//
//  Owner.swift
//  AutoSeller
//
//  Created by Vitaliy Delidov on 10/9/15.
//  Copyright © 2015 Vitaliy Delidov. All rights reserved.
//

import Foundation

class Owner: PFObject, PFSubclassing {
    
    var name: String?
    var phone: String?
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Owner"
    }
}
