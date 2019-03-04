//
//  STSPlayerPlayback.h
//  StraaS
//
//  Created by Lee on 07/03/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#ifndef STSPlayerPlayback_h
#define STSPlayerPlayback_h

#import "STSPlayerDelegate.h"
#import "STSSDKPlaybackStatus.h"
#import "STSVideoScalingMode.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSArray <NSString *>* (^QualityNamesMappingType)(NSArray <NSString *>* rawQualityNames);

@protocol STSPlayerPlayback <NSObject>

@property (nonatomic, readonly) STSSDKPlaybackStatus playbackStatus;
@property (nonatomic, readwrite) STSVideoScalingMode videoScalingMode;
@property (nonatomic, nullable, weak) id<STSPlayerDelegate> delegate;
@property (nonatomic, readonly) CALayer * playerLayer;
@property (nonatomic) BOOL allowsPlayingInBackground;
@property (nonatomic) BOOL muted;
@property (nonatomic) float playbackSpeed;
@property (nonatomic) float playbackSpeedForContinue;

- (void)setStreamURL:(NSURL * _Nullable)URL;
- (void)play;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)replay;
- (void)forceToEnd;
- (CVPixelBufferRef _Nullable)pixelBufferForCurrentItemTime;
- (BOOL)isPlaying;
- (BOOL)hasEnded;
- (void)seekToTime:(Float64)timeInSeconds shouldPlayAfterSeeking:(BOOL)play;
- (NSTimeInterval)currentTime;
- (NSTimeInterval)currentLiveDateTime;
- (UIViewController *)qualitySelectionViewControllerWithQualityNamesMapping:(QualityNamesMappingType)mapping;
- (NSArray<NSString *> *)availableRawQualityNames;
- (NSString *)currentRawQualityName;
- (BOOL)setMediaQuality:(NSString *)qualityName;
@end

NS_ASSUME_NONNULL_END

#endif /* STSPlayerPlayback_h */
