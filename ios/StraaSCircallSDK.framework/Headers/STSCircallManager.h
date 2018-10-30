//
//  STSCircallManager.h
//  StraaSCircallSDK
//
//  Created by Harry Hsu on 15/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STSCircallState.h"
#import "STSCircallStreamConfig.h"
#import "STSCircallStream.h"
#import "STSCircallPlayerView.h"
#import "STSCircallPublishConfig.h"
#import "STSCircallRecordingStreamMetadata.h"
#import "STSCircallPublishWithUrlConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class STSCircallManager;

/**
 * The methods that you use to receive events from an associated CirCall manager object.
 */
@protocol STSCircallManagerDelegate<NSObject>

@optional

/**
 * Tells the delegate that the CirCall manager added a stream.
 *
 * @param manager The CirCall manager that added the stream.
 * @param stream The newly added stream.
 */
- (void)circallManager:(STSCircallManager *)manager didAddStream:(STSCircallStream *)stream;

/**
 * Tells the delegate that the CirCall manager removed a stream.
 *
 * @param manager The CirCall manager that removed the stream.
 * @param stream The removed stream.
 */
- (void)circallManager:(STSCircallManager *)manager didRemoveStream:(STSCircallStream *)stream;

/**
 * Tells the delegate that an error occurred.
 *
 * @param manager The CirCall manager that reports the error.
 * @param error The error object containing the error information.
 */
- (void)circallManager:(STSCircallManager *)manager onError:(NSError *)error;

@end

/**
 * StraaS.io CirCall manager
 */
@interface STSCircallManager : NSObject

/**
 * The state of the streaming manager.
 */
@property(nonatomic, readonly) STSCircallState state;

/**
 * A new array containing the remote streams, or an empty array if no remote streams have been added.
 */
@property(nonatomic, readonly) NSArray<STSCircallStream *> * remoteStreams;

/**
 * A boolean value indicating whether the local stream is published.
 */
@property(nonatomic, readonly) BOOL isLocalStreamPublished;

/**
 * The current CirCall token.
 */
@property(nonatomic, readonly, nullable) NSString * circallToken;

/**
 * The delegate object to receive events.
 */
@property(nonatomic, weak, nullable) id<STSCircallManagerDelegate> delegate;

/**
 * Prepares the local stream for the device camera. This method only works when the CirCall manager's `state` is `STSCircallStateIdle` or `STSCircallStatePrepared`.
 *
 * @param streamConfig The configuration of the local stream.
 * @param success A block object to be executed when the preparation is finished successfully. This block has no return value and takes one argument: the prepared local stream.
 * @param failure A block object to be executed when the preparation is finished unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)prepareForCameraCaptureWithStreamConfig:(nullable STSCircallStreamConfig *)streamConfig
                                        success:(void (^ _Nullable)(STSCircallStream * stream))success
                                        failure:(void (^ _Nullable)(NSError * error))failure;

/**
 * Prepares the local stream with the rtsp url. This method only works when the CirCall manager's `state` is `STSCircallStateIdle` or `STSCircallStatePrepared`.
 *
 * @param success A block object to be executed when the preparation is finished successfully. This block has no return value and takes no argument.
 * @param failure A block object to be executed when the preparation is finished unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)prepareForUrlWithSuccess:(void(^ _Nullable)(void))success
                         failure:(void(^ _Nullable)(NSError * error))failure;

/**
 * Connects to a room with a CirCall token. This method only works when the CirCall manager's `state` is `STSCircallStateIdle` or `STSCircallStatePrepared`.
 *
 * @param token The CirCall token which is generated from StraaS server.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes no parameters.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)connectWithCircallToken:(NSString *)token
                        success:(void(^ _Nullable)(void))success
                        failure:(void(^ _Nullable)(NSError * error))failure;

/**
 * Disconnects from the current room. This method only works when the CirCall manager's `state` is `STSCircallStateConnected`.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes no parameters.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)disconnectWithSuccess:(void(^ _Nullable)(void))success
                      failure:(void(^ _Nullable)(NSError * error))failure;

/**
 * Publishes the local stream to the room, so other people can subscribe this stream in a room they joined.
 * This method only works if the `state` is `STSCircallStateConnected`.
 *
 * @param config The configs for publishing the local stream.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the published local stream.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)publishWithCameraCaptureWithConfig:(STSCircallPublishConfig *)config success:(void(^ _Nullable)(STSCircallStream *stream))success failure:(void(^ _Nullable)(NSError * error))failure;

/**
 * Publishes the stream from the url(RTSP) to the room, so other people can subscribe this stream in a room they joined.
 * This method only works if the `state` is `STSCircallStateConnected` and the url in config is not nil.
 *
 * @param config The configs for publishing the stream from url(RTSP).
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the stream object that has been created.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)publishWithUrlConfig:(STSCircallPublishWithUrlConfig *)config success:(void(^ _Nullable)(STSCircallStream * stream))success failure:(void(^ _Nullable)(NSError * error))failure;

/**
 * Unpublishes the local stream.
 * This method only works if the `state` is `STSCircallStateConnected` and `isLocalStreamPublished` is YES.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes no parameters.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)unpublishWithSuccess:(void(^ _Nullable)(void))success failure:(void(^ _Nullable)(NSError * error))failure;

/**
 * Subscribes a remote stream. A person can subscribe a remote stream in a room he/she joined.
 * This method only works if the `state` is `STSCircallStateConnected`.
 *
 * @param stream The remote stream to subscribe.
 * @param success A block object to be executed when the task finishes successfully.
 * @param failure A block object to be executed when the task finishes unsuccessfully.
 */
- (void)subscribeStream:(STSCircallStream *)stream success:(void(^ _Nullable)(STSCircallStream *stream))success failure:(void(^ _Nullable)(STSCircallStream *stream, NSError * error))failure;

/**
 * Unsubscribes a remote stream.
 * This method only works if the `state` is `STSCircallStateConnected`.
 *
 * @param success A block object to be executed when the task finishes successfully.
 * @param failure A block object to be executed when the task finishes unsuccessfully.
 */
- (void)unsubscribeStream:(STSCircallStream *)stream success:(void(^ _Nullable)(void))success failure:(void(^ _Nullable)(NSError * error))failure;

/**
 * Start recording of the target stream. Streams are recorded on the server side.
 * This method only works if the `state` is `STSCircallStateConnected`.
 *
 * @param stream The target stream.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes a parameter `recordingId`.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)startRecordingStream:(STSCircallStream *)stream
                     success:(void(^ _Nullable)(NSString *recordingId))success
                     failure:(void(^ _Nullable)(NSError * error))failure;

/**
 * Stop recording of the target stream.
 * This method only works if the `state` is `STSCircallStateConnected`.
 *
 * @param stream The target stream.
 * @param recordingId The recording ID got from API `startRecordingStream:success:failure:` or `getRecordingStatusWithStream:success:failure:`.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes no parameters.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)stopRecordingStream:(STSCircallStream *)stream
                recordingId:(NSString *)recordingId
                    success:(void(^ _Nullable)(void))success
                    failure:(void(^ _Nullable)(NSError * error))failure;

/**
 * Get recording staus of the target stream.
 * This method only works if the `state` is `STSCircallStateConnected`.
 *
 * @param success A block object to be executed when the task finishes successfully. This block has return value of an array of `STSCircallRecordingStreamMetadata`.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getRecordingStreamMetadataArrayWithSuccess:(void(^ _Nullable)(NSArray <STSCircallRecordingStreamMetadata *> * recordingStreamMetaDataArray))success
                                           failure:(void(^ _Nullable)(NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
