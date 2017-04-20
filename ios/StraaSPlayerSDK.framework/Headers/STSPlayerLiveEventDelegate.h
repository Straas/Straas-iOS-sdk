//
//  STSPlayerLiveEventDelegate.h
//  StraaS
//
//  Created by shihwen.wang on 2016/9/6.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#ifndef STSPlayerLiveEventDelegate_h
#define STSPlayerLiveEventDelegate_h

#import "STSLiveBroadcastState.h"

@class STSSDKPlayerView;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Implements the STSPlayerLiveEventDelegate protocol to respond to live event.
 */
@protocol STSPlayerLiveEventDelegate <NSObject>
/**
 *  Called when the player view starts loading a live.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The StraaS live id of the loading video.
 */
- (void)playerView:(STSSDKPlayerView *)playerView startLoadingLive:(NSString *)liveId;

/**
 *  Called when a live has loaded.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The StraaS live id of the loaded live.
 */
- (void)playerView:(STSSDKPlayerView *)playerView didLoadLive:(NSString *)liveId;

/**
 *  Called when the broadcast state of the live changed.
 *
 *  @param playerView     The player view that sent the message.
 *  @param liveId         The StraaS live id of the live whose broadcast state changed.
 *  @param broadcastState The new broadcast state of the live.
 */
- (void)playerView:(STSSDKPlayerView *)playerView live:(NSString *)liveId broadcastStateChanged:(STSLiveBroadcastState)broadcastState;

@optional

/**
 *  Called when CCU of the live changed.
 *
 * @param playerView The player view that sent the message.
 *  @param liveId    The live event id who's CCU changed.
 * @param ccu        Current CCU of the live event;
 */
- (void)playerView:(STSSDKPlayerView *)playerView liveCCUChanged:(NSString *)liveId value:(NSNumber *)ccu;

/**
 *  Called when hit count of the live changed.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The live event id who's hit count changed.
 *  @param hitCount   Current hit count of the live event;
 */
- (void)playerView:(STSSDKPlayerView *)playerView liveHitCountChanged:(NSString *)liveId value:(NSNumber *)hitCount;

/**
 *  Called when a live with lowLatencyFirst stream fail to load.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The StraaS live id of the live event that is waiting for stream.
 */
- (void)playerViewFailToLoadLowLatencyStream:(STSSDKPlayerView *)playerView liveId:(NSString *)liveId;

/**
 *  Called when the stream of a live event starts.
 *  This method has been deprecated. Use `playerView:live:broadcastStateChanged:` instead.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The StraaS live id of the started live stream.
 */
- (void)playerView:(STSSDKPlayerView *)playerView streamDidStart:(NSString *)liveId __attribute__((deprecated("`playerView:streamDidStart:` has been deprecated. Use `playerView:live:broadcastStateChanged:` instead.")));

/**
 *  Called when the stream of a live event stops.
 *  This method has been deprecated. Use `playerView:live:broadcastStateChanged:` instead.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The StraaS live id of the stopped live stream.
 */
- (void)playerView:(STSSDKPlayerView *)playerView streamDidStop:(NSString *)liveId __attribute__((deprecated("`playerView:streamDidStop:` has been deprecated. Use `playerView:live:broadcastStateChanged:` instead.")));

/**
 *  Called when a live is waiting for stream.
 *  This method has been deprecated. Use `playerView:live:broadcastStateChanged:` instead.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The StraaS live id of the live event that is waiting for stream.
 */
- (void)playerView:(STSSDKPlayerView *)playerView waitingForStream:(NSString *)liveId __attribute__((deprecated("`playerView:waitingForStream:` has been deprecated. Use `playerView:live:broadcastStateChanged:` instead.")));

@end

NS_ASSUME_NONNULL_END

#endif /* STSPlayerLiveEventDelegate_h */
