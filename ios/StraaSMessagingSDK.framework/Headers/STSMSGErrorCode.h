//
//  STSMSGErrorCode.h
//  StraaS
//
//  Created by Lee on 04/01/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#ifndef STSMSGErrorCode_h
#define STSMSGErrorCode_h

/**
 *  StraaS.io messaging SDK error code
 */
typedef NS_ENUM(NSUInteger, STSMSGErrorCode) {
    /**
     *  Network error, underlying error object is included in the user info dictionary.
     */
    STSMSGErrorCodeNetwork = 0,
    /**
     *  Channel code should not be an empty string.
     */
    STSMSGErrorCodeChannelCodeLength = 1,
    /**
     *  Auto create chat requires member authorization(a member JWT is needed).
     */
    STSMSGErrorCodeGuestCreateChatNotSupported = 2,
    /**
     *  Can not perform operation(disconnect from channel, send message, get users, etc.) because
     *  channel is not connected.
     */
    STSMSGErrorCodeChannelNotConnected = 3,
    /**
     *  Can not connect to channel because channel is already connected.
     */
    STSMSGErrorCodeChannelAlreadyConnected = 4,
    /**
     *  Current user is a member. Can not change member name via StraaS.io messaging service.
     */
    STSMSGErrorCodeMemberNicknameUpdateNotSupported = 5,
    /**
     *  Nickname length must be between 1~20 characters.
     */
    STSMSGErrorCodeNicknameLength = 6,
    /**
     *  Message length must be between 1~300 characters.
     */
    STSMSGErrorCodeMessageLength = 7,
    /**
     *  The role to be updated can only be NORMAL or MODERATER.
     */
    STSMSGErrorCodeUserRole = 8,
    /**
     *  Member JWT is invalid or expired. Please try again with a new member JWT.
     */
    STSMSGErrorCodeUnauthorized = 9,
    /**
     *  This task is not permitted by server since what you want to do is not allowed or the identity of current user has no permission to execute the task.
     */
    STSMSGErrorCodePermission = 10,
    /**
     *  Can not connect to chatroom since it is not found on our server.
     *  Please make sure you've created this chatroom before trying to connect it.
     */
    STSMSGErrorCodeChatroomNotfound = 11,
    /**
     *  Can not update role since member id is not found.
     *  Please make sure you've created this member id before trying to update role.
     */
    STSMSGErrorCodeMemberIdNotFound = 12,
    /**
     *  Archive Id cannot be found, please check if the archive id existed.
     */
    STSMSGErrorCodeArchiveIdNotFound = 13,
    /**
     *  Input value is invalid, please check the error's userInfo[NSLocalizedDescriptionKey] to get more informations.
     */
    STSMSGErrorCodeInputValueInvalid = 14,
    /**
     *  Server side error happened, please try again later or contact with service provider.
     */
    STSMSGErrorCodeServer = 15,
    /**
     *  SDK internal error happened, please try again or report issue.
     */
    STSMSGErrorCodeInternal = 16,
    /**
     *  Aggregate data length must be between 1~100 characters.
     */
    STSMSGErrorCodeAggregatedDataLength = 17,
    /**
     *  Raw data must be an object which can be converted to JSON object.
     */
    STSMSGErrorCodeRawDataFormatNotAllowed = 18,
    /**
     *  Requests over the rate limit.
     */
    STSMSGErrorCodeTooManyRequests = 19,
    /**
     * The message you sent contains banned word(s), please see <a href="https://github.com/StraaS/StraaS-web-document/wiki/Messaging-Service-Concept">document</a>
     * for more information.
     */
    STSMSGErrorCodeUnprocessableEntity = 20,
};

#endif /* STSMSGErrorCode_h */
