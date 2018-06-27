//
//  STSCircallStreamConfig.h
//  StraaSCircallSDK
//
//  Created by Harry Hsu on 27/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 * Configs for preparing a local stream.
 */
@interface STSCircallStreamConfig : NSObject

/**
 * The minimum video size, which is the resolution. The resolution will be changed dynamically based on bit rate reqeusted and internet connection situation. Defaults to CGSizeMake(320.0, 240.0).
 */
@property (nonatomic) CGSize minVideoSize;

/**
 * The maximum video size, which is the resolution. The resolution will be changed dynamically based on bit rate reqeusted and internet connection situation. Defaults to CGSizeMake(1280.0, 720.0).
 */
@property (nonatomic) CGSize maxVideoSize;

/**
 * The position of the the source camera. Defaults to AVCaptureDevicePositionFront.
 */
@property (nonatomic) AVCaptureDevicePosition captureDevicePosition;

@end
