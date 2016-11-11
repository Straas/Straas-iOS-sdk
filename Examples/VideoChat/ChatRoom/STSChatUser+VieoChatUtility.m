//
//  STSChatUser+VieoChatUtility.m
//  VideoChat
//
//  Created by Lee on 11/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import "STSChatUser+VieoChatUtility.h"

@implementation STSChatUser (VieoChatUtility)

- (BOOL)canChatInAnchorMode {
    return ([self.role isEqualToString:kSTSUserRoleMaster] ||
            [self.role isEqualToString:kSTSUserRoleLocalManager] ||
            [self.role isEqualToString:kSTSUserRoleModerator]);
}

@end
