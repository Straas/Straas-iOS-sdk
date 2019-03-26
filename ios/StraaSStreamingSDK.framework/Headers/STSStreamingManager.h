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
#import <DSGPUImage/GPUImageFramework.h>
#import "STSStreamingState.h"
#import "STSStreamingLiveEventConfig.h"
#import "STSStreamingPrepareConfig.h"
#import "STSStreamingStatsReport.h"
#import "STSStreamingInfo.h"

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

@optional
/**
 * Tells the delegate that the streaming statistics report is updated.
 *
 * @param streamingManager The streamingManager that sent the message.
 * @param statsReport The updated streaming statistics report.
 */
- (void)streamingManager:(STSStreamingManager *)streamingManager didUpdateStreamingStatsReport:(STSStreamingStatsReport *)statsReport;

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

/**
 *  The stream key of the current streaming live event.
 */
@property (nonatomic, readonly, nullable) NSString * currentStreamingKey;

/**
 *  The filter group for the output video.
 */
@property (nonatomic, nullable) GPUImageFilterGroup *filterGroup;

/**
 *  A boolean value indicates whether the video stream of the front camera will be flipped horizontally from the preview. Defaults to `YES`.
 */
@property (nonatomic) BOOL flipFrontCameraOutputHorizontally;

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
 *  @return A STSStreamingManager object initialized with JWT.
 */
+ (instancetype)streamingManagerWithJWT:(NSString * _Nullable)JWT;

/**
 *  Initializes the camera, codec and microphone, you will be able to preview the live stream after prepare success.
 *  This method should only be called when the STSStreamingManager's state is STSStreamingStateIdle or STSStreamingStatePrepared.
 *  The success and failure completion handler will always be dispatched to the main queue.
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
 *  The success and failure completion handler will always be dispatched to the main queue.
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
                     success:(void(^)(void))success
                     failure:(void(^)(NSError * error))failure
__attribute__((deprecated("prepareWithVideoSize:previewView:outputImageOrientation:success:success:failure: has been deprecated please use prepareWithPreviewView:configuration:success:failure: instead.")));;

/**
 *  Starts to streaming with the provided parameters.
 *
 *  This method will create a live event owned by current member JWT and start to stream.
 *  Note that you should only call this method when the length of `JWT` is larger than zero (which means the member is not a guest). Otherwise, you will get an error.
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
 *  Note that you should only call this method when the length of `JWT` is larger than zero (which means the member is not a guest). Otherwise, you will get an error.
 *
 *  @param liveId  The id of the live event.
 *  @param success A block object to be executed when the task finishes successfully.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)startStreamingWithliveId:(NSString *)liveId
                         success:(void(^)(void))success
                         failure:(void(^)(NSError * error))failure;

/**
 *  Starts to stream with given stream key.
 *
 *  @param streamKey The stream key got from StraaS server.
 *  @param success A block object to be executed when the task finishes successfully.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)startStreamingWithStreamKey:(NSString *)streamKey
                            success:(void(^)(void))success
                            failure:(void(^)(NSError * error))failure;
/**
 *  Stops the current live streaming.
 *
 *  This method can only be called when `state` is `STSStreamingStateConnecting` or `STSStreamingStateStreaming`.
 *
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the live event id of stopped streaming (can be nil if you start current stream by a stream key).
 *  @param failure A block object to be executed when the task finishes unsuccessfully.This block has no return value and takes two arguments: the error object describing the error that occurred, and the live event id related to this error (can be nil if you start current stream by a stream key).
 */
- (void)stopStreamingWithSuccess:(void(^)(NSString * _Nullable liveId))success
                         failure:(void(^)(NSError * error, NSString * _Nullable liveId))failure;

/**
 *  Create a live event owned by current member JWT.
 *
 *  Note that you should only call this method when the length of `JWT` is larger than zero (which means the member is not a guest). Otherwise, you will get an error.
 *
 *  @param configuration The configuration of the live event.
 *  @param success       A block object to be executed when the task finishes successfully.
 *  @param failure       A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes two arguments: the error object describing the error that occurred, and the live event id related to this error(can be nil). e.g. When the error is STSStreamingErrorCodeLiveCountLimit, you will get the not ended live event id, so that you can remove it.
 */
- (void)createLiveEventConfguration:(STSStreamingLiveEventConfig *)configuration
                            success:(void(^)(NSString * liveId))success
                            failure:(void(^)(NSError * error, NSString * _Nullable liveId))failure;

/**
 *  Sets the status of a live event to "ended".
 *  This method has been deprecated. Use `endLiveEvent:success:failure:` instead.
 *
 *  @param liveId The id of the live event.
 *  @param success A block object to be executed when the task finishes successfully.
 *  @param failure  A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)cleanLiveEvent:(NSString *)liveId success:(void(^)(void))success failure:(void(^)(NSError * error))failure __attribute__((deprecated("`cleanLiveEvent:success:failure:` has been deprecated. Use `endLiveEvent:success:failure:` instead.")));

/**
 *  Sets the status of a live event to "ended".
 *
 *  Note that you are not able to end a live event which is not owned by current member JWT through SDK.
 *
 *  @param liveId The id of the live event.
 *  @param success A block object to be executed when the task finishes successfully.
 *  @param failure  A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)endLiveEvent:(NSString *)liveId success:(void(^)(void))success failure:(void(^)(NSError * error))failure;

/**
 *  Get the streaming statistics.
 *
 *  @return The streaming statistics, or nil if `state` is not `STSStreamingStateStreaming`.
 */
- (STSStreamingStatsReport * _Nullable)getStreamingStatsReport;

/**
 * Gets the streaming information of a live event.
 *
 * Note that you are not able to get the streaming information of the live event which does not belong to current member JWT through SDK.
 *
 * @param liveId The id of the live event.
 * @param success A block object to be executed when the task finishes successfully.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getStreamingInfoWithLiveId:(NSString *)liveId
                           success:(void(^)(STSStreamingInfo * streamingInfo))success
                           failure:(void(^)(NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
