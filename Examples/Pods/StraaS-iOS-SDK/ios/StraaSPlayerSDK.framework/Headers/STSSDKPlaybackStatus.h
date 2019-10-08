//
//  STSSDKPlaybackStatus.h
//  StraaS
//
//  Created by Lee on 6/16/16.
//
//

#ifndef STSSDKPlaybackStatus_h
#define STSSDKPlaybackStatus_h

/**
 *  The playback status of the player view.
 */
typedef NS_ENUM(NSInteger, STSSDKPlaybackStatus) {
    /**
     *  The default status. The player has no item to play.
     */
    STSSDKPlaybackStatusNone,
    /**
     *  The player is loading a new item.
     */
    STSSDKPlaybackStatusConnecting,
    /**
     *  The player is playing an item.
     */
    STSSDKPlaybackStatusPlaying,
    /**
     *  The player is buffering.
     */
    STSSDKPlaybackStatusBuffering,
    /**
     *  The player has an item to play, but is stopped/paused.
     */
    STSSDKPlaybackStatusStopped,
    /**
     *  The player is stopped due to error.
     */
    STSSDKPlaybackStatusError,
};

#endif
