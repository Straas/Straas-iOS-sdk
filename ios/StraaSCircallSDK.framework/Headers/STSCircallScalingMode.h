//
//  STSCircallScalingMode.h
//  StraaS
//
//  Created by Harry Hsu on 28/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#ifndef STSCircallScalingMode_h
#define STSCircallScalingMode_h

/**
 *  Constants specify how the video is displayed within a STSCircallPlayerView.
 */
typedef NS_ENUM(NSInteger, STSCircallScalingMode) {
    /**
     *  Specifies that the player should preserve the video’s aspect ratio and fit the video within the STSCircallPlayerView's bounds.
     */
    STSCircallScalingModeAspectFit,
    
    /**
     *  Specifies that the player should preserve the video’s aspect ratio and fill the STSCircallPlayerView's bounds.
     */
    STSCircallScalingModeAspectFill,
    
    /**
     *  Specifies that the video should be stretched to fill the STSCircallPlayerView's bounds.
     */
    STSCircallScalingModeFill
};

#endif /* STSCircallScalingMode_h */
