//
//  STSLiveEventListener.h
//  StraaS
//
//  Created by shihwen.wang on 2016/9/2.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STSLiveBroadcastState.h"

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
 *  @param broadcastState    The broadcast stae of the live.
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
 *  The CCU of the current live.
 */
@property (nonatomic, readonly, nullable) NSNumber * hitCount;

/**
 *  The id of the live.
 */
@property (nonatomic, readonly) NSString * liveId;

/**
 *  A boolean value indicates whether the STSLiveEventListener object is listening to the live event or not.
 */
@property (nonatomic, readonly) BOOL isListening;

/// :nodoc:
+ (instancetype)new __attribute__((unavailable("`new` not available, call `initWithLiveId:delegate:` instead.")));
/// :nodoc:
- (instancetype)init __attribute__((unavailable("`init` not available, call `initWithLiveId:delegate:` instead.")));

/**
 *  Creates a STSLiveEventListener with the given parameters.
 *
 *  @param liveId   The id of the live.
 *  @param delegate The delegate of the STSLiveEventListener object.
 *  @return A newly STSLiveEventListener object.
 */
- (instancetype)initWithLiveId:(NSString *)liveId
                      delegate:(id<STSLiveEventListenerDelegate>)delegate;

/**
 *  Start to listen to the event of the live.
 */
- (void)start;

/**
 *  Stop to listen to the change of the live.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
