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
#import "STSPlayerPlayback.h"

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
 *  The image that will show in the control center.
 *  If this property is `nil`, the player view will use the thumbnail of the media (live or VOD) as the control center image.
 */
@property (nonatomic, nullable) UIImage * imageForControlCenter;

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
 *  A boolean value indicates whether the player view can display the default broadcast state message when the player is playing a live. Defaults to `YES`.
 */
@property (nonatomic) BOOL canShowBroadcastStateMessage;

/**
 *  A boolean value indicates whether the player can keep playing in background. Defaults to `NO`.
 */
@property (nonatomic) BOOL allowsPlayingInBackground;

/**
 *  A boolean value indicates whether the player should respond to the remote control events while playing a media.
 *  Defaults to `NO`.
 */
@property (nonatomic) BOOL remoteControlEnabled;

/**
 *  A boolean value indicates whether the player should show caption.
 *  Defaults to `NO`. It will be change to `YES` after the caption exists and the caption is successfully downloaded.
 */
@property (nonatomic) BOOL captionEnabled;

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
 *  A boolean value indicates whether current live stream is in low latency mode.
 */
@property (nonatomic, readonly) BOOL isInLowLatencyMode;

/**
 *  A boolean value indicates whether the playback is in live DVR mode.
 */
@property (nonatomic, readonly) BOOL isInDvrMode;

/**
 *  A boolean value indicates whether the audio session is interrupted. Some of the player view methods will not work when this property is `YES`, see the description of each method for details.
 */
@property (nonatomic, readonly) BOOL audioSessionIsInterrupted;

/**
 *  A boolean value indicates whether the audio output is muted.
 */
@property (nonatomic) BOOL muted;

/**
 *  A float value indicates the playback speed. For VOD, the range will be in (0.0, 2.0], which is smaller or equal to 2.0, and greater than 0.0. Setting any valute out of range will be ignored. For Live, the value is not settable and is always 1.0.
 */
@property (nonatomic) float playbackSpeed;

/**
 *  The member token got from StraaS server. Set this property to nil if the current user is a guest.
 *
 *  If you update this property when the player is playing, the new value will work the next time you load a media (live, VOD, or playlist).
 */
@property (nonatomic, nullable) NSString * JWT;

/**
 *  The low latency player, import it from player extension.
 */
@property (nonatomic) id<STSPlayerPlayback> lowLatencyPlayer;

/**
 *  The function for mapping the raw `availableQualityNames` to customize the available quality names. The customized available quality names will be displayed on the alert view controller for selecting the video quality.
 *  The raw `availableQualityNames` always includes `auto`, and may include `source` and other quality strings ended with `p`, for example: `360p`, `480p`, `1080p`, etc.
 *  If this is nil, then the available quality names shown on the alert controller will be the same as the property `availableQualityNames`.
 */
@property (nonatomic, copy) QualityNamesMappingType mappingForDisplayingAvailableQualityNames;

/**
 *  Loads and starts playing a specific video.
 *
 *  This method won't work if `audioSessionIsInterrupted` is `YES`.
 *
 *  If the player view is playing a playlist and the current playlist contains this video,
 *  the player view will jump to the index of that video.
 *
 *  @param videoId The ID of the video you want to load.
 */
- (void)loadVideoWithId:(NSString *)videoId;

/**
 *  Loads and starts playing the first item of a specific playlist.
 *
 *  This method won't work if `audioSessionIsInterrupted` is `YES`.
 *
 *  @param playlistId The id of the playlist you want to load.
 */
- (void)loadPlaylistWithId:(NSString *)playlistId;


/**
 *  Loads and starts playing the specified video from the given playlist.
 *
 *  This method won't work if `audioSessionIsInterrupted` is `YES`.
 *
 *  @param playlistId The id of the playlist you want to load.
 *  @param videoId The id of the video you want to play in the beginning.
 */
- (void)loadPlaylistWithId:(NSString *)playlistId playlistVideoId:(NSString *)videoId;


/**
 *  Loads and starts playing a specific live without lowLatency.
 *
 *  This method won't work if `audioSessionIsInterrupted` is `YES`.
 *
 *  @param liveId The ID of the live you want to load.
 */
- (void)loadLiveWithId:(NSString *)liveId;

/**
 *  Loads and starts playing a specific live with lowLatency or not.
 *
 *  This method won't work if `audioSessionIsInterrupted` is `YES`.
 *
 *  @param liveId           The ID of the live you want to load.
 *  @param isLowLatency  A boolean value indicates whether to play low latency live stream.
 *                          Set lowLatency to YES can significantly reduce the live latency between broadcaster and viewers but no adaptive playback.
 *                          Currently, 360 low latency playback is not supported yet.
 *                          When this flag is true and effective, `availableQualityNames`, `currentQualityName` and `setMediaQuality` will be nil.
 */
