//
//  STSSDKPlayerView.h
//  StraaS
//
//  Created by Lee on 6/16/16.
//
//

#import <UIKit/UIKit.h>
#import "STSPlayerLiveEventDelegate.h"
#import "STSPlayerPlaybackEventDelegate.h"
#import "STSPlayerPlaylistEventDelegate.h"
#import "STSVideoScalingMode.h"

NS_ASSUME_NONNULL_BEGIN
@class STSSDKPlayerView;
@class STSVideo;
@class STSPlaylist;
@class STSPlaylistItem;
@class STSSDKPlayerControlView;
@class STSLive;

/**
 *  The delegate of a STSSDKPlayerView object must adopt the STSSDKPlayerViewDelegate protocol.
 */
@protocol STSSDKPlayerViewDelegate <NSObject>

/**
 *  Specifies the optional UIViewController that will be used to present an
 *  in-app browser. This method is needed by Google IMA.
 *  When nil, tapping the video ad "Learn More" button or companion ads
 *  will result in opening Safari browser. If provided, in-app browser will
 *  be used, allowing the user to stay in the app and return easily.
 */
- (UIViewController * _Nullable)webOpenerPresentingViewController;

/**
 *  Called when the player view needs to present a view controller.
 *  (e.g., to present a quality selection view controller.)
 *
 *  @param viewControllerToPresent viewController needs to be presented.
 */
- (void)presentViewController:(UIViewController *)viewControllerToPresent;

@end

/**
 *  An instance of STSSDKPlayerView is a means for loading media to play and control playback.
 */
@interface STSSDKPlayerView : UIView

/**
 *  The receiver’s delegate.
 */
@property (nonatomic, nullable, weak) id<STSSDKPlayerViewDelegate, STSPlayerPlaybackEventDelegate> delegate;

/**
 *  The object that acts as the playlist event delegate of the player view. Set nil if it has no playlist event delegate.
 */
@property (nonatomic, nullable, weak) id<STSPlayerPlaylistEventDelegate> playlistEventDelegate;

/**
 *  The object that acts as the live event delegate of the player view. Set nil if it has no live event delegate.
 */
@property (nonatomic, nullable, weak) id<STSPlayerLiveEventDelegate> liveEventDelegate;

/**
 *  The view that contains playback controls and infos.
 */
@property (nonatomic, readonly) STSSDKPlayerControlView * playerControlView;

/**
 *  A boolean value indicates whether the player view is able to display the player control when necessary.
 */
@property (nonatomic) BOOL canShowPlayerControlView;

/**
 *  A boolean value indicates whether the player view is able to display the default error view when error occurs.
 */
@property (nonatomic) BOOL canShowErrorView;

/**
 *  A boolean value indicates whether the player view is able to display the default loading indicator on loading.
 */
@property (nonatomic) BOOL canShowLoadingIndicator;

/**
 *  The scaling mode to use when displaying the video. The default value of this property is STSVideoScalingModeAspectFit. This property only works when current video is not 360-degree.
 */
@property (nonatomic) STSVideoScalingMode videoScalingMode;

/**
 *  The index of the current playlist item.
 *  If the player view are not playing a playlist (e.g., playing a video or alive), returns NSNotFound.
 */
@property (nonatomic, readonly) NSInteger currentItemIndex;

/**
 *  The items in the current playlist.
 */
@property (nonatomic, readonly, nullable) NSArray <STSPlaylistItem *> * playlistItems;

/**
 *  The current playlist.
 */
@property (nonatomic, readonly, nullable) STSPlaylist * playlist;

/**
 *  The current playing video.
 */
@property (nonatomic, readonly, nullable) STSVideo * video;

/**
 *  The currently playing live.
 */
@property (nonatomic, readonly, nullable) STSLive * live;

/**
 *  Loads and starts playing a specific video.
 *  If the player view is playing a playlist and the current playlist contains this video,
 *  the player view will jump to the index of that video.
 *
 *  @param videoId The ID of the video you want to load.
 */
- (void)loadVideoWithId:(NSString *)videoId;

/**
 *  Loads and starts playing the first item of a specific playlist.
 *
 *  @param playlistId The id of the playlist you want to load.
 */
- (void)loadPlaylistWithId:(NSString *)playlistId;

/**
 *  Loads and starts playing a specific live.
 *
 *  @param liveId The ID of the live you want to load.
 */
- (void)loadLiveWithId:(NSString *)liveId;

/**
 *  Play a playlist item at the given index.
 *
 * @param index The index of the target item in the current playlist.
 */
- (void)playItemAtIndex:(NSInteger)index;

/**
 *  Play the next item in the current playlist.
 */
- (void)playNextItem;

/**
 *  Play the previous item in the current playlist.
 */
- (void)playPreviousItem;

/**
 *  Toggle player between play and pause.
 */
- (void)togglePlayPause;

/**
 *  Sets the current playback time to the specified time.
 *  This method won't work if the current playing media is a live.
 *
 *  @param timeInSeconds The time to which to seek.
 */
- (void)seekToTime:(float)timeInSeconds;

/**
 *  Gets the CCU of the currently playing live.
 *
 *  @return the CCU of the currently plyaing live. Returns nil if there is no live playing.
 */
- (NSNumber * _Nullable)ccuOfCurrentlyPlayingLive;

/**
 *  Gets the hitCount of the the currently playing live.
 *
 *  @return the hitCount of the currently playing live. Returns nil if there is no live playing.
 */
- (NSNumber * _Nullable)hitCountOfCurrentlyPlayingLive;

@end
NS_ASSUME_NONNULL_END
