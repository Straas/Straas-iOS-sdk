//
//  STSChatRoomMessage.h
//  StraaS
//
//  Created by Luke Jang on 8/11/16.
//  Copyright (c) 2016年 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  The type of the message.
 */
typedef NS_ENUM(NSInteger, STSChatMesssageType) {
    /**
     *  The message text type.
     */
    STSChatMessageTypeText,
    /**
     *  The message sticker type.
     */
    STSChatMessageTypeSticker,
};

@class STSChatUser;

/**
 *  Chat room message model
 */
@interface STSChatMessage : LHDataObject

/**
 *  Message Id.
 */
@property (nonatomic, readonly) NSString * messageId;

/**
 *  Message body.
 */
@property (nonatomic, readonly) NSString * text;

/**
 *  Chat message type.
 */
@property (nonatomic, readonly) STSChatMesssageType type;

/**
 *  Message create time.
 */
@property (nonatomic, readonly) NSString * createdDate;

/**
 *  String represent where this message is sent from.
 */
@property (nonatomic, readonly) NSString * sourceType;

/**
 *  Chat user who create this message.
 */
@property (nonatomic, readonly) STSChatUser * creator;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

/**
 *  Chat room message sticker category. The property is only valid when message is sent for sticker.
 */
@interface STSChatMessage (sticker)

/**
 *  The sticker image url.
 */
@property (nonatomic, readonly) NSURL * stickerURL;

@end

NS_ASSUME_NONNULL_END
