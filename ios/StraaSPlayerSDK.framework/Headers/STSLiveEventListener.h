//
//  STSLiveEventListener.h
//  StraaS
//
//  Created by shihwen.wang on 2016/9/2.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STSLiveBroadcastState.h"
#import "STSLiveEventListenerState.h"

NS_ASSUME_NONNULL_BEGIN

@class STSLiveEventListener;

/**
 *  Implements the STSLiveEventListenerDelegate protocol to handle live event without player.
 */
@protocol STSLiveEventListenerDelegate <NSObject>

/**
 *  Called when an error occurs.
 *
 *  @param liveEventListener The STSLiveEventListener instance that sent the message.
 *  @param error             The error that occurred.
 */
- (void)liveEventListener:(STSLiveEventListener *)liveEventListener onError:(NSError *)error;

/**
 *  Called when the broadcast state of the live changed.
 *
 *  @param liveEventListener The STSLiveEventListener instance that sent the message.
 *  @param broadcastState    The broadcast state of the live.
 */
- (void)liveEventListener:(STSLiveEventListener *)liveEventListener
    broadcastStateChanged:(STSLiveBroadcastState)broadcastState;

@optional
/**
 *  Called when CCU of the live changed.
 *
 *  @param liveEventListener The STSLiveEventListener instance that sent the message.
 *  @param ccu               Current CCU of the live;
 */
- (void)liveEventListener:(STSLiveEventListener *)liveEventListener CCUUpdated:(NSNumber *)ccu;

/**
 *  Called when hit count of the live changed.
 *
 *  @param liveEventListener The STSLiveEventListener instance that sent the message.
 *  @param hitCount          Current hit count of the live;
 */
- (void)liveEventListener:(STSLiveEventListener *)liveEventListener hitCountUpdated:(NSNumber *)hitCount;

/**
 *  Called when the broadcast start time of the live stream changed.
 *  The time may change when the stream starts or stops.
 *
 *  @param liveEventListener  The STSLiveEventListener instance that sent the message.
 *  @param broadcastStartTimeInMS The broadcast start time in millisecond. `nil` if the live stream is stopped.
 */
- (void)liveEventListener:(STSLiveEventListener *)liveEventListener broadcastStartTimeChanged:(NSNumber * _Nullable)broadcastStartTimeInMS;

/**
 *  Called when the state of the STSLiveEventListener changed.
 *
 *  @param liveEventListener The STSLiveEventListener instance that sent the message.
 *  @param state             The state of the STSLiveEventListener.
 */
- (void)liveEventListener:(STSLiveEventListener *)liveEventListener stateChanged:(STSLiveEventListenerState)state;

@end


/**
 *  An instance of STSLiveEventListener is a means for listening live event from StraaS server.
 */
@interface STSLiveEventListener : NSObject

/**
 *  The CCU of the current live.
 */
@property (nonatomic, readonly, nullable) NSNumber * ccu;

/**
 *  The hit count of the current live.
 */
@property (nonatomic, readonly, nullable) NSNumber * hitCount;

/**
 *  The broadcast start time in millisecond. `nil` if the live stream is stopped.
 */
@property (nonatomic, readonly, nullable) NSNumber * broadcastStartTimeInMS;

/**
 *  The id of the current live.
 */
@property (nonatomic, readonly, nullable) NSString * liveId;

/**
 *  A boolean value indicates whether the STSLiveEventListener object is listening to the live event or not.
 *  This property is deprecated. Use `state` instead.
 */
@property (nonatomic, readonly) BOOL isListening DEPRECATED_ATTRIBUTE __attribute__((deprecated("Use `state` instead.")));

/**
 *  The state of the STSLiveEventListener.
 */
@property (nonatomic, readonly) STSLiveEventListenerState state;

/**
 *  The broadcast state of the live.
 */
@property (nonatomic, readonly) STSLiveBroadcastState broadcastState;

/// :nodoc:
+ (instancetype)new __attribute__((unavailable("`new` not available, call `initWithJWT:delegate:` instead.")));
/// :nodoc:
- (instancetype)init __attribute__((unavailable("`init` not available, call `initWithJWT:delegate:` instead.")));

/**
 *  Creates a STSLiveEventListener with the given parameters.
 *
 *  This method can only be called after you configured application successfully
 *  (by calling `configureApplication:` method in `STSApplication` class),
 *  otherwise you will get a nil object.
 *
 *  @param JWT The member token got from StraaS server. Set this parameter to `nil` if the member is a guest.
 *  @param delegate The delegate of the STSLiveEventListener object.
 *  @return A newly STSLiveEventListener object.
 */
- (instancetype)initWithWithJWT:(NSString * _Nullable)JWT
                       delegate:(id<STSLiveEventListenerDelegate>)delegate;

/**
 *  Starts to listen to the live event with given live id.
 *
 *  @param liveId  The id of the live you want to listent its event.
 *  @param success A block object to be executed when the task finishes successfully.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)startWithLiveId:(NSString *)liveId
                success:(void(^ _Nullable)(void))success
                failure:(void(^ _Nullable)(NSError *))failure;

/**
 *  Stop to listen to the change of the live.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
