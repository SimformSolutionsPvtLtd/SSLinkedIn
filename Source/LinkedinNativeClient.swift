

//  LinkedinNativeClient.swift
//  LinkedinSwift
//
//  Created by PranayPatel on 11/05/18.
//  Copyright © 2018 Simform Solutions Pvt.Ltd. All rights reserved.
//
import  UIKit
import Foundation

enum LinkedinSwiftRequestType : String {
    case LinkedinSwiftRequestGet = "GET"
    case LinkedinSwiftRequestPOST = "POST"
    case LinkedinSwiftRequestPUT = "PUT"
    case LinkedinSwiftRequestDELETE = "DELETE"
}

typealias LinkedinSwiftRequestSuccessCallback = (_ response: LSResponse) -> Void
/**
 *  LinkedinSwiftAuthRequestSuccessCallback
 *
 *  @param token LSLinkedinToken
 */
typealias LinkedinSwiftAuthRequestSuccessCallback = (_ token: LSLinkedinToken) -> Void
/**
 *  LinkedinSwiftRequestErrorCallback
 *
 *  @param error NSError
 */
typealias LinkedinSwiftRequestErrorCallback = (_ error: Error) -> Void
/**
 *  LinkedinSwiftRequestCancelCallback
 */
typealias LinkedinSwiftRequestCancelCallback = () -> Void

protocol LinkedinClient {
    /**
     *  Login with Linkedin to get accessToken
     *
     *  @param success  callback
     *  @param error    callback
     *  @param cancel   callback
     */
    func authorizeSuccess(_ success: LinkedinSwiftAuthRequestSuccessCallback?, error: LinkedinSwiftRequestErrorCallback?, cancel: LinkedinSwiftRequestCancelCallback?)
    /**
     *  Request Linkedin api
     *
     *  @param url         api url
     *  @param requestType requst type, for now only support GET
     *  @param token       LSLiknedinToken to use request the api call
     *  @param success     callback
     *  @param error       callback
     */
    func requestURL(_ url: String, requestType: LinkedinSwiftRequestType, token: LSLinkedinToken, success: LinkedinSwiftRequestSuccessCallback?, error: LinkedinSwiftRequestErrorCallback?)
    
    func shareOnLinked(_ url: String, requestType: LinkedinSwiftRequestType, data payload: Data?, token: LSLinkedinToken, success successCallback: LinkedinSwiftRequestSuccessCallback?, error errorCallback: LinkedinSwiftRequestErrorCallback?)
    
    /**
     Logout current session
     */
    func logout()
}

class LinkedinNativeClient : NSObject, LinkedinClient {
  
    
    var permissions = [Any]()
  
    init(permissions _permissions: [Any]?) {
        super.init()
        permissions = _permissions!
    }
    
    func authorizeSuccess(_ successCallback: LinkedinSwiftAuthRequestSuccessCallback?, error errorCallback: LinkedinSwiftRequestErrorCallback?, cancel cancelCallback: LinkedinSwiftRequestCancelCallback?) {
        /**
         *  If Linkedin app installed, use Linkedin sdk
         */
        var session = LISDKSessionManager.sharedInstance().session
        // check if session is still cached
        
        if session != nil && (session?.isValid())! {
            
            let token = LSLinkedinToken.init(accessToken: session?.accessToken.accessTokenValue, expireDate: session?.accessToken.expiration, isFromMobileSDK: true)
            successCallback!(token)
        } else {
            // no cache, create a new session
            LISDKSessionManager.createSession(withAuth: permissions, state: "GET-ACCESS-TOKEN", showGoToAppStoreDialog: true, successBlock: {(_ returnState: String?) -> Void in
                // refresh session
                session = LISDKSessionManager.sharedInstance().session
                let token = LSLinkedinToken(accessToken: session?.accessToken.accessTokenValue, expireDate: session?.accessToken.expiration, isFromMobileSDK: true)
                successCallback!(token)
            }, errorBlock: {(_ error: Error?) -> Void in
                // error code 3 means user cancelled, LISDKErrorCode.USER_CANCELLED doesn't work
                if (error as NSError?)?.code == 3 {
                    cancelCallback!()
                } else {
                    errorCallback!(error!)
                }
            })
        }
    }
    
    func requestURL(_ url: String, requestType: LinkedinSwiftRequestType, token: LSLinkedinToken, success successCallback: LinkedinSwiftRequestSuccessCallback?, error errorCallback: LinkedinSwiftRequestErrorCallback?) {
        LISDKAPIHelper.sharedInstance().getRequest(url, success: {(_ response: LISDKAPIResponse?) -> Void in
            successCallback!(LSResponse.init(string: response?.data, statusCode: Int((response?.statusCode)!)))
        }, error: {(_ error: LISDKAPIError?) -> Void in
            errorCallback!(error!)
        })
    }

    func shareOnLinked(_ url: String, requestType: LinkedinSwiftRequestType, data payload: Data?, token: LSLinkedinToken, success successCallback: LinkedinSwiftRequestSuccessCallback?, error errorCallback: LinkedinSwiftRequestErrorCallback?) {
        if LISDKSessionManager.hasValidSession()
        {
            LISDKAPIHelper.sharedInstance().postRequest(url, body: payload, success: {(_ response: LISDKAPIResponse?) -> Void in
                successCallback!(LSResponse.init(string: response?.data, statusCode: Int((response?.statusCode)!)))
            }, error: {(_ error: LISDKAPIError?) -> Void in
                errorCallback!(error!)
            })
        }
     
    }
    
    func logout() {
        LISDKSessionManager.clearSession()
    }
}
