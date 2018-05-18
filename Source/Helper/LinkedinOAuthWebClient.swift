//
//  LinkedinOAuthWebClient.swift
//  LinkedinSwift
//
//  Created by PranayPatel on 11/05/18.
//  Copyright © 2018 Simform Solutions Pvt.Ltd. All rights reserved.
//

import Foundation
import UIKit


class LinkedinOAuthWebClient : NSObject , LinkedinClient {
    func shareOnLinked(_ url: String, requestType: LinkedinSwiftRequestType, data payload: Data?, token: LSLinkedinToken, success successCallback: LinkedinSwiftRequestSuccessCallback?, error errorCallback: LinkedinSwiftRequestErrorCallback?) {
    }
  
    var httpClient : LIALinkedInHttpClient?
    let lsResponse : LSResponse? = nil
    let lslinkedinToken : LSLinkedinToken? = nil
    
     init(redirectURL: String?, clientId: String?, clientSecret: String?, state: String?, permissions: [Any]?, present presentViewController: UIViewController?) {
        let application = LIALinkedInApplication(redirectURL: redirectURL, clientId: clientId, clientSecret: clientSecret, state: state, grantedAccess: permissions)
        httpClient = LIALinkedInHttpClient(for: application, presentingViewController: presentViewController)
    }
   
    func authorizeSuccess(_ successCallback: LinkedinSwiftAuthRequestSuccessCallback?, error errorCallback: LinkedinSwiftRequestErrorCallback?, cancel cancelCallback: LinkedinSwiftRequestCancelCallback?) {
        let this: LinkedinOAuthWebClient? = self
        /**
             *  If Linkedin app is not installed, present a model webview to let use login
             *
             *  WARNING: here we can check the cache save api call as well,
             *  but there is a problem when you login on other devices the accessToken you cached will invalid,
             *  and only you use this will be notice this, so I choose don't use this cache
             */
        httpClient?.getAuthorizationCode({(_ code: String?) -> Void in
            this?.httpClient?.getAccessToken(code, success: {(_ dictionary: [AnyHashable: Any]?) -> Void in
                let accessToken = dictionary?["access_token"] as? String
                let expiresInSec = dictionary?["expires_in"] as? NSNumber
                let token = LSLinkedinToken(accessToken: accessToken, expireDate: Date(timeIntervalSinceNow:
                    TimeInterval(Double(expiresInSec ?? 0.0))), isFromMobileSDK: false)
                successCallback!(token)
            }, failure: {(_ error: Error?) -> Void in
                errorCallback!(error!)
            })
        }, cancel: {() -> Void in
            cancelCallback!()
        }, failure: {(_ error: Error?) -> Void in
            errorCallback!(error!)
        })
    }

    func requestURL(_ url: String, requestType: LinkedinSwiftRequestType, token: LSLinkedinToken, success successCallback: LinkedinSwiftRequestSuccessCallback?, error errorCallback: LinkedinSwiftRequestErrorCallback?) {
        #if isSessionManager
            httpClient.get(url, parameters: ["oauth2_access_token": token.accessToken], progress: nil, success: {(_ task: URLSessionDataTask, _ responseObject: Any?) -> Void in
                successCallback(LSResponse(dictionary: responseObject, statusCode: 200))
            }, failure: {(_ task: URLSessionDataTask?, _ error: Error) -> Void in
                errorCallback(error)
            })
        #else
//            httpClient?.get(url, parameters: ["oauth2_access_token": token.accessToken], success: {(_ task: URLSessionDataTask, _ responseObject: Any?) -> Void in
//                successCallback(LSResponse(dictionary: responseObject, statusCode: 200))
//            }, failure: {(_ task: URLSessionDataTask?, _ error: Error) -> Void in
//                errorCallback(error)
//            })
        #endif
    }

    func logout() {
        let userDefaults = UserDefaults.standard
        /// for now use key directly from there
        /// TODO: move this function to LIALinkedinAPI
        userDefaults.removeObject(forKey: "linkedin_token")
        userDefaults.removeObject(forKey: "linkedin_expiration")
        userDefaults.removeObject(forKey: "linkedin_token_created_at")
        userDefaults.synchronize()
    }
}
