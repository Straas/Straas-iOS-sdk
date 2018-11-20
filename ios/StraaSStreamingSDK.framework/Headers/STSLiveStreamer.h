//
//  STSLiveStreamer.h
//  StraaS
//
//  Created by Harry on 27/06/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMSampleBuffer.h>
#import "STSStreamingConstants.h"
#import "STSStreamingErrorCode.h"
#import "STSStreamingLiveEventConfig.h"
#import "STSStreamingState.h"
#import "STSVideoConfiguration.h"
#import "STSAudioConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class STSLiveStreamer;

/**
 *  Implements the STSLiveStreamerDelegate protocol to respond to streaming event.
 */
@protocol STSLiveStreamerDelegate <NSObject>

/**
 *  Called when an error occurs when the liveStreamer connects to a server or streams.
 *
 *  @param liveStreamer The liveStreamer that sent the message.
 *  @param error The error object containing the error information.
 *  @param streamingURL The streaming URL related to this error.
 */
- (void)liveStreamer:(STSLiveStreamer *)liveStreamer onError:(NSError *)error streamingURL:(nullable NSURL *)streamingURL;
@end

/**
 *  StraaS.io live streamer
 */
@interface STSLiveStreamer : NSObject

/**
 *  The state of the live streamer.
 */
@property (nonatomic, readonly) STSStreamingState state;

/**
 *  The current streaming URL.
 */
@property (nonatomic, readonly) NSURL * streamingURL;

/**
 *  The receiver’s delegate or nil if it doesn’t have a delegate.
 */
@property (nonatomic, weak, nullable) id<STSLiveStreamerDelegate> delegate;

/**
 * Creates and returns a STSLiveStreamer object with specified video and audio configurations.
 *
 * @param videoConfig The video configuration.
 * @param audioConfig The audio configuration.
 * @return An initialized STSLiveStreamer object.
 */
- (instancetype)initWithVideoConfiguration:(nonnull STSVideoConfiguration *)videoConfig
                        audioConfiguration:(nonnull STSAudioConfiguration *)audioConfig;

/**
 * Starts streaming with a given URL.
 * 
 * @param url       The streaming URL. Using multiple STSLiveStreamer instances to start stream with the same URL is unexpected.
 * @param success   A block object to be executed when the task finishes successfully.
 * @param failure   A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)startStreamingWithURL:(NSURL *)url
                      success:(void(^)(void))success
                      failure:(void(^)(NSError * error))failure;

/**
 * Stops streaming.
 *
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the stopped streaming URL.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes two arguments: the error object describing the error that occurred, and the streaming URL related to this error.
 */
- (void)stopStreamingWithSuccess:(void (^)(NSURL * streamingURL))success
                         failure:(void(^)(NSError * error, NSURL * streamingURL))failure;

/**
 * Pushes a video frame to the stream.
 *
 * @param sampleBuffer The video frame.
 */
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 * Pushes an audio frame to the stream.
 *
 * @param sampleBuffer The audio frame.
 */
- (void)pushAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 * Pushes an audio frame which is sent from ReplayKit to the stream.
 *
 * @param sampleBuffer  The audio frame.
 * @param audioChannel  A constant NSString indicates the ReplayKit audio channel. The value could be kSTSReplayKitAudioChannelMic or kSTSReplayKitAudioChannelApp and must be registered by adding it to `replayKitAudioChannels` property of a STSAudioConfiguration object. The `sampleBuffer` will be discarded if the `audioChannel` is an unregistered channel.
 */
- (void)pushAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer ofAudioChannel:(NSString *)audioChannel;

@end

NS_ASSUME_NONNULL_END
