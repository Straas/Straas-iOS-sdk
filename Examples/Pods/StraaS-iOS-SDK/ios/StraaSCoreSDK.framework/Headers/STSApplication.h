//
//  STSApplication.h
//  StraaS
//
//  Created by Luke Jang on 8/16/16.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  StraaS.io application class, the base interface of your StraaS.io application.
 */
@interface STSApplication : NSObject

/**
 *  Configure your StraaS.io application.
 *  You need to complete the configuration process and get a successfull response in order to using
 *  StraaS-iOS-SDK.
 *
 *  @param completion If success is YES, error will be nil. And StraaS-iOS-SDK components is ready
 *                    to use. Otherwise, an NSError object is passed into completion handler.
 */
+ (void)configureApplication:(void (^)(BOOL success, NSError * error))completion;

@end
