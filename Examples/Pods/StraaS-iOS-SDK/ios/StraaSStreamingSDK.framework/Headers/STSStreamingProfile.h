//
//  STSStreamingProfile.h
//  StraaS
//
//  Created by shihwen.wang on 2018/4/16.
//  Copyright © 2018年 StraaS.io. All rights reserved.
//

#ifndef STSStreamingProfile_h
#define STSStreamingProfile_h

/**
 *  The profile of the live event.
 */
typedef NS_ENUM(NSUInteger, STSStreamingProfile) {
    /**
     *  No profile setting.
     */
    STSStreamingProfileNone,
    /**
     *  1080p(1920 x 1080) and origin streaming source.
     */
    STSStreamingProfile1080pAndSource,

    /**
     *  720p(1280 x 720) and origin streaming source.
     */
    STSStreamingProfile720pAndSource,

    /**
     *  720p resolution.(1280 x 720)
     */
    STSStreamingProfile720p,

    /**
     *  360p resolution.(640 x 360)
     */
    STSStreamingProfile360p,
};

#endif /* STSStreamingProfile_h */
