//
//  Vehicle.swift
//  AutoSeller
//
//  Created by Vitaliy Delidov on 10/9/15.
//  Copyright © 2015 Vitaliy Delidov. All rights reserved.
//

import Foundation

class Vehicle: PFObject, PFSubclassing {
    
    var type: String?
    var model: String?
    var color: String?
    var condition: String?
    var imageFile: PFFile?
    var ownerID: PFObject?
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Vehicle"
    }
}
