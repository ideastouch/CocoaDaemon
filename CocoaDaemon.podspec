Pod::Spec.new do |s|
  s.name = 'CocoaDaemon'
  s.version = '0.9.1'
  s.summary = 'Daemon Kit to manage background closures to be called each set period of time.'
  s.homepage = 'https://github.com/ideastouch/CocoaDaemon'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Gustavo Halperin' => 'gustavoh@ideastouch.com' }
  s.social_media_url = 'http://twitter.com/ideastouch'
  s.ios.deployment_target = '11.0'
  s.swift_version = '4.2'
  s.platform = :ios, '11.0'
  s.source = { :git => 'https://github.com/ideastouch/CocoaDaemon.git', :tag => s.version.to_s }
  s.source_files = 'CocoaDaemon/CocoaDaemon/*.{h,swift}'
  s.requires_arc = true
end
