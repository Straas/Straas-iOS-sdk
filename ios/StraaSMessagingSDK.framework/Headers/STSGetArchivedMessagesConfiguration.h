//
//  STSGetArchivedMessagesConfiguration.h
//  StraaS
//
//  Created by Lee on 15/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A STSGetArchivedMessagesConfiguration object defines the request rules of how to get archived messages from StraaS server.
 */
@interface STSGetArchivedMessagesConfiguration : NSObject

/// :nodoc:
- (instancetype)init __attribute__((unavailable("new not available, call `configurationWtihArchiveId:` instead.")));;
/// :nodoc:
+ (instancetype)new __attribute__((unavailable("new not available, call `configurationWtihArchiveId:` instead.")));;

/**
 An instance method to create a STSGetArchivedMessagesConfiguration object with archive Id.

 @param archiveId The archive id to retrieve the archived messages.
 @return An STSGetArchivedMessagesConfiguration object with archive id.
 */
+ (instancetype)configurationWithArchiveId:(NSString *)archiveId;

/**
 *  The archive id to retrieve the archived messages.
 */
@property (nonatomic) NSString * archiveId;

/**
 *  The start time of archieved messages which is unix time in millisecond.
 *  Null imply no constraint.
 */
@property (nonatomic, nullable) NSNumber * start;

/**
 *  The end time of archieved messages which is unix time in millisecond.
 *  Null imply no constraint.
 */
@property (nonatomic, nullable) NSNumber * end;

@end

NS_ASSUME_NONNULL_END