- (void)loadLiveWithId:(NSString *)liveId lowLatency:(BOOL)isLowLatency;

/**
 *  Play a playlist item at the given index.
 *
 *  This method won't work if `audioSessionIsInterrupted` is `YES`.
 *
 * @param index The index of the target item in the current playlist.
 */
- (void)playItemAtIndex:(NSInteger)index;

/**
 *  Play the next item in the current playlist.
 *
 *  This method won't work if `audioSessionIsInterrupted` is `YES`.
 */
- (void)playNextItem;

/**
 *  Play the previous item in the current playlist.
 *
 *  This method won't work if `audioSessionIsInterrupted` is `YES`.
 */
- (void)playPreviousItem;

/**
 *  Toggle player between play and pause.
 *
 *  This method won't work if `audioSessionIsInterrupted` is `NO`.
 */
- (void)togglePlayPause;

/**
 *  Sets the current playback time to the specified time.
 *
 *  This method won't work if the current playing media is a live, or if `audioSessionIsInterrupted` is `YES`.
 *
 *  @param timeInSeconds The time to which to seek.
 */
- (void)seekToTime:(float)timeInSeconds;

/**
 *  Sets the current playback time to the live edge and plays automatically.
 *
 *  This method won't work under the following conditions: (1) If the current playing media is not a live. (2) If `isInLowLatencyMode` is YES. (3) If `audioSessionIsInterrupted` is YES.
 */
- (void)playAtLiveEdge;

/**
 *  Gets the current time of current media.
 *
 *  currentTime means the media playing time. At the beginning of a media, this value would be 0.
 *  If you play/seek to 30s from the beginning, this value would be 30. (and so on...)
 *  Get this value from STSPlayerPlaybackEventDelegate `playerView:playerView mediaCurrentTimeChanged:` is recommended.
 *
 *  @return The current time (in seconds) of current media.
 */
- (NSTimeInterval)currentTime;

/**
 *  Gets the current live date time of current media.
 *
 *  If a live was started at 2017/7/1, 12:00:00(whose timestamp is 1498910400), playing its VoD will have 1498910400 currentLiveDateTime at the beginning.
 *  If you play/seek to 30s from the VoD's beginning, this value would become 1498910430 (1498910400 + 30).
 *  Only VoD created from live would have valid value, else would get 0.
 *  Get this value from STSPlayerPlaybackEventDelegate `playerView:playerView mediaCurrentTimeChanged:` is recommended.
 *
 *  @return The current live date time (in unix seconds) of current media. Return 0 if current media is not mapped to any date.
 */
- (NSTimeInterval)currentLiveDateTime;

/**
 *  Gets the CCU of the currently playing live.
 *
 *  @return the CCU of the currently playing live. Returns nil if there is no live playing.
 */
- (NSNumber * _Nullable)ccuOfCurrentlyPlayingLive;

/**
 *  Gets the hitCount of the the currently playing live.
 *
 *  @return the hitCount of the currently playing live. Returns nil if there is no live playing.
 */
- (NSNumber * _Nullable)hitCountOfCurrentlyPlayingLive;

/**
 *  Gets the broadcast start time of the currently playing live stream.
 *
 *  @return The broadcast start time in millisecond of of the currently playing live stream. Returns `nil` if the live stream is stopped or if there is no live playing.
 */
- (NSNumber * _Nullable)broadcastStartTimeOfCurrentlyPlayingLive;

/**
 *  Get the raw quality names of the current playing media (Live or VOD).
 *  Return nil when playing a live and lowLatency is true and effective.
 *
 *  @return The name of the available qualities.
 */
- (NSArray * _Nullable)availableQualityNames;

/**
 *  Get the current selected quality name of the playing media (Live or VOD).
 *  Return nil when playing a live and lowLatency is true and effective.
 *
 *  @return The name of the current selected quality.
 */
- (NSString * _Nullable)currentQualityName;

/**
 *  Switch player to the given media quality.
 *  Note: Load a new media will reset the media quality to "auto".
 *  Return NO when playing a live and lowLatency is true and effective.
 *
 *  @param qualityName The name of the media quality you want switch to.
 *  @return YES if the media quality did change to the target quality; otherwise, NO.
 */
- (BOOL)setMediaQuality:(NSString *)qualityName;

@end
NS_ASSUME_NONNULL_END
