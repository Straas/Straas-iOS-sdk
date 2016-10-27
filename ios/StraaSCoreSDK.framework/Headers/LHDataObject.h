//
//  LHDataObject.h
//  LiveHouse
//
//  Created by chao hsin-cheng on 2014/6/5.
//  Copyright (c) 2014年 LIVEhouse.in. All rights reserved.
//

#import <Foundation/Foundation.h>

/// LIVEhouse.in data model base class
@interface LHDataObject : NSObject

/**
 *  Create an array with LHDataObject or subclass object inside
 *
 *  @param jsonArray JSON data to mapping
 *
 *  @return a desired NSArray object
 */
+ (nonnull NSArray*)objectsWithArrayOfJSON:(nonnull NSArray*)jsonArray;

/**
 *  designated initializer to mapping raw JSON data to an object
 *
 *  subclass of LHDataObject can override this method to provide it own implementation
 *
 *  @param json a dictionary of raw JSON data
 *
 *  @return an LHDataObject instance if mapping success, nil when mapping failure
 */
- (nullable instancetype)initWithJSON:(nonnull NSDictionary*)json;

@end
