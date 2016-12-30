//
//  STSGetMessagesConfiguration.h
//  StraaS
//
//  Created by shihwen.wang on 2016/12/12.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A STSGetMessagesConfiguration object defines the request rules of how to get messages from StraaS server.
 */
@interface STSGetMessagesConfiguration : NSObject

/**
 *  The target page. Default value is 1. This value should be bigger than or equal to 1.
 *  The newest message will be at page 1.
 */
@property (nonatomic) NSNumber * page;

/**
 *  How many messages you want each page to return. Default value is 10. This value should be in the range [1..100].
 */
@property (nonatomic) NSNumber * perPage;

/**
 *  Oldest date of request messages. Unix time in millisecond.
 */
@property (nonatomic, nullable) NSNumber * oldestDate;

/**
 *  Latest date of request messages. Unix time in millisecond.
 */
@property (nonatomic, nullable) NSNumber * latestDate;

@end

NS_ASSUME_NONNULL_END
