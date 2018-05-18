//
//  LSLinkedinToken.swift
//  LinkedinSwift
//
//  Created by PranayPatel on 11/05/18.
//  Copyright © 2018 Simform Solutions Pvt.Ltd. All rights reserved.
//

import  UIKit
import  Foundation

class LSLinkedinToken: NSObject {
    
    var accessToken: String?
    var expireDate: Date?
    var isFromMobileSDK: Bool?
    
    override init() {
        super.init()
    }
    
    convenience init(accessToken: String?, expireDate: Date?, isFromMobileSDK: Bool) {
        self.init()
        self.accessToken = accessToken
        self.expireDate = expireDate
        self.isFromMobileSDK = isFromMobileSDK
    }
    
    func description() -> String? {
        return "<LSLinkedinToken - accessToken: \(String(describing: accessToken)), expireDate: \(String(describing: expireDate))>"
    }

}
