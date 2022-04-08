//
//  STSStreamingErrorCode.h
//  StraaS
//
//  Created by shihwen.wang on 2016/10/26.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#ifndef STSStreamingSDKErrorCode_h
#define STSStreamingSDKErrorCode_h

/**
 *  StraaS.io streaming SDK error code
 */
typedef NS_ENUM(NSUInteger, STSStreamingErrorCode) {
    /**
     *  Couldn't access the camera, may be the permission problem or other camera problems.
     */
    STSStreamingErrorCodeCamera = 0,
    /**
     *  Couldn't access the microphone, may be the permission problem or other microphone problems.
     */
    STSStreamingErrorCodeMicrophone = 1,
    /**
     *  Resolution is not supported by camera in current device.
     */
    STSStreamingErrorCodeResolutionNotSupport = 2,
    /**
     *  SDK internal error happened, please try again or report issue.
     */
    STSStreamingErrorCodeInternal = 3,
    /**
     *  Network error, underlying error object is included in the user info dictionary.
     */
    STSStreamingErrorCodeNetwork = 4,
    /**
     *  Operation is denied, the cause may be calling a method in wrong state.
     */
    STSStreamingErrorCodeOperationDenied = 5,
    /**
     *  Server side error happened, please try again later or contact with service provider.
     */
    STSStreamingErrorCodeServer = 6,
    /**
     *  Member JWT is invalid or expired. Please try again with a new member JWT.
     */
    STSStreamingErrorCodeUnauthorized = 7,
    /**
     *  Provided parameter is invalid.
     */
    STSStreamingErrorCodeParameterNotSupport = 8,
    /**
     *  Couldn't create new event because of limitation of user's live event count.
     */
    STSStreamingErrorCodeLiveCountLimit = 9,
    /**
     *  Live event expired, please remove this event by calling STSStreamingManager's `cleanLiveEvent:success:failure:` method.
     */
    STSStreamingErrorCodeEventExpired = 10,
    /**
     *  Couldn't find target live event. This error may be due to the event doesn't exist, is ended, or doesn't belong to current JWT.
     */
    STSStreamingErrorCodeEventNotFound = 11,
    /**
     *  Too many requests for the server, please try again later.
     */
    STSStreamingTooManyRequests = 12,
};

#endif /* STSStreamingSDKErrorCode_h */
