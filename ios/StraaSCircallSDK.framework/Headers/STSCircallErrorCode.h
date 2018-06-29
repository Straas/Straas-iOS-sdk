//
//  STSCircallErrorCode.h
//  StraaS
//
//  Created by Harry Hsu on 26/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#ifndef STSCircallErrorCode_h
#define STSCircallErrorCode_h

/**
 *  StraaS.io CirCall SDK error code
 */
typedef NS_ENUM(NSUInteger, STSCircallErrorCode) {
    /**
     *  Couldn't access the camera, may be the permission problem or other camera problems.
     */
    STSCircallErrorCodeCameraInitFailed = 0,
    
    /**
     *  Couldn't access the microphone, may be the permission problem or other microphone problems.
     */
    STSCircallErrorCodeMicrophoneInitFailed = 1,
    
    /**
     *  Resolution is not supported by camera in current device.
     */
    STSCircallErrorCodeResolutionNotSupport = 2,
    
    /**
     *  SDK internal error happened, please try again or report issue.
     */
    STSCircallErrorCodeInternal = 3,
    
    /**
     *  Network error, underlying error object is included in the user info dictionary.
     */
    STSCircallErrorCodeNetwork = 4,
    
    /**
     *  Operation is denied, the cause may be calling a method in wrong state.
     */
    STSCircallErrorCodeOperationDenied = 5,
    
    /**
     *  Provided parameter is invalid.
     */
    STSCircallErrorCodeParameterNotSupport = 6,
    
    /**
     *  Permission denied. The authenticated user is not permitted to perform the requested operation.
     */
    STSCircallErrorCodePermissionDenied = 7,
    
    /**
     *  A server-side error happened. Please try again later or report issues.
     */
    STSCircallErrorCodeServer = 8,
    
    /**
     *  The token is unauthorized. Plrease refresh your token.
     */
    STSCircallErrorUnauthorized = 9,
};

#endif /* STSCircallErrorCode_h */
