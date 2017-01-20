//
//  STSGetUsersType.h
//  StraaS
//
//  Created by Lee on 26/12/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#ifndef STSGetUsersType_h
#define STSGetUsersType_h

/**
 *  The type of users you want to get.
 */
typedef NS_ENUM(NSUInteger, STSGetUsersType) {
    /**
     *  Get the online users from user list.
     *  STSGetUsersTypeOnlineUsers will return every online user except those who were blocked.
     */
    STSGetUsersTypeOnlineUsers,
    /**
     *  Get the blocked users from user list no matter the user is online or not.
     */
    STSGetUsersTypeBlocked,
    /**
     *  Get the supervisors user from user list.
     *  STSGetUsersTypeModerator will return whose role is Globale manager, localManager, master, or moderator. No matter that user is online or not.
     */
    STSGetUsersTypeSupervisor,
};

#endif /* STSGetUsersType_h */
