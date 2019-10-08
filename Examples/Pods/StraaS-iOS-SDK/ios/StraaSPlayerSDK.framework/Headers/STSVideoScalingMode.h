//
//  STSVideoScalingMode.h
//  StraaS
//
//  Created by shihwen.wang on 2017/1/9.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#ifndef STSVideoScalingMode_h
#define STSVideoScalingMode_h

/**
 *  Constants specify how the video is displayed within a STSSDKPLayerView.
 */
typedef NS_ENUM(NSInteger, STSVideoScalingMode) {
    /**
     *  Specifies that the player should preserve the video’s aspect ratio and fit the video within the STSSDKPLayerView's bounds.
     */
    STSVideoScalingModeAspectFit,

    /**
     *  Specifies that the player should preserve the video’s aspect ratio and fill the STSSDKPLayerView's bounds.
     */
    STSVideoScalingModeAspectFill,

    /**
     *  Specifies that the video should be stretched to fill the STSSDKPLayerView's bounds.
     */
    STSVideoScalingModeFill
};
#endif /* STSVideoScalingMode_h */
