Pod::Spec.new do |s|
  s.name             = "radbear-ios-test"
  s.version          = "0.0.1"
  s.summary          = "test support for radbear-ios"
  s.description      = <<-DESC
                       test support for radbear-ios
                       DESC
  s.homepage         = "https://github.com/radicalbear/radbear-ios"
  s.license          = 'MIT'
  s.author           = { "Gary Foster" => "gary@radicalbear.com" }
  s.source           = { :git => "https://github.com/radicalbear/radbear-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Test'

  s.dependency 'CocoaHTTPServer', '~> 2.3'
end
