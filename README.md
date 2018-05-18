## SSLinkedIn

LinkedinSwift is a project for managing native LinkedIn SDK using  [CocoaPods](https://cocoapods.org/)

Linkedin Oauth Helper, depend on Linkedin Native App installed or not, using Linkdin IOS SDK or UIWebView to login, support Swift with iOS 7

Latest version is based on  [LinkedIn SDK 1.0.7](https://content.linkedin.com/content/dam/developer/sdk/iOS/li-ios-sdk-1.0.6-release.zip)  and  [IOSLinkedinAPI for webview auth](https://github.com/jeyben/IOSLinkedInAPI).


## How to use

    pod 'SSLinkedIn', '~> 1.0'


  
Check out Example project.
#### Setup configuration and helper instance.
    let linkedinHelper = LinkedinSwiftHelper(configuration:
		LinkedinSwiftConfiguration(
	        clientId: "77tn2ar7gq6lgv",
	        clientSecret: "iqkDGYpWdhf7WKzA", 
	        state: "DLKDJF46ikMMZADfdfds", 
	        permisssions: ["r_basicprofile", "r_emailaddress","w_share"]
        )
    )
    
#### Or if you want to present in a different ViewController, using:

    let linkedinHelper = LinkedinSwiftHelper(
        configuration: LinkedinSwiftConfiguration(
	        clientId: "77tn2ar7gq6lgv",
	        clientSecret: "iqkDGYpWdhf7WKzA",
	        state: "DLKDJF45DIWOERCM",
	        permissions: ["r_basicprofile", "r_emailaddress","w_share"]
       ), webOAuthPresent: yourViewController
    )

#### Setup LinkedIn SDK Setting : [instruction here](https://developer.linkedin.com/docs/ios-sdk)
#### Setup redirect handler in AppDelegate

    func application(application: UIApplication,
		    openURL url:NSURL,
		    sourceApplication: String?,
		    annotation: AnyObject) -> Bool {
		// Linkedin sdk handle redirect
		if LinkedinSwiftHelper.shouldHandleUrl(url) {
			return LinkedinSwiftHelper.application(application,
				openURL: url,
				sourceApplication: sourceApplication,
				annotation: annotation
		  )
	   }
		return false
	}
	
#### ⚠️  for iOS 9 and above use this instead:

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
		if  LinkedinSwiftHelper.shouldHandle(url) {
				return LinkedinSwiftHelper.application(app, open:url, sourceApplication: nil, annotation: nil)
		}
		return  false
	}
#### Login Method :

    linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
	    // Login success lsToken
	}, error: { [unowned self] (error) -> Void in
		// Encounter error: error.localizedDescription
	}, cancel: { [unowned self] () -> Void in
		// User Cancelled
	})

#### Fetch Profile :

    linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~?format=json",
	    requestType: LinkedinSwiftRequestGet,
	    success: { (response) -> Void in
	    //Request success response
    }) { [unowned self] (error) -> Void in
	    //Encounter error
    }
#### Share Content : 

    let dictionary = ["Comment": "Check out developer.linkedin.com! http://linkd.in/1FC2PyG", "visibility": ["code": "anyone"]] as [String: AnyObject]
    let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
    linkedinHelper.postOnLinked("https://api.linkedin.com/v1/people/~/shares", requestType: LinkedinSwiftRequestType.LinkedinSwiftRequestPOST,
		     data: jsonData, success: { (response) in
			 // Request success with response
	}) { [unowned self] (error) in
			// Encounter error: error.localizedDescription
		}
	}
#### Logout : 

    linkedinHelper.logout()
## Known issues
 It seems Linkedin 1.0.7 messed up with  `Bitcode support.`  again. You need to turn off Bitcode to make it work.- seems can turn on Bitcode now.
