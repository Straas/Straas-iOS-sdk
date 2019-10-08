//
//  STSCircallState.h
//  StraaS
//
//  Created by Harry Hsu on 27/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#ifndef STSCircallState_h
#define STSCircallState_h

/**
 *  The state of the STSCircallManager.
 */
typedef NS_ENUM(NSUInteger, STSCircallState) {
    /**
     *  The initial state. You can connect to a room in this state.
     */
    STSCircallStateIdle = 0,
    
    /**
     *  The STSCircallManager is in the process of preparing.
     */
    STSCircallStatePreparing = 1,
    
    /**
     *  The STSCircallManager is ready. You can connect to a room in this state.
     */
    STSCircallStatePrepared = 2,
    
    /**
     *  The STSCircallManager is connecting to the room, but is not yet connected.
     */
    STSCircallStateConnecting = 3,
    
    /**
     *  The STSCircallManager is connected to the room.
     */
    STSCircallStateConnected = 4,
    
    /**
     * The STSCircallManager is in the process of disconnecting.
     */
    STSCircallStateDisconnecting = 5
};

#endif /* STSCircallState_h */
