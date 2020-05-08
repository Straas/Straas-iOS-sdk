//
//  STSStreamingUtility.h
//  StraaS
//
//  Created by shihwen.wang on 2016/11/3.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSStreamingUtility : NSObject

+ (NSBundle *)bundle;
+ (NSString *)localizedStringInSDKBundle:(NSString *)key;
+ (CGFloat)forceConvertToEvenNumber:(CGFloat)orignalFloat;
+ (CGSize)cropToAspectRatio:(CGFloat)aspectRatio originalSize:(CGSize)originalSize;

#pragma mark - Camera

+ (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)devicePosition;
+ (CGSize)maxResolutionWithCameras:(NSArray<AVCaptureDevice *> *)captureDevices
                       aspectRatio:(CGFloat)aspectRatio
                             limit:(CGSize)limit;


#pragma mark - Streaming configuration

/**
 *  Decide maximum bitrate(Kbps) according to the target video size.
 *  refs: https://redmine.livehouse.in/projects/zebra-rtc/wiki/Streaming_Service#default-setting-
 *
 *  @param videoSize The size of the video.
 *  @return The maximum bitrate of the given video size.
 */
+ (NSUInteger)maxBitrateOfVideoSize:(CGSize)videoSize;

@end

NS_ASSUME_NONNULL_END
