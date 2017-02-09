//
//  STSAggregatedData.h
//  StraaS
//
//  Created by Lee on 23/01/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  STSAggregatedData class defines the usage of an aggregated data.
 */
@interface STSAggregatedData : LHDataObject

/**
 *  The key of an aggregated data.
 */
@property (nonatomic, readonly) NSString * key;

/**
 *  The number of count indicates how many times that `key` be sent in one period.
 */
@property (nonatomic, readonly) NSNumber * count;

@end

NS_ASSUME_NONNULL_END
