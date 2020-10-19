#
# Be sure to run `pod lib lint FloatingSheetAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FloatingSheetAlert'
  s.version          = '0.0.1'
  s.summary          = 'Test 2 of FloatingSheetAlert.'
  s.swift_versions = ['5.0']

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is test 2. Create pod spec
                       DESC

  s.homepage         = 'https://github.com/Single-sh/FloatingSheetAlert'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shevchenko.a.i14@gmail.com' => 'shevchenko.a.i14@gmail.com' }
  s.source           = { :git => 'https://github.com/Single-sh/FloatingSheetAlert.git', :tag => '0.0.1' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  

  s.source_files = 'FloatingSheetAlert/Classes/**/*'
  
   s.resource_bundles = {
     'FloatingSheetAlert' => ['FloatingSheetAlert/Assets/*.{png, svg}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
