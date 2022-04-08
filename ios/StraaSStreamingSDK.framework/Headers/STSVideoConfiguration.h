//
//  STSRKVideoConfiguration.h
//  StraaS
//
//  Created by Harry on 17/07/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A STSVideoConfiguration object defines the video configuration of a STSLiveStreamer object.
 */
@interface STSVideoConfiguration : NSObject

/**
 * The output video resolution. Defaults to CGSizeZero. The width and height should both be even and the maximum resolution is 1080p.
 */
@property (nonatomic) CGSize videoSize;

/**
 * The output frame rate. Defaults to 30. The value must be between 1 and 60.
 */
@property (nonatomic) NSUInteger frameRate;

@end

NS_ASSUME_NONNULL_END
