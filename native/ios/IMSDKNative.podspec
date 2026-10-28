Pod::Spec.new do |s|
  s.name = 'IMSDKNative'
  s.version = '0.1.1'
  s.summary = 'Native iOS facade for the independent IM SDK.'
  s.description = 'Embeds one Flutter engine and exposes a Swift/Objective-C chat interface.'
  s.homepage = 'https://localhost/imsdk'
  s.license = { :type => 'Private', :text => 'Distribution terms must be confirmed by the project owner.' }
  s.author = 'IMSDK project'
  s.source = { :path => '.' }
  s.source_files = 'Sources/**/*.{swift,h,m}'
  s.public_header_files = 'Sources/IMSDKPluginRegistration.h'
  s.platform = :ios, '15.0'
  s.swift_version = '5.0'
  s.static_framework = true
  s.dependency 'Flutter'
  s.frameworks = 'UIKit'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  # GeneratedPluginRegistrant is resolved by name; keep Objective-C registry classes in release links.
  s.user_target_xcconfig = { 'OTHER_LDFLAGS' => '$(inherited) -ObjC' }
end
