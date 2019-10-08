//
//  STSPlayerPlaylistEventDelegate.h
//  StraaS
//
//  Created by shihwen.wang on 2016/10/17.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#ifndef STSPlayerPlaylistEventDelegate_h
#define STSPlayerPlaylistEventDelegate_h

@class STSSDKPlayerView;
@class STSPlaylist;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Implements the STSPlayerPlaybackEventDelegate protocol to respond to playlist events.
 */
@protocol STSPlayerPlaylistEventDelegate <NSObject>

/**
 *  Sent when the player view did load an playlist.
 *
 *  @param playerView The player view that sent the message.
 *  @param playlist The loaded playlist.
 */
- (void)playerView:(STSSDKPlayerView *)playerView didLoadPlaylist:(STSPlaylist *)playlist;

/**
 *  Sent when the player view is about to play a specific item.
 *
 *  @param playerView The player view that sent the message.
 *  @param index The index of the target item in the current playlist that the player view is going to play.
 *
 *  @return YES if the player view should play the target item, NO if not.
 */
- (BOOL)playerView:(STSSDKPlayerView *)playerView willPlayItemAtIndex:(NSInteger)index;

/**
 *  Sent when the player view did start playing the target item.
 *
 *  @param playerView The player view that sent the message.
 *  @param index The index of the played item in the current playlist.
 */
- (void)playerView:(STSSDKPlayerView *)playerView didPlayItemAtIndex:(NSInteger)index;

/**
 *  Sent when the last item in the playlist has ended.
 *
 *  @param playerView The player view that sent the message.
 *  @param playlist The playlist that related to this message.
 */
- (void)playerView:(STSSDKPlayerView *)playerView playListDidPlayToEnd:(STSPlaylist *)playlist;

@end

NS_ASSUME_NONNULL_END

#endif /* STSPlayerPlaylistEventDelegate_h */
