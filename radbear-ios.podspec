Pod::Spec.new do |s|
  s.name             = "radbear-ios"
  s.version          = "0.1.0"
  s.summary          = "an iOS library to help build apps served by a Rails api"
  s.description      = <<-DESC
                       an iOS library to help build apps served by a Rails api
                       DESC
  s.homepage         = "https://github.com/radicalbear/radbear-ios"
  s.license          = 'MIT'
  s.author           = { "Gary Foster" => "gary@radicalbear.com" }
  s.source           = { :git => "https://github.com/radicalbear/radbear-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets/*'
  
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
end
