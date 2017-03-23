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

@optional

/**
 *  Called when the duration of the current media changed.
 *
 *  @param playerView The player view that sent the message.
 *  @param duration   The new duration (in seconds) of the current media.
 */
- (void)playerView:(STSSDKPlayerView *)playerView mediaDurationChanged:(Float64)duration;

/**
 *  Called when the current time of the current media changed.
 *
 *  @param playerView  The player view that sent the message.
 *  @param currentTime The curent time (in seconds) of the media.
 */
- (void)playerView:(STSSDKPlayerView *)playerView mediaCurrentTimeChanged:(Float64)currentTime;

/**
 *  Called when the loaded time range of the current media changed.
 *
 * @param playerView       The player view that sent the message.
 * @param loadedTimeRanges An array contains NSValue objects containing a CMTimeRange value indicating the time ranges for which the player has media data readily available. The time ranges returned may be discontinuous.
 */
- (void)playerView:(STSSDKPlayerView *)playerView loadedTimeRangesChanged:(NSArray<NSValue *> *)loadedTimeRanges;

@end

NS_ASSUME_NONNULL_END
#endif /* STSPlayerPlaybackEventDelegate_h */
