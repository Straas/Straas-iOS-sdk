//
//  STSChatMetadata.h
//  StraaS
//
//  Created by shihwen.wang on 2017/7/7.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/StraaSCoreSDK.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Model for chatroom metadata.
 */
@interface STSChatMetadata : LHDataObject

/**
 *  The key of the metadata.
 */
@property (nonatomic, readonly) NSString * key;

/**
 *  The value of the metadata.
 *
 *  The value types could be:
 *
 *  * NSArray
 *  * NSNull
 *  * NSNumber (also includes booleans)
 *  * NSDictionary
 *  * NSString
 */
@property (nonatomic, readonly) id value;

@end

NS_ASSUME_NONNULL_END
