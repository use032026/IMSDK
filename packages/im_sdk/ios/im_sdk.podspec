Pod::Spec.new do |s|
  s.name             = 'im_sdk'
  s.version          = '0.1.2'
  s.summary          = 'IM SDK platform media adapters.'
  s.description      = 'Platform media and diagnostics adapters for the independent IM SDK.'
  s.homepage         = 'https://localhost/imsdk'
  s.license          = { :type => 'Private', :text => 'Distribution terms must be confirmed by the project owner.' }
  s.author           = 'IMSDK project'
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.swift_version = '5.0'
  s.static_framework = true
  s.frameworks = 'Photos'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
