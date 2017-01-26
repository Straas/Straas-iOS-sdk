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

/**
 ChatViewConController is a basic StraaS.io chatroom UI without sticker input.  It is meant to be subclassed.
 If you want to enable sticker input feature, use ChatStickerViewController instead.
 */
@interface ChatViewController : SLKTextViewController<StickerInputViewDelegate, STSChatEventDelegate>

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
 The delegate would sent message to object which must conform ChatStickerDelegate protocol.
 */
@property (weak, nonatomic) id<ChatStickerDelegate> delegate;

/**
 The event delegate would sent message to object which must conform STSChatEventDelegate protocol.
 Default event delegate is ChatViewController itself.
 */
@property (weak, nonatomic) id<STSChatEventDelegate> eventDelegate;

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
 Return a ChatViewController object.
 
 @param JWT The StraaS member token.
 @param chatroomName The chatroom name you want to connect to.
 @param connectionOptions The connection options to connect to the chat you want.
 @return An instance of ChatViewController.
 */
+ (instancetype)chatViewControllerWithJWT:(NSString *)JWT
                             chatroomName:(NSString *)chatroomName
                        connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

/**
 Return a ChatStickerViewController object initialized from JWT, chatroomName and connectionOptions.
 
 @param JWT The StraaS member token.
 @param chatroomName The chatroom name you want to connect to.
 @param connectionOptions The connection options to connect to the chat you want.
 @return An instance of ChatStickerViewController.
 */
- (instancetype)initWithJWT:(NSString *)JWT
               chatroomName:(NSString *)chatroomName
          connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

/**
 Configure application to StraaS.io service.

 @param completionBlock A block object to be executed when configuration finishes. 
 If sucess is true, means configuration successfully, else the error object would describe the error that occurred.
 */
- (void)configureApplication:(void(^)(BOOL success, NSError * error))completionBlock;
/// :nodoc:
+ (instancetype)new __attribute__((unavailable("Use chatViewControllerWithJWT:chatroomName:connectionOptions: instead.")));
/// :nodoc:
- (instancetype)init  __attribute__((unavailable("Use initWithJWT:chatroomName:connectionOptions: instead.")));

/**
 Connect to chat will use current JWT, chatroomName, and connectionOptions to connect.
 */
- (void)connectToChat;

/**
 Disconnect current chat if needed.
 */
- (void)disconnectCurrentChatIfNeeded;

/**
 This method would replace the current connection into the chat with corresponding JWT, chatroomName and connectionOptions.
 */
- (void)connectToChatWithJWT:(NSString *)JWT
                chatroomName:(NSString *)chatroomName
           connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

/**
 Update text view input bar for certain event. You may override it.

 @param chatroom The STSChat object.
 */
- (void)updateTextViewForChatroom:(STSChat *)chatroom NS_REQUIRES_SUPER;

/**
 Tap tableview would call this method. You may override it.
 */
- (void)didTapTableView NS_REQUIRES_SUPER;

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
#pragma mark - StickerInputViewDelegate
- (void)didSelectStickerKey:(NSString *)key imageURL:(NSString *)imageURL NS_REQUIRES_SUPER;

@end
