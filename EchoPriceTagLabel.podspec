#
#  Be sure to run `pod spec lint EchoPriceTagLabel.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name         = "EchoPriceTagLabel"
  s.version      = "0.0.2"
  s.summary      = "A label for displaying price tag gracefully."

  s.description  = <<-DESC
        A tiny library for calculating tip. Just for fun for the time being.
                   DESC

  s.homepage     = "https://github.com/guoyingtao/PriceTagLabel"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Yingtao Guo" => "guoyingtao@outlook.com" }
  s.social_media_url   = "http://twitter.com/guoyingtao"
  s.platform     = :ios
  s.ios.deployment_target = '10.0'
  s.source       = { :git => "https://github.com/guoyingtao/PriceTagLabel.git", :tag => "#{s.version}" }
  s.source_files  = "PriceTagLabel/*"

end