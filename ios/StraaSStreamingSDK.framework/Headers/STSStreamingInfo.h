//
//  STSStreamingInfo.h
//  StraaS
//
//  Created by shihwen.wang on 2016/10/24.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Streaming info of a live event.
 */
@interface STSStreamingInfo : LHDataObject

/**
 * The live id.
 */
@property (nonatomic, readonly) NSString *liveId;

/**
 * The stream server URL.
 */
@property (nonatomic, readonly) NSString *streamServerURL;

/**
 * The stream key.
 */
@property (nonatomic, readonly) NSString *streamKey;

@property (nonatomic, nullable) NSString *ownerId;

@end

NS_ASSUME_NONNULL_END
