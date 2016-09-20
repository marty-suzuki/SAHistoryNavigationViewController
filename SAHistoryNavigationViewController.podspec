#
# Be sure to run `pod lib lint SAHistoryNavigationViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SAHistoryNavigationViewController"
  s.version          = "3.0.0"
  s.summary          = "SAHistoryNavigationViewController realizes iOS task manager like UI in UINavigationContoller."

  s.homepage         = "https://github.com/marty-suzuki/SAHistoryNavigationViewController"
  s.license          = 'MIT'
  s.author           = { "Taiki Suzuki" => "s1180183@gmail.com" }
  s.source           = { :git => "https://github.com/marty-suzuki/SAHistoryNavigationViewController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/marty_suzuki'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SAHistoryNavigationViewController/*.{swift}'
  # s.resource_bundles = {
  #   'SAHistoryNavigationViewController' => ['Pod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AudioToolbox'
  s.dependency 'MisterFusion'
end
