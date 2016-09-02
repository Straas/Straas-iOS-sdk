# StraaS iOS SDK Examples

This is the sample project demonstrate how to use StraaS iOS SDK.

## How to run the sample project

1. Make sure you have installed [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started).
- Open command line tool, and run `pod install` under the `Example` directory.
- Open `VideoChat.xcworkspace`, change the bundle identifier of `VideoChat` target to your **StraaS app bundle identifier**.
- Find the key `STSSDKClientID` in `Info.plist`, replace its value with your **StraaS app client ID**.
- *Optional step for messaging SDK*<br> Resolve two warning in `VideoChat/ChatRoom/ChatViewController.m`.
- You are ready to run the `VideoChat` target.