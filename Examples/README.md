# StraaS iOS SDK Examples

This is the sample project demonstrate how to use StraaS iOS SDK.

## How to run the sample project

1. Make sure you have installed [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started).
- Open command line tool, and run `pod install` under the `Example` directory.
- Open `VideoChat.xcworkspace`, change the bundle identifier of `VideoChat` target to your **StraaS app bundle identifier**.
- Find the key `STSSDKClientID` in `Info.plist`, replace its value with your **StraaS app client ID**.
- *Optional step for messaging SDK*<br> Resolve two warning in `VideoChat/ChatRoom/ChatViewController.m`.
- You are ready to run the `VideoChat` target.


## How to integrate your messaging UI with StraaS-iOS-sdk sample

We provide message UI by using [SlackViewController](https://github.com/slackhq/SlackTextViewController) to demonstrate how iOS StraaS Messaging SDK can do.

To integrate our Messaging UI example, we suggest to use  [git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to make our UI example as a vendor. This can not only keep you tracking our latest UI update but also make you customized your own UI version.

#### prerequisite
Make sure you've read the previous chapter [Use Chat Room](https://github.com/StraaS/StraaS-iOS-sdk/wiki/Messaging-Service#use-chat-room), and set your STSSDKClientID properly.


#### Integration with Submodule
First, you should fork [StraaS-iOS-sdk](https://github.com/Jerome1210/StraaS-iOS-sdk) to your github account.

Use command line to go to your project folder which will use our UI example, and do:

1. create vendor folder

  `mkdir vendor`

2. cd to vendor folder

  `cd vendor`

3. Add StraaS-iOS-sdk as submodule

  `git submodule add https://github.com/<#your_github_account>/StraaS-iOS-sdk StraaS-iOS-sdk`

That's all you have to do. Open the vendor file, you should see `StraaS-iOS-sdk` there waiting to serve you.

#### CocoaPods
Since Messaging UI example also use 3rd party libraries to complete an great experience sample, you should add those libraries into your Podfile too.

```
   target '<YOUR_TARGET_NAME>' do
      pod 'StraaS-iOS-SDK/Messaging'
      pod 'SDWebImage'
      pod 'SlackTextViewController'
   end

```
run `Pod install` in command line.

[SDWebImage](https://github.com/rs/SDWebImage) is used to handle cache image.

[SlackTextViewController](https://github.com/slackhq/SlackTextViewController) is an awesome message UI library.

You can go to their github page to see what those libraries can achieve and how to modify if you want to build your own feature.

#### Import Message UI
1. Drag the ChatRoom files into your project.

2. Replace JWT & chatRoomName by your business logic in ChatViewController.m class.

3. Enter ChatStickerViewController

  If you use `UINavigationController` to enter example ChatRoom, the code may seems like

```
  - (void)eventToEnterChatRoom {
    ChatStickerViewController * messageViewController = [ChatStickerViewController new];
    [self.navigationController pushViewController:messageViewController animated:YES];
  }
```
then you will enter ChatStickerViewController with your JWT & chatRoomName!

#### Update to latest Messaging UI
Since you've forked our repository, it is free to do any customized change about your own Messaging UI. To keep updated, you just need to pull our StraaS-iOS-sdk master branch to your forked one. After solving some conflicts, you can enjoy the latest version of messaging UI with your own Customization.

#### Update ChatViewController to have sticker input
This chapter shows how to update your existing messaging UI to have sticker input view if you don't have this feature yet.

1. Pull the latest version example.
2. copy `ChatRoom` file in `VideoChat` to your project.

  NOTE: If you've made modifications to our example, you should resolve the conflicts may be caused.
3. Use `ChatStickerViewController` as the main ViewController to build your messaging UI instead of using `ChatViewController`.

Then, build your project, you should have the messaging UI with stickerInputView. If still don't work, please pull our Example to see how it works.
