#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_invitereferrals.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_invitereferrals'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter InviteReferrals plugin.'
  s.description      = 'Allows you to easily add InviteReferrals to your flutter projects'
  s.homepage         = 'https://www.invitereferrals.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Neeraj Sharma' => 'neeraj.s@notifyvisitors.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'InviteReferrals', '4.5.2'
  s.ios.deployment_target = '8.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
