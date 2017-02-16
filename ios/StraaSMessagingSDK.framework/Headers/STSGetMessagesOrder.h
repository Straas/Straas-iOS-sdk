//
//  STSGetMessagesOrder.h
//  StraaS
//
//  Created by Lee on 13/02/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#ifndef STSGetMessagesOrder_h
#define STSGetMessagesOrder_h

/**
 *  Options for how the messages will be sorted.
 */
typedef NS_ENUM(NSUInteger, STSGetMessagesOrder) {
    /**
     *  Get messages with ascending order.
     */
    STSGetMessagesOrderAscending     = 0,
    /**
     *  Get messages with descending order.
     */
    STSGetMessagesOrderDescending    = 1,
};

#endif /* STSGetMessagesOrder_h */
