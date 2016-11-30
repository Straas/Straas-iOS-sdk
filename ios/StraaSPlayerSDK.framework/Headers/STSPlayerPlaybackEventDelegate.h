//
//  STSPlayerPlaybackEventDelegate.h
//  StraaS
//
//  Created by shihwen.wang on 2016/10/17.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#ifndef STSPlayerPlaybackEventDelegate_h
#define STSPlayerPlaybackEventDelegate_h

@class STSSDKPlayerView;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Implements the STSPlayerPlaybackEventDelegate protocol to respond to playback events.
 */
@protocol STSPlayerPlaybackEventDelegate <NSObject>
/**
 *  Sent when playback starts.
 *
 *  @param playerView The player view that sent the message.
 */
- (void)playerViewStartPlaying:(STSSDKPlayerView *)playerView;

/**
 *  Sent when buffering starts or stops.
 *
 *  @param playerView The player view that sent the message.
 *  @param buffering YES when the player is buffering, No if not.
 */
- (void)playerView:(STSSDKPlayerView *)playerView onBuffering:(BOOL)buffering;

/**
 *  Sent when the playback did end.
 *
 *  @param playerView The player view that sent the message.
 */
- (void)playerViewDidPlayToEnd:(STSSDKPlayerView *)playerView;

/**
 *  Sent when playback is paused.
 *
 *  @param playerView The player view that sent the message.
 */
- (void)playerViewPaused:(STSSDKPlayerView *)playerView;

/**
 *  Sent when playback is paused.
 *
 *  @param playerView The player view that sent the message.
 */
- (void)playerView:(STSSDKPlayerView *)playerView error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
#endif /* STSPlayerPlaybackEventDelegate_h */
