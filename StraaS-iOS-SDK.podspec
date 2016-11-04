Pod::Spec.new do |s|

  s.name         = "StraaS-iOS-SDK"
  s.version      = "0.6.0"
  s.summary      = "StraaS.io iOS SDK"

  s.description  = "StraaS.io - Streaming as a Service, Your Best OTT Solution."

  s.homepage     = "https://github.com/StraaS/StraaS-iOS-sdk"
  s.license      = { :type => "Copyright", :text => "Copyright (c) 2016 StraaS.io. All rights reserved." }
  s.author       = "StraaS.io"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/StraaS/StraaS-iOS-sdk.git",
                     :tag => "0.6.0" }

  s.subspec 'Messaging' do |msg|
    msg.vendored_frameworks = "ios/StraaSMessagingSDK.framework"
    msg.dependency "StraaS-iOS-SDK/Core"
  end
  s.subspec 'Core' do |co|
    co.vendored_frameworks = "ios/StraaSCoreSDK.framework"
    co.dependency "AFNetworking", "~>3.1"
    co.dependency "Socket.IO-Client-Swift", "~> 8.0"
  end
  s.subspec 'Streaming' do |streaming|
    streaming.vendored_frameworks = "ios/StraaSStreamingSDK.framework"
    streaming.dependency "AFNetworking", "~>3.1"
    streaming.dependency "StraaS-iOS-SDK/Core"
  end

end
