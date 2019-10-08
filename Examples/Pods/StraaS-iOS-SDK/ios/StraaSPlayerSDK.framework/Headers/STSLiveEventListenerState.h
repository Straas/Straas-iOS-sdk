//
//  STSLiveEventListenerState.h
//  StraaS
//
//  Created by shihwen.wang on 2018/2/21.
//  Copyright © 2018年 StraaS.io. All rights reserved.
//

#ifndef STSLiveEventListenerState_h
#define STSLiveEventListenerState_h

/**
 *  The state of the STSLiveEventListner.
 */
typedef NS_ENUM(NSInteger, STSLiveEventListenerState) {
    /**
     *  The STSLiveEventListner object is idle.
     */
    STSLiveEventListenerStateIdle = 0,
    /**
     *  The STSLiveEventListner object is attempting to connect to the server.
     */
    STSLiveEventListenerStateStarting = 1,
    /**
     *  The STSLiveEventListner object is connected to the server and can receive event.
     */    STSLiveEventListenerStateStarted = 2
};


#endif /* STSLiveEventListenerState_h */
