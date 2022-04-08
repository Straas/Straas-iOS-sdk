//
//  STSPlayerErrorCode.h
//  StraaS
//
//  Created by Lee on 6/16/16.
//
//

#ifndef STSPlayerErrorCode_h
#define STSPlayerErrorCode_h

/**
 *  StraaS.io player SDK error code.
 */
typedef NS_ENUM(NSInteger, STSPlayerErrorCode) {
    /**
     *  Network error, underlying error object is included in the user info dictionary.
     */
    STSPlayerErrorCodeNetwork = 0,
    /**
     *  Server side error happened, please try again later or contact with service provider.
     */
    STSPlayerErrorCodeServer = 1,
    /**
     *  SDK internal error happened, please try again or report issue.
     */
    STSPlayerErrorCodeSDKInternal = 2,
    /**
     *  Playback has been stopped due to error. Usually caused by player failing to play playerItem. PlayerItem may fail due to invalid url, bad network.
     */
    STSPlayerErrorCodePlayer = 3,
    /**
     *  The requested resource is not found.
     */
    STSPlayerErrorCodeNotFound = 4,
    /**
     *  The format of the received data is unacceptable.
     */
    STSPlayerErrorCodeDataDeserialization = 5,
    /**
     *  Member JWT is invalid or expired. Please try again with a new member JWT.
     */
    STSPlayerErrorCodeJWTTokenUnauthorized = 6,
    /**
     *  Have no permission to use the SDK. Make sure you've configured your app successfully.
     *  Check if you've set the STSSDKClientID corresponding to your Bundle id in your project setting and have called STSApplication's configureApplication method to configure your identity.
     *  REMIND: you needs to register your bundle id to StraaS.io to get an client_id(STSSDKClientID).
     */
    STSPlayerErrorCodeSDKUnauthorized = 7,
    /**
     *  Current member has no permission to get the requested resource. This resource may need to be paid to get.
     */
    STSPlayerErrorCodeMediaPermissionDenial = 8,
    /**
     *  The requested resource exist, but is unlisted and can not be played.
     */
    STSPlayerErrorCodeMediaUnavailable = 9,
    /**
     *  Unprocessable entity. May occurred due to unacceptable input value.
     */
    STSPlayerErrorCodeUnprocessableEntity = 10,
    /**
     *  Operation denied. May occur due to calling the method in a wrong state.
     */
    STSPlayerErrorCodeOperationDenied = 11,
    /**
     *  Invalid live id. The live id should not be nil or empty string.
     */
    STSPlayerErrorCodeInvalidLiveId = 12,
    /**
     *  Failed to connect to the socket server(for listening live event) or disconnected from the socket server due to unexpected error after a connection was established successfully.
     */
    STSPlayerErrorCodeSocketConnection = 13,
    /**
     *  Too many requests for the server, please try again later.
     */
    STSPlayerErrorCodeTooManyRequest = 14,
    /**
     *  The operation was cancelled before it was completed.
     */
    STSPlayerErrorCodeCancelled = 15,
};

#endif /* STSPlayerErrorCode_h */
