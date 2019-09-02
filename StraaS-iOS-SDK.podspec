Pod::Spec.new do |s|


  s.name         = "StraaS-iOS-SDK"
  s.version      = "0.45.0"
  s.summary      = "StraaS.io iOS SDK"

  s.description  = "StraaS.io - Streaming as a Service, Your Best OTT Solution."

  s.homepage     = "https://github.com/StraaS/StraaS-iOS-sdk"
  s.license      = { :type => "Copyright", :text => "Copyright (c) 2018 StraaS.io. All rights reserved." }
  s.author       = "StraaS.io"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/StraaS/StraaS-iOS-sdk.git",
                     :tag => "0.45.0" }

  s.subspec 'Messaging' do |msg|
    msg.vendored_frameworks = "ios/StraaSMessagingSDK.framework"
    msg.dependency "StraaS-iOS-SDK/Core"
    msg.dependency "Socket.IO-Client-Swift", '~> 15.1.0'
  end
  s.subspec 'Core' do |co|
    co.vendored_frameworks = "ios/StraaSCoreSDK.framework"
    co.dependency "AFNetworking", "~>3.0"
    co.dependency "Socket.IO-Client-Swift", '~> 15.1.0'
  end
  s.subspec 'Streaming' do |streaming|
    streaming.vendored_frameworks = "ios/StraaSStreamingSDK.framework"
    streaming.dependency "StraaS-iOS-SDK/Core"
    streaming.dependency "DSGPUImage", "0.1.8"
  end
  s.subspec 'Player' do |player|
    player.vendored_frameworks = "ios/StraaSPlayerSDK.framework"
    player.dependency "StraaS-iOS-SDK/Core"
    player.dependency "GoogleAds-IMA-iOS-SDK", "~> 3.3"
    player.dependency "KVOController", "~>1.1.0"
    player.dependency "Socket.IO-Client-Swift", '~> 15.1.0'
  end
  s.subspec 'PlayerLowLatencyExtension' do |playerLowLatencyExtension|
    playerLowLatencyExtension.vendored_frameworks = "ios/StraaSPlayerLowLatencyExtensionSDK.framework"
    playerLowLatencyExtension.dependency "StraaS-iOS-SDK/Player"
  end
  s.subspec 'Circall' do |circall|
    circall.vendored_frameworks = "ios/StraaSCircallSDK.framework"
    circall.dependency "StraaS-iOS-SDK/Core"
    circall.dependency "Socket.IO-Client-Swift", '~> 15.1.0'
    circall.dependency "PodRTC", "65.8.0.0"
    circall.pod_target_xcconfig = {
      'ENABLE_BITCODE' => 'NO',
      'SWIFT_VERSION' => '4.0',
      'VALID_ARCHS' => 'x86_64 arm64'
    }
  end
end
