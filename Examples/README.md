# StraaS iOS SDK Examples

This is the sample project demonstrate how to use StraaS iOS SDK.

## How to run the sample project

1. Make sure you have installed [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started).
- Open command line tool, and run `pod install` under the `Example` directory.
- Open `VideoChat.xcworkspace`, change the bundle identifier of `VideoChat` target to your **StraaS app bundle identifier**.
- Find the key `STSSDKClientID` in `Info.plist`, replace its value with your **StraaS app client ID**.
- *Optional step for messaging SDK*<br> Resolve two warning in `VideoChat/ChatRoom/ChatViewController.m`.
- You are ready to run the `VideoChat` target.


## How to integrate your message UI with StraaS-iOS-sdk sample

We provide message UI by using [SlackViewController](https://github.com/slackhq/SlackTextViewController) to demonstrate how iOS StraaS Messaging SDK can do.

To integrate our Message UI example, we suggest to use  [git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to make our UI example as a vendor. This can not only keep you tracking our latest UI update but also make you customized your own UI version.

Before we getting started, make sure you've read the previous chapter [Use Chat Room](https://github.com/StraaS/StraaS-iOS-sdk/wiki/Messaging-Service#use-chat-room), and set your STSSDKClientID properly.

#### Install the 3rd party libraries used by our sample into your project
Since Message UI example also use CocoaPods 3rd party libraries to complete a great experience sample, you should add those libraries into your project Podfile too.

```
   target '<#YOUR_TARGET_NAME#>' do
      pod 'StraaS-iOS-SDK/Messaging'
      pod 'SDWebImage'
      pod 'SlackTextViewController'
   end

```
run `Pod install` in command line.

[SDWebImage](https://github.com/rs/SDWebImage) is used to handle cache image and asynchronous downloading.

[SlackTextViewController](https://github.com/slackhq/SlackTextViewController) is an awesome message UI library.

You can go to their github page to see what those libraries can achieve and how to modify if you want to build your own feature.


#### Integration with Submodule
First, you should fork [StraaS-iOS-sdk](https://github.com/StraaS/StraaS-iOS-sdk) to your github account.

Use command line to go to your project folder which will use our UI example, and do:

1. create a folder to manage submodule

  `mkdir <#your_submodules_files#>`

2. cd to <#your_submodules_files#> folder

  `cd <#your_submodules_files#>`

3. Add StraaS-iOS-sdk you just forked as submodule

  `git submodule add https://github.com/<#your_github_account#>/StraaS-iOS-sdk StraaS-iOS-sdk`

That's all you have to do. Open your submodule file, you should see `StraaS-iOS-sdk` there waiting to serve you.

#### Import Message UI
1. Drag the ChatRoom directory into your project.

2. Replace JWT & chatRoomName by your business logic in ChatViewController.m class.

3. Enter ChatStickerViewController

  If you use `UINavigationController` to enter example ChatRoom, the code may seem like

```
  - (void)eventToEnterChatRoom {
    ChatStickerViewController * messageViewController = [ChatStickerViewController new];
    [self.navigationController pushViewController:messageViewController animated:YES];
  }
```
then you will enter ChatStickerViewController with your JWT & chatRoomName!

#### Update to latest message UI
Since you've forked our repository, it is free to do any customized change about your own message UI. To keep updated, you just need to pull our StraaS-iOS-sdk master branch to your forked one. After solving some conflicts, you can enjoy the latest version of message UI with your own customization.

## Update ChatViewController to have sticker input feature

This chapter shows how to update your existing message UI to have sticker input view if you don't have this feature yet.

1. Pull the latest version example.
2. copy `ChatRoom` directory in `VideoChat` to your project.

  NOTE: If you've made modifications to our example, you should resolve the conflicts may be caused.
3. Use `ChatStickerViewController` as the main ViewController to build your message UI instead of using `ChatViewController`.

Then, build your project, you should have the message UI with stickerInputView. If still don't work, please pull our example to see how it work.
