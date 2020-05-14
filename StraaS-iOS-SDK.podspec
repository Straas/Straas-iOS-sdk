Pod::Spec.new do |s|


  s.name         = "StraaS-iOS-SDK"
  s.version      = "0.51.0"
  s.summary      = "StraaS.io iOS SDK"

  s.description  = "StraaS.io - Streaming as a Service, Your Best OTT Solution."

  s.homepage     = "https://github.com/StraaS/StraaS-iOS-sdk"
  s.license      = { :type => "Copyright", :text => "Copyright (c) 2020 StraaS.io. All rights reserved." }
  s.author       = "StraaS.io"

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/StraaS/StraaS-iOS-sdk.git",
                     :tag => "0.51.0" }
  s.static_framework = true
  s.resource_bundles = {
    'StraaSPlayerSDK' => ['ios/StraaSPlayerSDK.framework/Assets.car', 'ios/StraaSPlayerSDK.framework/*.lproj'],
    'StraaSMessagingSDK' => ['ios/StraaSMessagingSDK.framework/*.lproj']
  }

  s.subspec 'Messaging' do |msg|
    msg.vendored_frameworks = "ios/StraaSMessagingSDK.framework"
    msg.dependency "StraaS-iOS-SDK/Core"
    msg.dependency "Socket.IO-Client-Swift", "~> 15.1.0"
  end
  s.subspec 'Core' do |co|
    co.vendored_frameworks = "ios/StraaSCoreSDK.framework"
    co.dependency "AFNetworking", "~> 4.0.0"
    co.dependency "Socket.IO-Client-Swift", "~> 15.1.0"
  end
  s.subspec 'Streaming' do |streaming|
    streaming.vendored_frameworks = "ios/StraaSStreamingSDK.framework"
    streaming.dependency "StraaS-iOS-SDK/Core"
    streaming.dependency "GPUImage-StraaS", "~> 0.1.9"
    streaming.dependency "HaishinKit-Straas", "~> 1.0.9"
  end
  s.subspec 'Player' do |player|
    player.vendored_frameworks = "ios/StraaSPlayerSDK.framework"
    player.dependency "StraaS-iOS-SDK/Core"
    player.dependency "Socket.IO-Client-Swift", "~> 15.1.0"
    player.dependency "GoogleAds-IMA-iOS-SDK", "~> 3.6.0"
    player.dependency "KVOController", "~> 1.2.0"
    player.dependency "AFNetworking", "~> 4.0.0"
  end
  s.subspec 'PlayerLowLatencyExtension' do |playerLowLatencyExtension|
    playerLowLatencyExtension.vendored_frameworks = "ios/StraaSPlayerLowLatencyExtensionSDK.framework"
    playerLowLatencyExtension.dependency "StraaS-iOS-SDK/Player"
  end
end