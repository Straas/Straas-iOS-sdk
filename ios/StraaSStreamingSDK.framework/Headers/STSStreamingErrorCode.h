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
    STSStreamingErrorCodeCamera,
    /**
     *  Couldn't access the microphone, may be the permission problem or other microphone problems.
     */
    STSStreamingErrorCodeMicrophone,
    /**
     *  Resolution is not supported by camera in current device.
     */
    STSStreamingErrorCodeResolutionNotSupport,
    /**
     *  SDK internal error happened, please try again or report issue.
     */
    STSStreamingErrorCodeInternal,
    /**
     *  Network error, underlying error object is included in the user info dictionary.
     */
    STSStreamingErrorCodeNetwork,
    /**
     *  Operation is denied, the cause may be calling a method in wrong state.
     */
    STSStreamingErrorCodeOperationDenied,
    /**
     *  Server side error happened, please try again later or contact with service provider.
     */
    STSStreamingErrorCodeServer,
    /**
     *  Member JWT is invalid or expired. Please try again with a new member JWT.
     */
    STSStreamingErrorCodeUnauthorized,
    /**
     *  Provided parameter is invalid.
     */
    STSStreamingErrorCodeParameterNotSupport,
    /**
     *  Couldn't create new event because of limitation of user's live event count.
     */
    STSStreamingErrorCodeLiveCountLimit,
};

#endif /* STSStreamingSDKErrorCode_h */
