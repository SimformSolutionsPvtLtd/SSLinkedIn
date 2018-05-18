//
//  LSResponse.swift
//  LinkedinSwift
//
//  Created by PranayPatel on 11/05/18.
//  Copyright © 2018 Simform Solutions Pvt.Ltd. All rights reserved.
//

import Foundation
import UIKit

class LSResponse: NSObject {
    
    /**
     *  Init with string
     *
     *  @param string      string response
     *  @param _statusCode http status code
     *
     *  @return LSResponse
     */
    var statusCode: Int? = nil
    var jsonObject: [String: AnyObject]? = nil
    
    convenience init(string: String?, statusCode: Int) {
        self.init(data: string?.data(using: .utf8), statusCode: statusCode)
    }
    /**
     *  Init with data
     *
     *  @param _data       data resopnse
     *  @param _statusCode http status code
     *
     *  @return LSResponse
     */
    convenience init(data: Data?, statusCode: Int) {
        let error: Error? = nil
        var json: Any? = nil
        if let aData = data {
            json = try? JSONSerialization.jsonObject(with: aData, options: [])
        }
        if json != nil && error == nil {
            
            self.init(dictionary: json as? [String: AnyObject], statusCode: statusCode)
        }
        else {
            self.init(dictionary: [:], statusCode: statusCode)
        }
    }
    /**
     *  Init with json dictionary
     *
     *  @param _dictionary dictionary
     *  @param _statusCode http status code
     *
     *  @return LSResponse
     */
    convenience init(dictionary: [String: AnyObject]?, statusCode: Int) {
        self.init()
        self.jsonObject = dictionary
        self.statusCode = statusCode
    }
    
    override init() {
        super.init()
    }
    
    func description() -> String? {
        return "<LSResponse - data: \(jsonObject), status code: \(statusCode)>"
    }
    
}
