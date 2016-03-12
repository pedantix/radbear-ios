SUMMARY = "an iOS library to help build apps served by a restful api, such as Rails"

Pod::Spec.new do |s|
  s.name             = "radbear-ios"
  s.version          = "0.0.1"
  s.summary          = SUMMARY
  s.description      = SUMMARY
  s.homepage         = "https://github.com/radicalbear/radbear-ios"
  s.license          = { :type => 'BSD' }
  s.authors           = { "Gary Foster" => "gary@radicalbear.com", "Shaun Hubbard" => "shaunhubbard2013@icloud.com" }
  s.source           = { :git => "https://github.com/radicalbear/radbear-ios.git", branch: "swh-lint-pod" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/*.{h,m}'
  s.resources = ['Assets/*', 'Test']
  
  s.prefix_header_contents = "#import <SystemConfiguration/SystemConfiguration.h>\n#import <MobileCoreServices/MobileCoreServices.h>"

  s.dependency 'SDWebImage'
  s.dependency 'RestKit',                    '~> 0.20.0'
  s.dependency 'Reachability',               '3.1.1'
  s.dependency 'FBSDKCoreKit',               '~> 4.8.0'
  s.dependency 'FBSDKLoginKit',              '~> 4.8.0'
  s.dependency 'MWPhotoBrowser',             '~> 2.1.1'
  s.dependency 'DejalActivityView',          '1.0'
  s.dependency 'BButton',                    '3.2.3'
  s.dependency 'FontAwesomeKit/FontAwesome', '2.2.0'
  s.dependency 'NewRelicAgent',              '~> 5'
  s.dependency 'CocoaHTTPServer', '~> 2.3'
end
