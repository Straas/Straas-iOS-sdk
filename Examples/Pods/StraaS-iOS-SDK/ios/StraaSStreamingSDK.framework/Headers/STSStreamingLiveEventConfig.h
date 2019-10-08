//
//  STSStreamingLiveEventConfig.h
//  StraaS
//
//  Created by shihwen.wang on 2017/1/19.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STSStreamingResolution.h"
#import "STSStreamingProfile.h"

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

/**
 *  A boolean value indicates whether to list the new VoD of the live event or not.
 *  Defaults to `NO`.
 */
@property (nonatomic) BOOL vodListed;

/**
 *  A boolean value indicates Whether the new VoD of the live event is available by users or not.
 *  Defaults to `NO`.
 */
@property (nonatomic) BOOL vodAvailable;

/**
 *  The max resolution of the live event. Defaults to `STSStreamingResolution720p`.
 *  This property is deprecated. Use `profile` instead.
 *
 *  Note: This property only works if `profile` is equal to `STSStreamingProfileNone`.
 */
@property (nonatomic) STSStreamingResolution maxResolution __attribute__((deprecated("`maxResolution` has been deprecated. Use `profile` instead.")));

/**
 *  The profile of the live event. Defaults to `STSStreamingProfileNone`.
 *
 *  Note that `STSStreamingProfile1080pAndSource` can only be used when your account is enabled highest resolution 1080p authority.
 */
@property (nonatomic) STSStreamingProfile profile;

/**
 *  A boolean value indicates whether to merge all VoDs of the live event together. Defaults to `NO`.
 *
 *  Note:
 *  * If this property is set to `YES`, only one VoD will be generated, and no temporary VoD will be shown until the live event ends.
 *  * This configuration can't be changed after the live event is created.
 */
@property (nonatomic) BOOL vodMerge;

/**
 *  A boolean value indicates whether to enable live DVR feature for a live event. Default value: `NO`.
 *
 *  Note:
 *  * This configuration can't be changed after the live event is created.
 *  * This property can be set to `YES` only when your account is enabled live-DVR authority.
 */
@property (nonatomic) BOOL dvrEnabled;

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
