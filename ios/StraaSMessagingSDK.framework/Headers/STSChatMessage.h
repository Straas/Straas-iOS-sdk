//
//  STSChatRoomMessage.h
//  StraaS
//
//  Created by Luke Jang on 8/11/16.
//  Copyright (c) 2016年 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/LHDataObject.h>
#import "STSChatUser.h"

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

/**
 *  Chat room message model
 */
@interface STSChatMessage : LHDataObject

/**
 *  Message Id.
 */
@property (nonatomic, readonly) NSString * messageId;

/**
 *  Message text. It may be the normal text or rawData text.
 */
@property (nonatomic, readonly) NSString * text;

/**
 *  Message RawData, only valid when recieves data chanenl RawData.
 */
@property (nonatomic, readonly, nullable) id rawData;

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

/**
 *  Using new to create a STSChatMessage instance is unavailable.
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 *  Using int to create a STSChatMessage instance is unavailable.
 */
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
