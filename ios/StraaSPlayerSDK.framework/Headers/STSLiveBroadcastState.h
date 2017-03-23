//
//  STSLiveBroadcastState.h
//  StraaS
//
//  Created by shihwen.wang on 2017/3/22.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#ifndef STSLiveEventStatus_h
#define STSLiveEventStatus_h

/**
 *  The broadcast state of the live.
 */
typedef NS_ENUM(NSInteger, STSLiveBroadcastState) {
    /**
     *  The broadcast state of the live cannot be determined.
     */
    STSLiveBroadcastStateUnknown = 0,

    /**
     *  The stream of the live has started.
     */
    STSLiveBroadcastStateStreamStarted = 1,

    /**
     *  The stream of the live has stopped.
     */
    STSLiveBroadcastStateStreamStopped = 2,

    /**
     *  The live is waiting for stream.
     */
    STSLiveBroadcastStateWaitingForStream = 3,

    /**
     *  The live event has ended.
     */
    STSLiveBroadcastStateEventEnded = 4,
};

#endif /* STSLiveEventStatus_h */
