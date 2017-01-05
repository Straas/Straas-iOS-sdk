//
//  MessageViewController.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import <SlackTextViewController/SLKTextViewController.h>
#import <StraaSMessagingSDK/STSChatroomConnectionOptions.h>
#import "ChatStickerDelegate.h"
#import "StickerInputViewDelegate.h"


@interface ChatViewController : SLKTextViewController<StickerInputViewDelegate>

@property (nonatomic, readonly) NSString * JWT;
@property (nonatomic, readonly) NSString * chatroomName;
@property (nonatomic, readonly) STSChatroomConnectionOptions connectionOptions;
@property (weak, nonatomic) id<ChatStickerDelegate> delegate;

+ (instancetype)chatViewControllerWithJWT:(NSString *)JWT
                             chatroomName:(NSString *)chatroomName
                        connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

- (instancetype)initWithJWT:(NSString *)JWT
               chatroomName:(NSString *)chatroomName
          connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

+ (instancetype)new __attribute__((unavailable("Use chatViewControllerWithJWT:chatroomName:connectionOptions: instead.")));
- (instancetype)init  __attribute__((unavailable("Use initWithJWT:chatroomName:connectionOptions: instead.")));

@end
