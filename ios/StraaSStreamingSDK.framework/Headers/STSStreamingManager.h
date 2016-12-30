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

NS_ASSUME_NONNULL_BEGIN

@class STSStreamingManager;

/**
 *  Implements the STSStreamingManagerDelegate protocol to respond to streaming event.
 */
@protocol STSStreamingManagerDelegate <NSObject>
/**
 *  Called when streaming starts.
 *
 *  @param streamingManager The streamingManager that sent the message.
 *  @param liveId The id of the current streaming live event.
 */
- (void)streamingManager:(STSStreamingManager *)streamingManager didStartStreaming:(NSString *)liveId;
/**
 *  Called when streaming is finished.
 *
 *  @param streamingManager The streamingManager that sent the message.
 ** @param completed Indicates whether the live event is set to ended successfully or not. YES if the live events ends successfully, NO if not.
 */
- (void)streamingManager:(STSStreamingManager *)streamingManager didStopStreaming:(BOOL)completed;
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
 *  Initializes the camera, codec and microphone, you will be able to preview the live stream after prepare success.
 *
 *  @param videoSize The output video size.
 *  @param previewView The view to preview the output video.
 *  @param outputImageOrientation The orientation of the output video.
 *  @param success A block object to be executed when the task finishes successfully.
 *  @param failure  A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)prepareWithVideoSize:(CGSize)videoSize
                 previewView:(UIView * _Nullable)previewView
      outputImageOrientation:(UIInterfaceOrientation)outputImageOrientation
                     success:(void(^)())success
                     failure:(void(^)(NSError * error))failure;

/**
 *  Starts to streaming with the provided parameters. This method will create a 
 *  live event owned by provided member JWT and start to stream. 
 *
 *  @param JWT The member token got from StraaS server.
 *  @param title The title of the live event.
 *  @param synopsis The synopsis of the live event.
 *  @param listed Indicates whether the live event should be listed.
 *  @param reuseLiveEvent Indicates whether to reuse the last unended live event. YES if you want to reuse the last event, NO if not. This parameter works only when there is an unended event.
 */
- (void)startStreamingWithJWT:(NSString *)JWT
                        title:(NSString *)title
                     synopsis:(NSString * _Nullable)synopsis
                       listed:(BOOL)listed
               reuseLiveEvent:(BOOL)reuseLiveEvent;

/**
 *  Stops the current live streaming. This method should only be called when the state of the streaming manager status is STSStreamingStateConnecting or STSStreamingStateStreaming.
 */
- (void)stopStreaming;

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
