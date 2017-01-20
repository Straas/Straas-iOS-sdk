//
//  STSStreamingLiveEventConfig.h
//  StraaS
//
//  Created by shihwen.wang on 2017/1/19.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A STSStreamingLiveEventConfig object defines the configuration of a live event.
 */
@interface STSStreamingLiveEventConfig : NSObject

/**
 *  The title of the live event.
 */
@property (nonatomic, readonly) NSString * title;

/**
 *  The synopsis of the live event.
 */
@property (nonatomic, nullable) NSString * synopsis;

/**
 *  The id of the category which the live event belongs to.
 *
 *  If you want to set category id of the live event, you should create categories first.
 *  You can create categories in [StraaS CMS](https://cms.straas.io) .
 *  Once you create categories, you can get category lists by `STSCMSManager` in `StraaSPlayerSDK`
 *  or by calling StraaS [Get Categories API](https://straas.github.io/StraaS-web-document/#cateogry-get-categories)
 *  from your server and get category ids from the response data.
 */
@property (nonatomic, nullable) NSNumber * categoryId;

/**
 *  The array of tags which the live event is tagged with.
 */
@property (nonatomic, nullable) NSArray<NSString *> * tags;

/**
 *  A boolean value indicates whether the live event should be listed.
 */
@property (nonatomic, readonly) BOOL listed;

/// :nodoc:
+ (instancetype)new __attribute__((unavailable("new not available, call `liveEventConfigWithTitle:synopsis:listed:` instead.")));
/// :nodoc:
- (instancetype)init  __attribute__((unavailable("`init` not available, call `liveEventConfigWithTitle:synopsis:listed:` instead.")));

/**
 *  Creates a STSStreamingLiveEventConfig with given parameters.
 *
 *  @param title The title of the live event.
 *  @param listed Indicates whether the live event should be listed.
 *  @return A newly STSStreamingLiveEventConfig object.
 */
+ (instancetype)liveEventConfigWithTitle:(NSString * )title listed:(BOOL)listed;

@end

NS_ASSUME_NONNULL_END
