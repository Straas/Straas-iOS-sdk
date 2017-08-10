//
//  MessageViewController.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import <SlackTextViewController/SLKTextViewController.h>
#import <StraaSMessagingSDK/StraaSMessagingSDK.h>
#import "ChatStickerDelegate.h"
#import "StickerInputViewDelegate.h"
#import "STSPinnedMessageView.h"

/**
 *  Constants specify where a pinned message should be shown in a ChatViewController.
 */
typedef NS_ENUM(NSUInteger, STSPinnedMessagePosition) {
    /**
     *  The pinned message should be on the top of a ChatViewController's view.
     */
    STSPinnedMessagePositionTop = 0,
    /**
     *  The pinned message should be on the bottom of a ChatViewController's view.
     */
    STSPinnedMessagePositionBottom = 1,
    /**
     *  The pinned message should align with the latest message.
     *  If the latest message is on the top of a ChatViewController's view, the pinned message will also show on the top, or vise versa.
     */
    STSPinnedMessagePositionAlignWithTheLatestMessage = 2
};


extern NSString * const STSChatViewControllerSendMessageFailureNotification;

/**
 ChatViewConController is a basic StraaS.io chatroom UI without sticker input.  It is meant to be subclassed.
 If you want to enable sticker input feature, use ChatStickerViewController instead.
 */
@interface ChatViewController : SLKTextViewController<StickerInputViewDelegate, STSChatEventDelegate, TTTAttributedLabelDelegate>

/**
 Current member token.
 */
@property (nonatomic, readonly) NSString * JWT;

/**
 Current chatroom name.
 */
@property (nonatomic, readonly) NSString * chatroomName;

/**
 Current connection options.
 */
@property (nonatomic, readonly) STSChatroomConnectionOptions connectionOptions;

/**
 StraaS Chat manager.
 */
@property (nonatomic, readonly) STSChatManager * manager;

/**
 Current Chat object in ChatViewController.
 */
@property (nonatomic, readonly) STSChat * currentChat;

/**
 Current messages
 */
@property (nonatomic, readonly) NSMutableArray *messages;

/**
 *  A custom view to show the pinned message.
 */
@property (nonatomic, readonly) STSPinnedMessageView * pinnedMessageView;

/**
 The delegate would sent message to object which must conform ChatStickerDelegate protocol.
 */
@property (weak, nonatomic) id<ChatStickerDelegate> delegate;

/**
 The event delegate would sent message to object which must conform STSChatEventDelegate protocol.
 Default event delegate is ChatViewController itself.
 */
@property (weak, nonatomic) id<STSChatEventDelegate> eventDelegate;

/**
 This block would be called after ChatViewController finish configuration application.
 The configureApplication process would start in viewDidLoad:.
 */
@property (nonatomic, copy) void(^configurationFinishHandler)(BOOL success, NSError * error);

/**
 This property indicates whether ChatViewController connect to chatroom automatically when configureApplication finished. Default is YES.
 */
@property (nonatomic) BOOL autoConnect;

/**
 A boolean value indicates whether to add default activityIndicatorView at chatViewController's view.
 Default is YES, if you want to add your custom loading view set it false.
 */
@property (nonatomic) BOOL shouldAddIndicatorView;

/**
 *  A boolean value indicates whether the chatViewController should get and show the pinned message of the current chatroom.
 *  Default to `YES`.
 */
@property (nonatomic) BOOL shouldShowPinnedMessage;

/**
 *  The position to show the pinned message. Defaults to `STSPinnedMessagePositionTop`.
 */
@property (nonatomic) STSPinnedMessagePosition pinnedMessagePosition;

/**
 A boolean value indicating whether the textView is editable.
 */
@property (nonatomic, getter=isTextViewEditable) BOOL textViewEditable;

/**
 An NSTimeInterval value indicates how long to reload tableView.
 Add message and remove message socket event will be cached in memory.
 Those changes will be updated when next refresh time interval comes.
 Default value is 1.0.
 */
@property (nonatomic) NSTimeInterval refreshTableViewTimeInteval;

/**
 An unsigned integer to limit the max number of cached messages.
 Default is 500. 0 means unlimited.
 */
@property (nonatomic) NSUInteger maxMessagesCount;

/**
 The avatar image. Default is img-guest-photo.png.
 */
@property (nonatomic) UIImage * avatarPlaceholderImage;

/**
 The sticker placeholder image. Default is btn-ic-keyboard.png.
 */
@property (nonatomic) UIImage * stickerPlaceholderImage;

/**
 The sticker input button image which is placed on the bottom left corner of this view controller. Default is btn-stickers.png.
 */
@property (nonatomic) UIImage * stickerInputButtonImage;

/**
 The text input button image which is placed on the bottom left corner of this view controller. Default is btn-stickers.png.
 */
@property (nonatomic) UIImage * textInputButtonImage;

/**
 Connect to chatroom. This method checks authentication of a legal developer and connects to target chatroom.
 You may set configurationFinishHandler block to be executed after the authentication finish.
 Note: ChatViewController is designed to connect one chatroom only.
 This method would disconnect current connection and make a new connection to the chatroom.

 @param JWT The StraaS member JWT.
 @param chatroomName The chatroom name you want to connect to.
 @param connectionOptions The connection options to connect to the chat you want.
 */
- (void)connectToChatWithJWT:(NSString *)JWT
                chatroomName:(NSString *)chatroomName
           connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

/**
 Disconnect current chatroom.
 */
- (void)disconnect;

/**
 Update text view input bar for certain event. You may override it.

 @param chatroom The STSChat object.
 */
- (void)updateTextViewForChatroom:(STSChat *)chatroom NS_REQUIRES_SUPER;

/**
 Tap tableview would call this method. You may override it.
 */
- (void)didTapTableView NS_REQUIRES_SUPER;

/**
 The condition should show jumpToLatestButton. This method will be asked when `showJumpToLatestButtonIfNeeded` or `showJumpToLatestButtonIfNeeded` be called. You may override it to customize.
 
 @return A boolean indicates whether to show jumpToLatestButton.
 */
- (BOOL)shouldShowJumpToLatestButton;

#pragma mark - STSChatEventDelegate
/**
 The following methods are as same as STSChatEventDelegate.
 You may override any of this to do some customizations when the method is called.
 */
- (void)chatroomConnected:(STSChat *)chatroom NS_REQUIRES_SUPER;
- (void)chatroomInputModeChanged:(STSChat *)chatroom NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom usersUpdated:(NSArray<STSChatUser *> *)users NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom messageAdded:(STSChatMessage *)message NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom messageRemoved:(NSString *)messageId NS_REQUIRES_SUPER;
- (void)chatroomMessageFlushed:(STSChat *)chatroom NS_REQUIRES_SUPER;
- (void)chatroom:(STSChat *)chatroom pinnedMessageUpdated:(STSChatMessage *)pinnedMessage NS_REQUIRES_SUPER;
#pragma mark - StickerInputViewDelegate
- (void)didSelectStickerKey:(NSString *)key imageURL:(NSString *)imageURL NS_REQUIRES_SUPER;

@end
