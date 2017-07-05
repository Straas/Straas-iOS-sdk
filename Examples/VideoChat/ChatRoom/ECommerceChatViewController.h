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

@interface ECommerceChatViewController : UIViewController<DataChannelEventDelegate>

- (void)connectToChatWithJWT:(NSString *)JWT chatroomName:(NSString *)chatroomName connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

@property (nonatomic, readonly) TransparentChatViewController *chatVC;
@property (nonatomic, readonly) UIView * toolbarView;
@property (nonatomic, readonly) UIButton * showKeyboardButton;
@property (nonatomic, readonly) UIButton * likeButton;
@property (nonatomic, readonly) UILabel * likeCountLabel;
@property (nonatomic) UIView * backgroundView;

- (void)onShowKeyboardButtonClick:(UIButton *)button NS_REQUIRES_SUPER;
- (void)onLikeButtonClick:(UIButton *)button NS_REQUIRES_SUPER;

@end
