//
//  STSStreamingPrepareConfig.h
//  StraaS
//
//  Created by shihwen.wang on 2017/1/25.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STSStreamingResolution.h"


NS_ASSUME_NONNULL_BEGIN

/**
 *  A STSStreamingPrepareConfig object defines the prepare configuration of the stream manager.
 */
@interface STSStreamingPrepareConfig : NSObject

/**
 *  The target size of the output video. Defaults to `CGSizeZero`.
 *  The width and height should both be the positive even number.
 *  If this property is set to `CGSizeZero`, the output video size will be calculated by the streaming manager according to property `fitAllCamera`, `maxResolution` and the aspect ratio of the preview view.
 */
@property (nonatomic) CGSize targetOutputSize;

/**
 *  A boolean value indicates if the size of the output video should fit all available cameras on the device.
 *  Defaults to `YES`. This property will be used only when `targetOutputSize` is equal to `CGSizeZero`.
 *  If this property is set to `NO`, the output video size will be limited by the max resolution of the current camera. If this property is set to `YES`, the output video size will be limited by the max resolution of all available cameras.
 */
@property (nonatomic) BOOL fitAllCamera;

/**
 *  The max resolution of the output video. Defaluts to `STSStreamingResolution720p`.
 *  Both the width and the height of the output video will be limited by this value.
 *  This property will be used only when `targetOutputSize` is equal to `CGSizeZero`.
 */
@property (nonatomic) STSStreamingResolution maxResolution;

/**
 *  The orientation of the output video. Defaults to `UIInterfaceOrientationPortrait`.
 */
@property (nonatomic) UIInterfaceOrientation outputImageOrientation;

@end

NS_ASSUME_NONNULL_END
