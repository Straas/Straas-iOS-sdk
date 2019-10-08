//
//  STSSDKPlayerTimelineView.h
//  StraaS
//
//  Created by Lee on 6/22/16.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A STSSDKStreamingTimelineView object includes subviews that shows the playback time information.
 */
@interface STSSDKStreamingTimelineView : UIControl

/**
 *  The slider that shows the playback progress.
 */
@property (nonatomic, readonly) UISlider * playbackTimeSlider;

/**
 *  The label shows the playback duration.
 */
@property (nonatomic, readonly) UILabel * durationLabel;

/**
 *  The label shows the playback elapsed time.
 */
@property (nonatomic, readonly) UILabel * playbackTimeLabel;

/**
 *  The layout constraints of the subviews embedded in the currentView.
 *  Change this property to customize the layout of the subviews.
 */
@property (nonatomic) NSArray<NSLayoutConstraint *> * subviewLayoutConstraints;

@end

NS_ASSUME_NONNULL_END
