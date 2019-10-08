//
//  STSAggregatedItem.h
//  StraaS
//
//  Created by Lee on 18/02/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  STSAggregatedItem class defines an aggregated item.
 */
@interface STSAggregatedItem : LHDataObject;

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
