//
//  STSLowLatencyPlayer.h
//  STSLowLatencyPlayer
//
//  Created by Jason.Chuang on 2018/8/10.
//  Copyright © 2018年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StraaSPlayerSDK/STSPlayerPlayback.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  The low latency player used in STSSDKPlayerView
 *  [lowLatencyPlayer](https://straas.github.io/StraaS-iOS-sdk/StraaSPlayerSDK/Classes/STSSDKPlayerView.html#/c:objc(cs)STSSDKPlayerView(py)lowLatencyPlayer)
 *  property
 */
@interface STSLowLatencyPlayer : NSObject<STSPlayerPlayback>

@end

NS_ASSUME_NONNULL_END
