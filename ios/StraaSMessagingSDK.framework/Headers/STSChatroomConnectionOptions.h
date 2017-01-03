//
//  STSChatroomConnectionOptions.h
//  StraaS
//
//  Created by Lee on 03/01/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#ifndef STSChatroomConnectionOptions_h
#define STSChatroomConnectionOptions_h

/**
 *  STSChatroomConnectionOptions Options for connecting to the chatroom you want.
 */
typedef NS_OPTIONS(NSUInteger, STSChatroomConnectionOptions) {
    /**
     *  Default option, connect to the chatroom based on the chatroomName.
     */
    STSChatroomConnectionNone               = 0,
    /**
     *  Connect to the personal chatroom.
     */
    STSChatroomConnectionIsPersonalChat     = 1 << 0,
    /**
     *  Connect to the chatroom with data channel.
     */
    STSChatroomConnectionWithDataChannel    = 1 << 1,
};

#endif /* STSChatroomConnectionOptions_h */
