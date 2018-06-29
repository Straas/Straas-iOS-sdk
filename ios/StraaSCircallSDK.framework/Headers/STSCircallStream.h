//
//  STSCircallStream.h
//  StraaSCircallSDK
//
//  Created by Harry Hsu on 18/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The CirCall stream.
 */
@interface STSCircallStream : NSObject

/**
 * The stream ID.
 */
@property (nonatomic, readonly) NSString * streamId;

/**
 *  A boolean value indicating whether the audio output is enabled.
 */
@property (nonatomic) BOOL audioEnabled;

/**
 *  A boolean value indicating whether the video output is enabled.
 */
@property (nonatomic) BOOL videoEnabled;

/**
 *  The position of the the source camera. Defaults to AVCaptureDevicePositionFront.
 */
@property (nonatomic) AVCaptureDevicePosition captureDevicePosition;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Returns a boolean value indicating whether the stream is a local stream.
 *  Local Stream is the stream published by self. If it's not a local stream, then it's remote stream, which is published by other participants.
 */
- (BOOL)isLocal;

@end

NS_ASSUME_NONNULL_END
