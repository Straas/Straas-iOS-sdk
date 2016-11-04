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
    STSStreamingStateIdle,
    /**
     *  The STSStreamingManager is in the process of preparing.
     */
    STSStreamingStatePreparing,
    /**
     *  The STSStreamingManager is ready for streaming. You can start streaming in this state.
     */
    STSStreamingStatePrepared,
    /**
     *  The STSStreamingManager is connecting to the server, but is not yet connected.
     */
    STSStreamingStateConnecting,
    /**
     *  The STSStreamingManager is streaming to the server.
     */
    STSStreamingStateStreaming,
    /**
     *  The STSStreamingManager is in the process of disconnecting.
     */
    STSStreamingStateDisconnecting
};
#endif /* STSStreamingState_h */
