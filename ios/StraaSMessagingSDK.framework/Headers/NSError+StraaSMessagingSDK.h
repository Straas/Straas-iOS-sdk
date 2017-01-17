//
//  NSError+StraaSMessagingSDK.h
//  StraaS
//
//  Created by Luke Jang on 8/15/16.
//  Copyright (c) 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const STSMSGErrorDomain;

/**
 *  StraaS.io messaging SDK error code
 */
typedef NS_ENUM(NSUInteger, STSMSGErrorCode) {
    /**
     *  Network error, underlying error object is included in the user info dictionary.
     */
    STSMSGErrorCodeNetwork,
    /**
     *  Channel code should not be an empty string.
     */
    STSMSGErrorCodeChannelCodeLength,
    /**
     *  Auto create chat requires member authorization(a member JWT is needed).
     */
    STSMSGErrorCodeGuestCreateChatNotSupported,
    /**
     *  Can not perform operation(disconnect from channel, send message, get users, etc.) because
     *  channel is not connected.
     */
    STSMSGErrorCodeChannelNotConnected,
    /**
     *  Can not connect to channel because channel is already connected.
     */
    STSMSGErrorCodeChannelAlreadyConnected,
    /**
     *  Current user is a member. Can not change member name via StraaS.io messaging service.
     */
    STSMSGErrorCodeMemberNicknameUpdateNotSupported,
    /**
     *  Nickname length must be between 1~20 characters.
     */
    STSMSGErrorCodeNicknameLength,
    /**
     *  Message length must be between 1~120 characters.
     */
    STSMSGErrorCodeMessageLength,
    /**
     *  The role to be updated can only be NORMAL or MODERATER.
     */
    STSMSGErrorCodeUserRole,
    /**
     *  Member JWT is invalid or expired. Please try again with a new member JWT.
     */
    STSMSGErrorCodeUnauthorized,
    /**
     *  Current user does not have right to perform operation(e.g. guest send a message to 
     *  a member-only input mode chat room).
     */
    STSMSGErrorCodePermission,
    /**
     *  Can not connect to chatroom since it is not found on our server.
     *  Please make sure you've created this chatroom before trying to connect it.
     */
    STSMSGErrorCodeChatroomNotfound,
    /**
     *  Server side error happened, please try again later or contact with service provider.
     */
    STSMSGErrorCodeServer,
    /**
     *  SDK internal error happened, please try again or report issue.
     */
    STSMSGErrorCodeInternal,
    /**
     *  Data channel is not enabled. If you want to use data channel, remember to connect to chatroom with option STSChatroomConnectionWithDataChannel.
     */
    STSMSGErrorCodeDataChannelNotEnabled,
    /**
     *  Aggregate data length must be between 1~50 characters.
     */
    STSMSGErrorCodeAggregatedDataLength,
    /**
     *  Raw data must be an object which can be converted to JSON object.
     */
    STSMSGErrorCodeRawDataFormatNotAllowed,
};

@interface NSError (StraaSMessagingSDK)

+ (instancetype)STSMSGChatroomNotFoundError;
+ (instancetype)STSMSGNotConnectedError;
+ (instancetype)STSMSGAggregateDataLengthError;
+ (instancetype)STSMSGDataChannelNotEnabledError;
+ (instancetype)STSMSGRawDataCannotBeConvertedToJson;
+ (instancetype)STSMSGInternalError;
- (instancetype)STSMSGError;

@end
