//
//  STSAggregatedData.h
//  StraaS
//
//  Created by Lee on 23/01/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN

@class STSAggregatedItem;

/**
 *  STSAggregatedData class defines an aggregated data which being sent on certain time.
 */
@interface STSAggregatedData : LHDataObject

/**
 *  The aggregated items.
 */
@property(nonatomic, readonly) NSArray<STSAggregatedItem *> * items;

/**
 *  The aggregated data created date.
 */
@property(nonatomic, readonly) NSString * createdDate;

@end


NS_ASSUME_NONNULL_END
