//
//  STSCircallPlayerView.h
//  StraaSCircallSDK
//
//  Created by Harry Hsu on 28/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STSCircallStream.h"
#import "STSCircallScalingMode.h"

/**
 * An object that displays the video content from a stream object.
 */
@interface STSCircallPlayerView : UIView

/**
 * The stream to display on the view.
 */
@property (nonatomic) STSCircallStream * stream;

/**
 * The scaling mode to use when displaying the video. The default value of this property is STSCircallScalingModeAspectFit.
 */
@property (nonatomic) STSCircallScalingMode scalingMode;

/**
 * Determines if this stream view, a subview inside STSCircallPlayerView is mirrored by making CGAffineTransform. Default is false.
 */
@property (nonatomic, assign) BOOL isMirrored;

/**
 * Returns an UIImage of the the current frame.
 *
 * @return An UIImage of the current frame.
 */
- (UIImage *)getVideoFrame;

@end
