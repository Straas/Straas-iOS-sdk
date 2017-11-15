//
//  STSStreamingStatsReport.h
//  StraaS
//
//  Created by Harry Hsu on 13/10/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * A STSStreamingStatsReport object provides streaming related information.
 */
@interface STSStreamingStatsReport : NSObject

/**
 * The bitrate in bits per second.
 */
@property (nonatomic, readonly) NSUInteger currentBitrate;

/**
 * The video frame rate in frames per second.
 */
@property (nonatomic, readonly) CGFloat currentFPS;

@end
