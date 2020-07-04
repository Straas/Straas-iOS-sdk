//
//  STSCoreErrorCode.m
//  StraaS
//
//  Created by Lee on 24/10/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  StraaS.io core SDK error code
 */
typedef NS_ENUM(NSUInteger, STSCoreErrorCode) {
    /**
     *  Network error, underlying error object is included in the user info dictionary.
     */
    STSCoreErrorCodeNetwork,
    /**
     *  Check if you've set the STSSDKClientID corresponding to your Bundle id in your project info.plist
     *  and have called STSApplication configureApplication successfully before use this class.
     */
    STSCoreErrorCodeWrongInformation,
    /**
     *  Succeed to reach our server, but fail to get authorized. Check if you've set the authorized
     *  STSSDKClientID and bundleId pair.
     */
    STSCoreErrorCodeUnauthorized,
    /**
     *  Server side error happened, please try again later or contact with service provider.
     */
    STSCoreErrorCodeServer,
};

