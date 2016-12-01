//
//  STSChat.h
//  StraaS
//
//  Created by Luke Jang on 8/11/16.
//  Copyright (c) 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class STSChatUser;
@class STSChatMessage;
@class STSChatSticker;

/**
 *  Chat room model
 */
@interface STSChat : NSObject

/**
 *  StraaS.io chat room support user privilege control. Each input mode has different chat ability
 *  limitation depends on user's role.
 */
typedef NS_ENUM(NSUInteger, STSChatInputMode) {
    /**
     *  Mode undefined, it should not happen.
     */
    STSChatInputUndefined,
    /**
     *  Normal mode, every user can chat.
     */
    STSChatInputNormal,
    /**
     *  Member-only mode, guest can not send message in this mode.
     */
    STSChatInputMember,
    /**
     *  Master mode, only the master of channel can send message.
     */
    STSChatInputMaster
};

/**
 *  Input mode of chat.
 */
@property (nonatomic, readonly) STSChatInputMode mode;

/**
 *  Chat channel code.
 */
@property (nonatomic, readonly) NSString * channelCode;

/**
 *  Total user number of this chat.
 */
@property (nonatomic, readonly) NSInteger userCount;

/**
 *  The chat stickers.
 */
@property (nonatomic, readonly) NSArray <STSChatSticker *> * stickers;

/**
 *  Using new to create a STSChat instance is unavailable.
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 *  Using init to create a STSChat instance is unavailable.
 */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
