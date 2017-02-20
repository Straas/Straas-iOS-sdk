//
//  STSPlayerLiveEventDelegate.h
//  StraaS
//
//  Created by shihwen.wang on 2016/9/6.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#ifndef STSPlayerLiveEventDelegate_h
#define STSPlayerLiveEventDelegate_h

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
 *  Called when the stream of a live event starts.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The StraaS live id of the started live stream.
 */
- (void)playerView:(STSSDKPlayerView *)playerView streamDidStart:(NSString *)liveId;

/**
 *  Called when the stream of a live event stops.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The StraaS live id of the stopped live stream.
 */
- (void)playerView:(STSSDKPlayerView *)playerView streamDidStop:(NSString *)liveId;

/**
 *  Called when a live is waiting for stream.
 *
 *  @param playerView The player view that sent the message.
 *  @param liveId     The StraaS live id of the live event that is waiting for stream.
 */
- (void)playerView:(STSSDKPlayerView *)playerView waitingForStream:(NSString *)liveId;

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

@end

NS_ASSUME_NONNULL_END

#endif /* STSPlayerLiveEventDelegate_h */
