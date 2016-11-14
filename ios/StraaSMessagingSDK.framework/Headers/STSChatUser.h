//
//  STSChatUser.h
//  StraaS
//
//  Created by Luke Jang on 8/10/16.
//  Copyright (c) 2016年 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  The keys of the user role. Get more informations in the following link.
 *  https://github.com/StraaS/StraaS-web-document/wiki/Messaging-Service#roles-of-messaging-service
 */
extern NSString * const kSTSUserRoleLocalManager;
extern NSString * const kSTSUserRoleMaster;
extern NSString * const kSTSUserRoleModerator;
extern NSString * const kSTSUserRoleNormal;
extern NSString * const kSTSUserRoleBlocked;

/**
 *  Chat room user model
 */
@interface STSChatUser : LHDataObject

/**
 *  Unique identifier of chat room user. Users are identifying and comparing using this attribute.
 *  (`NSObject` method `isEqual:` and `hash` are implemented).
 */
@property (nonatomic, readonly, nullable) NSNumber * label;

/**
 *  Guest nickname or member name.
 */
@property (nonatomic, readonly, nullable) NSString * name;

/**
 *  Chat room member avatar
 */
@property (nonatomic, readonly, nullable) NSString * avatar;

/**
 *  When user info was updated.
 */
@property (nonatomic, readonly, nullable) NSString * updatedDate;

/**
 *  User's role.
 */
@property (nonatomic, readonly, nullable) NSString * role;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
