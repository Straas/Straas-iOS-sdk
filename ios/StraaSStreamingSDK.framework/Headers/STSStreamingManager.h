//
//  STSStreamingManager.h
//  StraaS
//
//  Created by shihwen.wang on 2016/10/27.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "STSStreamingState.h"
#import "STSStreamingLiveEventConfig.h"
#import "STSStreamingPrepareConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class STSStreamingManager;

/**
 *  Implements the STSStreamingManagerDelegate protocol to respond to streaming event.
 */
@protocol STSStreamingManagerDelegate <NSObject>
/**
 *  Called when an error occurs when the streamingManager connects to a server or streams.
 *
 *  @param streamingManager The streamingManager that sent the message.
 *  @param error The error object containing the error information.
 *  @param liveId A live event id related to this error. e.g. When the error is STSStreamingErrorCodeLiveCountLimit, you will get the not ended live event id, so that you can remove it.
 */

- (void)streamingManager:(STSStreamingManager *)streamingManager onError:(NSError *)error liveId:(NSString * _Nullable)liveId;
@end


/**
 *  StraaS.io streaming manager
 */
@interface STSStreamingManager : NSObject

/**
 *  The receiver’s delegate or nil if it doesn’t have a delegate.
 */
@property (nonatomic, weak, nullable) id<STSStreamingManagerDelegate> delegate;

/**
 *  The position of the the source camera. Default value is AVCaptureDevicePositionBack.
 */
@property (nonatomic) AVCaptureDevicePosition captureDevicePosition;

/**
 *  The state of the streaming manager.
 */
@property (nonatomic, readonly) STSStreamingState state;

/**
 *  Current member JWT
 */
@property (nonatomic, readonly) NSString * JWT;

/**
 *  The id of the current streaming live event.
 */
@property (nonatomic, readonly, nullable) NSString * currentStreamingLiveId;


/// :nodoc:
+ (instancetype)new __attribute__((unavailable("new not available, call `streamingManagerWithJWT:` instead.")));
/// :nodoc:
- (instancetype)init  __attribute__((unavailable("`init` not available, call `streamingManagerWithJWT:` instead.")));

/**
 *  Creates and returns a STSStreamingManager object with given member JWT.
 *
 *  This method can only be called after you configured application successfully
 *  (by calling `STSApplication` method `configureApplication:`),
 *  otherwise you will get a nil object.
 *
 *  @param JWT The member token got from StraaS server.
 *  @return A STSStreamingManager object initialized with JWT. If the length of `JWT` is zero, returns nil.
 */
+ (instancetype)streamingManagerWithJWT:(NSString *)JWT;

/**
 *  Initializes the camera, codec and microphone, you will be able to preview the live stream after prepare success.
 *  This method should only be called when the STSStreamingManager's state is STSStreamingStateIdle or STSStreamingStatePrepared.
 *
 *  @param previewView   The view to preview the output video.
 *  @param configuration The configuration of the output video.
 *  @param success       A block object to be executed when the task finishes successfully.
                         This block has no return value and takes one argument: the size of the output video.
 *  @param failure       A block object to be executed when the task finishes unsuccessfully.
                         This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)prepareWithPreviewView:(UIView *)previewView
                 configuration:(STSStreamingPrepareConfig *)configuration
                       success:(void(^)(CGSize outputVideoSize))success
                       failure:(void(^)(NSError * error))failure;

/**
 *  Initializes the camera, codec and microphone, you will be able to preview the live stream after prepare success.
 *  This method should only be called when the STSStreamingManager's state is STSStreamingStateIdle or STSStreamingStatePrepared.
 *
 *  @param videoSize              The output video size. The width and height should both be the multiple of two.
                                  If the width/height is not an even number.
 *  @param previewView            The view to preview the output video.
 *  @param outputImageOrientation The orientation of the output video.
 *  @param success                A block object to be executed when the task finishes successfully.
 *  @param failure                A block object to be executed when the task finishes unsuccessfully.
 *                                This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)prepareWithVideoSize:(CGSize)videoSize
                 previewView:(UIView *)previewView
      outputImageOrientation:(UIInterfaceOrientation)outputImageOrientation
                     success:(void(^)())success
                     failure:(void(^)(NSError * error))failure
__attribute__((deprecated("prepareWithVideoSize:previewView:outputImageOrientation:success:success:failure: has been deprecated please use prepareWithPreviewView:configuration:success:failure: instead.")));;

/**
 *  Starts to streaming with the provided parameters. This method will create a 
 *  live event owned by current member JWT and start to stream.
 *
 *  @param configuration The configuration of the live event.
 *  @param success       A block object to be executed when the task finishes successfully. This block has no return value and takes one arguments: the current streaming live event id.
 *  @param failure       A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes two arguments: the error object describing the error that occurred, and the live event id related to this error(can be nil). e.g. When the error is STSStreamingErrorCodeLiveCountLimit, you will get the not ended live event id, so that you can remove it.
 */
- (void)startStreamingWithConfguration:(STSStreamingLiveEventConfig *)configuration
                               success:(void(^)(NSString * liveId))success
                               failure:(void(^)(NSError * error, NSString * _Nullable liveId))failure;

/**
 *  Starts to stream with given live event id.
 *
 *  @param liveId  The id of the live event.
 *  @param success A block object to be executed when the task finishes successfully.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)startStreamingWithliveId:(NSString *)liveId
                         success:(void(^)())success
                         failure:(void(^)(NSError * error))failure;

/**
 *  Stops the current live streaming.
 *
 *  This method can only be called when `state` is `STSStreamingStateConnecting` or `STSStreamingStateStreaming`.
 *
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the live event id of stopped streaming.
 *  @param failure A block object to be executed when the task finishes unsuccessfully.This block has no return value and takes two arguments: the error object describing the error that occurred, and the live event id related to this error.
 */
- (void)stopStreamingWithSuccess:(void(^)(NSString * liveId))success
                         failure:(void(^)(NSError * error, NSString * liveId))failure;

/**
 *  Create a live event owned by current member JWT.
 *
 *  @param configuration The configuration of the live event.
 *  @param success       A block object to be executed when the task finishes successfully.
 *  @param failure       A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes two arguments: the error object describing the error that occurred, and the live event id related to this error(can be nil). e.g. When the error is STSStreamingErrorCodeLiveCountLimit, you will get the not ended live event id, so that you can remove it.
 */
- (void)createLiveEventConfguration:(STSStreamingLiveEventConfig *)configuration
                            success:(void(^)(NSString * liveId))success
                            failure:(void(^)(NSError * error, NSString * _Nullable liveId))failure;

/**
 *  Sets the state of a live event to "ended".
 *
 *  @param liveId The id of the live event.
 *  @param success A block object to be executed when the task finishes successfully.
 *  @param failure  A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)cleanLiveEvent:(NSString *)liveId success:(void(^)())success failure:(void(^)(NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
