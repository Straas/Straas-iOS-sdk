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

extern CGFloat const kEcommerceChatVCfloatingDistrictWidth;

@interface ECommerceChatViewController : UIViewController<STSChatEventDelegate>

- (void)connectToChatWithJWT:(NSString *)JWT chatroomName:(NSString *)chatroomName;

@property (nonatomic, readonly) TransparentChatViewController *chatVC;
@property (nonatomic, readonly) UIView * toolbarView;
@property (nonatomic, readonly) UIButton * showKeyboardButton;
@property (nonatomic, readonly) UIButton * likeButton;
@property (nonatomic, readonly) UILabel * likeCountLabel;
@property (nonatomic, readonly) UIView * floatingDistrictView;
@property (nonatomic) UIView * backgroundView;

- (void)chatroomConnected:(STSChat *)chatroom NS_REQUIRES_SUPER;
- (void)chatroomInputModeChanged:(STSChat *)chatroom NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom usersUpdated:(NSArray<STSChatUser *> *)users NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom messageAdded:(STSChatMessage *)message NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom messageRemoved:(NSString *)messageId NS_REQUIRES_SUPER;
- (void)chatroomMessageFlushed:(STSChat *)chatroom NS_REQUIRES_SUPER;
- (void)chatroomDisconnected:(STSChat *)chatroom NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom failToConnect:(NSError *)error NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom aggregatedItemsAdded:(NSArray<STSAggregatedItem *> *)aggregatedItems NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom pinnedMessageUpdated:(STSChatMessage *)pinnedMessage NS_REQUIRES_SUPER;

@end
