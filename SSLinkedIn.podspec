#
#  Be sure to run `pod spec lint SSLinkedIn.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SSLinkedIn"
  s.version      = "1.0.0"
  s.summary      = "Linkedin Oauth Helper, depend on Linkedin Native App installed or not, using Linkdin IOS SDK or UIWebView to login, support Swift with iOS 9"


  s.homepage     = "https://github.com/simformsolutions/SSLinkedIn.git"
  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "PranayPatel" => "Pranay.p@simformsolutions.com" }
 
  s.platform     = :ios
  s.platform     = :ios, "9.1"

  s.source       = { :git => "https://github.com/simformsolutions/SSLinkedIn.git", :tag => "#{s.version}" }

  s.source_files  = 'Source/Helper/*.*', 'Source/Entities/*.*'

  s.preserve_paths      = 'Source/frameworks/*.*'
  s.vendored_frameworks = 'Source/frameworks/*.*'
  s.framework     = "linkedin-sdk"
  s.requires_arc  = true
  
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'IOSLinkedInAPIFix', '~> 2.0.4'

end
