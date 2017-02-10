//
//  STSStreamingState.h
//  StraaS
//
//  Created by shihwen.wang on 2016/10/27.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#ifndef STSStreamingState_h
#define STSStreamingState_h

/**
 *  The state of the STSStreamingManager.
 */
typedef NS_ENUM(NSUInteger, STSStreamingState) {
    /**
     *  The initial state.
     */
    STSStreamingStateIdle = 0,
    /**
     *  The STSStreamingManager is in the process of preparing.
     */
    STSStreamingStatePreparing = 1,
    /**
     *  The STSStreamingManager is ready for streaming. You can start streaming in this state.
     */
    STSStreamingStatePrepared = 2,
    /**
     *  The STSStreamingManager is connecting to the server, but is not yet connected.
     */
    STSStreamingStateConnecting = 3,
    /**
     *  The STSStreamingManager is streaming to the server.
     */
    STSStreamingStateStreaming = 4,
    /**
     *  The STSStreamingManager is in the process of disconnecting.
     */
    STSStreamingStateDisconnecting = 5
};
#endif /* STSStreamingState_h */
