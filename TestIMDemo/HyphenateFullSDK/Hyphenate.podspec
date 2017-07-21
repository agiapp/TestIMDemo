Pod::Spec.new do |spec|
  spec.name         = 'Hyphenate'
  spec.version      = '3.3.2'
  spec.license       = { :type => 'Copyright', :text => 'EaseMob Inc. 2017' }
  spec.summary      = 'An Objective-C client for IM service'
  spec.description  = 'Hyphenate is a cloud-based PaaS (Platform as a Service) for Mobile Instant Messaging (MIM). We provide in-app messaging features such as one-to-one chat, group chat, voice message, picture/video/file sharing, location sharing, real-time voice/video calling, etc.'
  spec.homepage     = 'https://www.hyphenate.io/'
  spec.author       = {'Hyphenate Inc.' => 'info@hyphenate.io'}
  spec.source       = {:path=> './' }
  spec.platform     = :ios, '8.0'
  spec.requires_arc = true
  spec.preserve_paths = 'Hyphenate.framework'
  spec.vendored_frameworks = 'Hyphenate.framework'
  spec.xcconfig     = {'OTHER_LDFLAGS' => '-ObjC'}
end
