//  LinkedinSwiftApplication.m
//  LinkedinSwift
//
//  Created by PranayPatel on 11/05/18.
//  Copyright © 2018 Simform Solutions Pvt.Ltd. All rights reserved.
//

import UIKit
import Foundation

class LinkedinSwiftConfiguration {
    let clientId: String?
    let clientSecret: String?
    let state: String?
    let permissions: Array<Any>
    let redirectUrl: String?
    
    init(clientId: String?, clientSecret: String?, state: String?, permisssions: Array<Any>, redirectUrl: String? ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.state = state
        self.permissions = permisssions
        self.redirectUrl = redirectUrl
    }
    
}
