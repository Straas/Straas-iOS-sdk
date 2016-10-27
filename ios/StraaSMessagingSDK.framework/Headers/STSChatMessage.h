//
//  STSChatRoomMessage.h
//  StraaS
//
//  Created by Luke Jang on 8/11/16.
//  Copyright (c) 2016年 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN

@class STSChatUser;

/**
 *  Chat room message model
 */
@interface STSChatMessage : LHDataObject

/**
 *  Message body.
 */
@property (nonatomic, readonly) NSString * text;

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

NS_ASSUME_NONNULL_END
