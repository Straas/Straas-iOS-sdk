//
//  STSPlayerDelegate.h
//  StraaS
//
//  Created by Lee on 08/03/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#ifndef STSPlayerDelegate_h
#define STSPlayerDelegate_h

@protocol STSPlayerPlayback;

NS_ASSUME_NONNULL_BEGIN

@protocol STSPlayerDelegate <NSObject>

- (void)playerIsReadyToPlay:(id<STSPlayerPlayback>)player;
- (void)playerStartToPlay:(id<STSPlayerPlayback>)player;
- (void)player:(id<STSPlayerPlayback>)player onBuffering:(BOOL)isBuffering;
- (void)playerDidStop:(id<STSPlayerPlayback>)player;
- (void)playerOnError:(id<STSPlayerPlayback>)player;
- (void)player:(id<STSPlayerPlayback>)player durationChanged:(Float64)timeInSeconds;
- (void)player:(id<STSPlayerPlayback>)player playbackTimeChanged:(Float64)timeInSeconds;
- (void)player:(id<STSPlayerPlayback>)player loadedTimeRangesChanged:(NSArray<NSValue *> *)loadedTimeRanges;
- (void)player:(id<STSPlayerPlayback>)player seekableTimeRangesChanged:(NSArray<NSValue *> *)seekableTimeRanges;

@end

NS_ASSUME_NONNULL_END

#endif /* STSPlayerDelegate_h */
