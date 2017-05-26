//
//  STSArchivedMessagesMeta.h
//  StraaS
//
//  Created by Lee on 15/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/StraaSCoreSDK.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  STSArchivedMessagesMeta object defines the archived messsage meta properties.
 */
@interface STSArchivedMessagesMeta : LHDataObject

/**
 *  The message type of the archived message.
 */
@property (nonatomic) NSString * msgType;

/**
 *  The oldest date of this archived messages, whose unit is unix time in millisecond.
 */
@property (nonatomic) NSNumber * oldestDate;

/**
 *  The latest date of this archived messages, whose unit is unix time in millisecond.
 */
@property (nonatomic) NSNumber * latestDate;

@end

NS_ASSUME_NONNULL_END
