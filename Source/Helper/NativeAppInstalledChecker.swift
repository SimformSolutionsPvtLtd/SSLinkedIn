//
//  NativeAppInstalledChecker.swift
//  LinkedinSwift
//
//  Created by PranayPatel on 11/05/18.
//  Copyright © 2018 Simform Solutions Pvt.Ltd. All rights reserved.
//

import UIKit

class NativeAppInstalledChecker {
    
    var linkedinAppScheme: String?
    init() {

        linkedinAppScheme = "linkedin://"
    }

    func checkIfAppSchemeExist(_ appScheme: String?) -> Bool {
        if let aScheme = URL(string: appScheme ?? "") {
            return UIApplication.shared.canOpenURL(aScheme)
        }
        return false
    }

    func isLinkedinAppInstalled() -> Bool {
        return checkIfAppSchemeExist(linkedinAppScheme)
    }
    
}
