# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'WxLiveGiftPlayer' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WxLiveGiftPlayer

  pod 'libpag'
  pod 'SnapKit'
#  pod 'Vapor'
  pod "GCDWebServer"
  
  pod "HaishinKit", "1.8.0"
  pod 'LFLiveKit'
  pod 'HMSSDK'
  
  pod 'DoraemonKit/Core'
  pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']

  target 'WxLiveGiftPlayerTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13'
    end
  end
end
