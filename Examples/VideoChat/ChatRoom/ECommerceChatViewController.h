//
//  ECommerceChatViewController.h
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StraaSMessagingSDK/StraaSMessagingSDK.h>
#import "TransparentChatViewController.h"

@interface ECommerceChatViewController : UIViewController

- (void)connectToChatWithJWT:(NSString *)JWT chatroomName:(NSString *)chatroomName connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

@property (nonatomic, readonly) TransparentChatViewController *chatVC;
@property (nonatomic, readonly) UIView * toolbarView;
@property (nonatomic, readonly) UIButton * showKeyboardButton;
@property (nonatomic, readonly) UIButton * likeButton;
@property (nonatomic, readonly) UIView * backgroundView;

//Overwrite this method if you have your custom background view. This method will be trigger when viewDidLoad, and SHOULD NOT call directly.
- (void)addStreamingCanvas;

@end
