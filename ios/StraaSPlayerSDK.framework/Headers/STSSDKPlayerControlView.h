//
//  STSSDKPlayerControlView.h
//  StraaS
//
//  Created by Lee on 6/15/16.
//
//

#import <UIKit/UIKit.h>
#import "STSSDKStreamingTimelineView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of STSSDKPlayerControlView is a means for displaying playback controls
 *   (e.g. play button, pause button) and info (e.g. title label, text track(subtitle) label).
 */
@interface STSSDKPlayerControlView : UIView

/**
 *  The container view is the default superview of the content displayed by the player control view.
 */
@property (nonatomic, readonly) UIImageView * containerView;

/**
 *  The label that shows the title of the current playing video.
 */
@property (nonatomic, readonly) UILabel * titleLabel;

/**
 *  The label that shows the views count of the current playing video.
 */
@property (nonatomic, readonly) UILabel * viewsCountLabel;

/**
 *  The play button.
 */
@property (nonatomic, readonly) UIButton * playButton;

/**
 *  The pause button.
 */
@property (nonatomic, readonly) UIButton * pauseButton;

/**
 *  The replay button.
 */
@property (nonatomic, readonly) UIButton * replayButton;

/**
 *  The quality selection button.
 *  User can press this button to show a quality selection menu.
 */
@property (nonatomic, readonly) UIButton * qualityButton;

/**
 *  The previous button, only shows when player is playing a playlist.
 */
@property (nonatomic, readonly) UIButton * prevButton;

/**
 *  The next button, only shows when player is playing a playlist.
 */
@property (nonatomic, readonly) UIButton * nextButton;

/**
 *  The mute switch button.
 */
@property (nonatomic, readonly) UIButton * muteSwitchButton;

/**
 *  The text track switch button.
 */
@property (nonatomic, readonly) UIButton * textTrackSwitchButton;

/**
 *  The playback speed button.
 */
@property (nonatomic, readonly) UIButton * playbackSpeedButton;

/**
 *  The view that shows the playback time and duration.
 */
@property (nonatomic, readonly) STSSDKStreamingTimelineView * playbackTimelineView;

/**
 *  The view that indicates the currently playing item is a live.
 */
@property (nonatomic, readonly) UIView *liveMark;

/**
 *  The view that indicates the currently playing item is a 360 video/live.
 */
@property (nonatomic, readonly) UIImageView * sphericalMark;

/**
 *  The layout constraints of the subviews embedded in the containerView.
 *  Change this property to customize the layout of the playback controls and infos.
 */
@property (nonatomic) NSArray<NSLayoutConstraint *> * subviewLayoutConstraints;

/**
 *  The time interval (in seconds) to auto dismiss `containerView` after showing it. Defaults to three.
 *  Set this property to zero if you don't want `containerView` to be auto dismissed.
 *  `contrainerView` will be auto dismissed after given time interval only when the player is playing.
 *  Note: If you update this property when `containerView` is visible, the new value will work the next time that `containerView` becomes visible.
 */
@property (nonatomic) NSUInteger containerViewDismissTimeInterval;

/**
 *  A boolean value indicates whether the player control view is able to display the titleLabel.
 */
@property (nonatomic) BOOL canShowTitleLabel;

/**
 *  A boolean value indicates whether the player control view is able to display the `viewsCountLabel`. Defaults to YES.
 *  This property works only when the player is playing a video/playlist. The `viewsCountLabel` is always hidden when player is playing a live.
 */
@property (nonatomic) BOOL canShowViewsCountLabel;

/**
 *  A boolean value indicates whether the player control view is able to display the playback controls.
 */
@property (nonatomic) BOOL canShowPlaybackControlButtons;

/**
 *  A boolean value indicates whether the player control view is able to display the qualityButton.
 */
@property (nonatomic) BOOL canShowQualityButton;

/**
 *  A boolean value indicates whether the player control view is able to display the playbackTimelineView.
 *  This property works only when the player is playing a video/playlist. The playbackTimelineView
 *  is always hidden when player is playing a live.
 */
@property (nonatomic) BOOL canShowPlaybackTimelineView;

/**
 *  A boolean value indicates whether the player control view is able to display the liveMark.
 *  This property works only when the player is playing a live. The liveMark is always hidden when
 *  player is playing a video or a playlist.
 */
@property (nonatomic) BOOL canShowLiveMark;


/**
 *  A boolean value indicates whether the player control view is able to display the sphericalMark.
 *  This property works only when the player is playing a 360 video/live.
 */
@property (nonatomic) BOOL canShowSphericalMark;

/**
 *  A boolean value indicates whether the player control view is able to display the muteSwitchButton.
 */
@property (nonatomic) BOOL canShowMuteSwitchButton;

/**
 *  A boolean value indicates whether the player control view is able to display the textTrackSwitchButton.
 */
@property (nonatomic) BOOL canShowTextTrackSwitchButton;

/**
 *  A boolean value indicates whether the player control view is able to display the playbackSpeedButton.
 *  This property works only when the player is playing video/playlist. The playbackSpeedButton is always hidden when
 *  player is playing live.
 */
@property (nonatomic) BOOL canShowPlaybackSpeedButton;

@end

NS_ASSUME_NONNULL_END
