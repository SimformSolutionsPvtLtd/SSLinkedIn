//
//  LinkedinSwiftHelper.swift
//  LinkedinSwift
//
//  Created by PranayPatel on 11/05/18.
//  Copyright © 2018 Simform Solutions Pvt.Ltd. All rights reserved.
//

import UIKit


class LinkedinSwiftHelper : NSObject  {
   
    
    var lsAccessToken : LSLinkedinToken?
    private var configuration: LinkedinSwiftConfiguration?
    private var checker: NativeAppInstalledChecker?
    private  var nativeClient : LinkedinClient?
    private  var webClient :  LinkedinClient?

// MARK: -
// MARK: Static functions
    class func isLinkedinAppInstalled() -> Bool {
        return NativeAppInstalledChecker().isLinkedinAppInstalled()
    }

    class func shouldHandle(_ url: URL?) -> Bool {
        return self.isLinkedinAppInstalled() && LISDKCallbackHandler.shouldHandle(url)
    }

    class func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: String?) -> Bool {
        return self.isLinkedinAppInstalled() && LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

// MARK: -
// MARK: Initialization
    convenience  init( _configuration: LinkedinSwiftConfiguration?) {
        self.init(_configuration: _configuration!, nativeAppChecker: nil, clients: nil, webOAuthPresent: nil, persistedLSToken: nil)
    }

    convenience init( _configuration: LinkedinSwiftConfiguration, nativeAppChecker _checker: NativeAppInstalledChecker?, clients: [LinkedinClient?]?, webOAuthPresent presentViewController: UIViewController?, persistedLSToken lsToken: LSLinkedinToken?) {
       self.init()
        if _checker == nil {
            checker = NativeAppInstalledChecker()
            // create default NativeAppInstalledChecker if user not passing one
        } else {
            checker = _checker
        }
        if lsToken != nil {
            lsAccessToken = lsToken!
        }
        if clients == nil {
            nativeClient = LinkedinNativeClient(permissions: _configuration.permissions)
            webClient = LinkedinOAuthWebClient(redirectURL: _configuration.redirectUrl, clientId: _configuration.clientId, clientSecret: _configuration.clientSecret, state: _configuration.state, permissions: _configuration.permissions, present: presentViewController)
        } else {
            // first is the native client, second is the web client
            nativeClient = clients?[0]
            webClient = clients?[1]
        }
        configuration = _configuration
    
    }
    
    override init() {
        super.init()
    }

// MARK: -
// MARK: Authorization
    
    
    func authorizeSuccess(_ successCallback: @escaping LinkedinSwiftAuthRequestSuccessCallback, error errorCallback: @escaping LinkedinSwiftRequestErrorCallback, cancel cancelCallback: @escaping LinkedinSwiftRequestCancelCallback) {
        /**
             *  If previous token still in memory callback directly
             */
        if lsAccessToken != nil && Double((lsAccessToken?.expireDate?.timeIntervalSinceNow)!) > 0 {
            successCallback(lsAccessToken!)
        } else {
            let this: LinkedinSwiftHelper? = self
            let __successCallback: LinkedinSwiftAuthRequestSuccessCallback = {(_ token: LSLinkedinToken) -> Void in
                    this?.lsAccessToken = token
                successCallback((this?.lsAccessToken)!)
                }
            let client: LinkedinClient? = checker?.isLinkedinAppInstalled() ?? false ? nativeClient : webClient
            client?.authorizeSuccess(__successCallback, error: errorCallback, cancel: cancelCallback)
        }
    }

    func logout() {
        lsAccessToken = nil
        /// logout all sessions
        nativeClient?.logout()
        webClient?.logout()
    }

// MARK: -
// MARK: Request
    func requestURL(_ url: String?, requestType: LinkedinSwiftRequestType?, success successCallback: @escaping LinkedinSwiftRequestSuccessCallback, error errorCallback: @escaping LinkedinSwiftRequestErrorCallback) {
        // Only can make request after logged in
        if lsAccessToken != nil {
            // for now only GET is needed :)
        
            if requestType == LinkedinSwiftRequestType.LinkedinSwiftRequestGet {
                let client: LinkedinClient? = (lsAccessToken?.isFromMobileSDK)! ? nativeClient : webClient
                client?.requestURL(url!, requestType: requestType!, token: lsAccessToken!, success: successCallback, error: errorCallback)
            }
        }
    }
    func postOnLinked(_ url: String, requestType: LinkedinSwiftRequestType, data payload: Data?, success successCallback: LinkedinSwiftRequestSuccessCallback, error errorCallback: LinkedinSwiftRequestErrorCallback) {
        // Only can make request after logged in
        if lsAccessToken != nil {
            // for now only GET is needed :)
            if requestType == LinkedinSwiftRequestType.LinkedinSwiftRequestPOST {
                let client: LinkedinClient? = (lsAccessToken?.isFromMobileSDK)! ? nativeClient : webClient
                client?.shareOnLinked(url, requestType: requestType, data: payload, token: lsAccessToken!, success: {(_ response: LSResponse) -> Void in
                    
                }, error: {(_ error: Error) -> Void in
                    
                })
            }
        }
    }
}
