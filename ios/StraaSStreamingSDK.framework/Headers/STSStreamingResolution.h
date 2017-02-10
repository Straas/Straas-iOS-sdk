//
//  STSStreamingResolution.h
//  StraaS
//
//  Created by shihwen.wang on 2017/1/16.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#ifndef STSStreamingResolution_h
#define STSStreamingResolution_h

/**
 *  The highest resolution of the live event.
 */
typedef NS_ENUM(NSUInteger, STSStreamingResolution) {
    /**
     *  1080p resolution.(1920 * 1080)
     */
    STSStreamingResolution1080p,

    /**
     *  720p resolution.(1280 x 720)
     */
    STSStreamingResolution720p
};

#endif /* STSStreamingResolution_h */
