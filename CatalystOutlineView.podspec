Pod::Spec.new do |spec|
    spec.name             = 'CatalystOutlineView'
    spec.version          = '0.1.2'
    spec.summary          = 'NSOutlineView for UIKit (recreation of popular control from AppKit)'
  
    spec.ios.deployment_target = '13.0'
    spec.platform     = :ios, "13.0"


    spec.homepage         = 'https://github.com/InstaRobot/CatalystOutlineView'
    spec.license          = { :type => 'MIT', :file => 'LICENSE' }
    spec.author           = { 'DEVLAB' => 'v.podolskiy@devlab.studio' }
    spec.source           = { :git => 'https://github.com/InstaRobot/CatalystOutlineView.git', :tag => spec.version.to_s }
    spec.social_media_url = 'https://twitter.com/StudioDevlab'
    spec.swift_version    = '5.0'
    spec.requires_arc = true
  
    spec.source_files = 'CatalystOutlineView/**/*.swift'
end