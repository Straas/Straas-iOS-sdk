//
//  STSChatRoomManager.h
//  StraaS
//
//  Created by Luke Jang on 2016/8/15.
//  Copyright (c) 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STSChat.h"
#import "STSChatUser.h"
#import "STSChatMessage.h"
#import "STSChatroomConnectionOptions.h"
#import "STSGetMessagesConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Chat room event delegate for notify chat connection event, mode change event, user event, or
 *  message event. Allow to handle chat room events in real time.
 */
@protocol STSChatEventDelegate <NSObject>

@optional

/**
 *  Chat room connected.
 *
 *  @param chatroom A STSChat object informing the delegate about the connection of chatroom.
 */
- (void)chatroomConnected:(STSChat *)chatroom;

/**
 *  Chat room disconnected.
 *
 *  @param chatroom A STSChat object informing the delegate about the disconnection.
 */
- (void)chatroomDisconnected:(STSChat *)chatroom;

/**
 *  Chat room fail to connect.
 *
 *  @param chatroom A STSChat object informing the delegate about the failure of chatroom connection.
 *  @param error    The error object contains detail info.
 */
- (void)chatroom:(STSChat *)chatroom failToConnect:(NSError *)error;

/**
 *  Error happened for chat room.
 *
 *  @param chatroom A STSChat object informing the delegate about the error.
 *  @param error    The error object contains error detail.
 */
- (void)chatroom:(STSChat *)chatroom error:(NSError *)error;

/**
 *  Chat room input mode changed.
 *
 *  @param chatroom A STSChat object informing the delegate about the mode changed.
 */
- (void)chatroomInputModeChanged:(STSChat *)chatroom;

/**
 *  Users joined to chat room.
 *
 *  @param chatroom A STSChat object informing the delegate about users joined.
 *  @param users    New user objects.
 */
- (void)chatroom:(STSChat *)chatroom usersJoined:(NSArray<STSChatUser *> *)users;

/**
 *  Users info updated for chat room.
 *
 *  @param chatroom A STSChat object informing the delegate about users updated.
 *  @param users    Updated user objects
 */
- (void)chatroom:(STSChat *)chatroom usersUpdated:(NSArray<STSChatUser *> *)users;

/**
 *  Users left from chat room.
 *
 *  @param chatroom     A STSChat object informing the delegate about users left.
 *  @param userLabels   Unique identifier of left users.
 */
- (void)chatroom:(STSChat *)chatroom usersLeft:(NSArray<NSNumber *> *)userLabels;

/**
 *  User count updated for chat room. Please check the chat object for new user count.
 *
 *  @param chatroom     A STSChat object informing the delegate about users count changed.
 */
- (void)chatroomUserCount:(STSChat *)chatroom;

/**
 *  Message was added to chat room.
 *
 *  @param chatroom     A STSChat object informing the delegate about message added.
 *  @param message      New message object.
 */
- (void)chatroom:(STSChat *)chatroom messageAdded:(STSChatMessage *)message;

/**
 *  Message was removed from chat room.
 *
 *  @param chatroom     A STSChat object informing the delegate about message removed.
 *  @param messageId    Removed message object ID.
 */
- (void)chatroom:(STSChat *)chatroom messageRemoved:(NSString *)messageId;

/**
 *  All message in chat room was flushed for chat room.
 *
 *  @param chatroom     A STSChat object informing the delegate about message flushed.
 */
- (void)chatroomMessageFlushed:(STSChat *)chatroom;

@optional
/**
 *  Tells the delegate that an aggregated data has been added to data channel.
 *
 *  @param chatroom A STSChat object informing the delegate about aggregated data added.
 *  @param aggregatedData An NSDictionary object of aggregated data from data channel.
 */
- (void)chatroom:(STSChat *)chatroom aggregatedDataAdded:(NSDictionary *)aggregatedData;

/**
 *  Tells the delegate that a raw data has been added to data channel.
 *
 *  @param chatroom A STSChat object informing the delegate about raw data added.
 *  @param rawData A valid JSON object from data channel.
 */
- (void)chatroom:(STSChat *)chatroom rawDataAdded:(id)rawData;

@end

/**
 *  StraaS.io chat room manager, support multi-connection management.
 */
@interface STSChatManager : NSObject

/**
 *  Connect to chat room with user JWT.
 *
 *  @param chatroomName Identifier of chat room. Don't pass nil or this method return early.
 *  @param JWT          User identity information. For StraaS.io CMS member, a member JWT should be
                        used here. Use an empty string to represent guest. Don't pass nil or this
                        method return early.
 *  @param options      Options for connecting to the chatroom you want.
 *  @param eventDelegate Chat event delegate. Chat manager not retain this delegate.
 */
- (void)connectToChatroom:(NSString *)chatroomName JWT:(NSString *)JWT options:(STSChatroomConnectionOptions)options
            eventDelegate:(nullable id<STSChatEventDelegate>)eventDelegate;

/**
 *  Disconnect from a connected chat room.
 *
 *  @param chatroom The STSChat object you want to disconnect.
 */
- (void)disconnectFromChatroom:(STSChat *)chatroom;

/**
 *  Get chat room active users, maximum 200 users.
 *
 *  @param chatroom     The STSChat object you want to get users.
 *  @param success      Handler for successful request. It takes an `NSArray` of `STSChatUser`
                        argument that contains chat room active users.
 *  @param failure      Error handler.
 */
- (void)getUsersForChatroom:(STSChat *)chatroom
                    success:(void(^)(NSArray<STSChatUser *> * users))success
                    failure:(void(^)(NSError * error))failure;

/**
 *  Get chat room messages.
 *
 *  @param chatroom      The STSChat object you want to get messages.
 *  @param configuration A STSGetMessagesConfiguration object that specifies the request rules for getting messages.
 *  @param success       Handler for successful request. It takes an `NSArray` of `STSChatMessage`
                         argument that contains chat room messages.
 *  @param failure       Error handler.
 */
- (void)getMessagesForChatroom:(STSChat *)chatroom
                 configuration:(STSGetMessagesConfiguration * _Nullable)configuration
                       success:(void(^)(NSArray<STSChatMessage *> * messages))success
                       failure:(void(^)(NSError * error))failure;

/**
 *  Update nickname for guest user.
 *
 *  @param nickname     New nickname. Should be between 1~20 characters.
 *  @param chatroom     The STSChat object you want to update nickname.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)updateGuestNickname:(NSString *)nickname chatroom:(STSChat *)chatroom
                    success:(void(^)())success failure:(void(^)(NSError * error))failure;

/**
 *  Update role for given user.
 *
 *  @param role         The role want to be updated for target user. Role can be either kSTSUserRoleNormal or kSTSUserRoleModerator only.
 *  @param targetUser   The users needs to be updated.
 *  @param chatroom     The STSChat object you want to update user role.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)updateUserRole:(NSString *)role targetUser:(STSChatUser *)targetUser chatroom:(STSChat *)chatroom
               success:(void(^)())success failure:(void(^)(NSError * error))failure;
/**
 *  Block users by current user. Only succeed when current user has the privilege.
 *
 *  @param users        The users in chat going to be blocked
 *  @param chatroom     The STSChat object you want to block users.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)blockUsers:(NSArray <STSChatUser *>*)users chatroom:(STSChat *)chatroom
           success:(void(^)())success failure:(void(^)(NSError * error))failure;

/**
 *  Revive users by current user. Only succeed when current user has the privilege.
 *
 *  @param users        The users in chat going to be revived.
 *  @param chatroom     The STSChat object you want to revive users.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)reviveUsers:(NSArray <STSChatUser *>*)users chatroom:(STSChat *)chatroom
            success:(void(^)())success failure:(void(^)(NSError * error))failure;

/**
 *  Send chat message.
 *
 *  @param message      Message text. Should be between 1~120 characters.
 *  @param chatroom     The STSChat object you want to send message.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)sendMessage:(NSString *)message chatroom:(STSChat *)chatroom
            success:(void(^)())success failure:(void(^)(NSError * error))failure;

/**
 *  Remove chat message.
 *  Note: This method works only when the current user of target chatroom has the privilege.
 *
 *  @param messageId    The message Id which you want to remove.
 *  @param chatroom     The STSChat object you want to remove message.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)removeMessage:(NSString *)messageId chatroom:(STSChat *)chatroom
              success:(void(^)())success failure:(void(^)(NSError * error))failure;

/**
 *  Returns the chat object.
 *
 *  @param chatroomName Identifier of chat room.
 *  @param isPersonalChat A boolean value indicates whether the chat object is personal or not.
 *
 *  @return A `STSChat` instance if the chat room is connected, or nil.
 */
- (nullable STSChat *)chatForChatroomName:(NSString *)chatroomName isPersonalChat:(BOOL)isPersonalChat;

/**
 *  Returns the current chat user object.
 *
 *  @param chatroom     The STSChat object you want to get current user.
 *
 *  @return A `STSChatUser` instance if the chat room is connected, or nil.
 */
- (nullable STSChatUser *)currentUserForChatroom:(STSChat *)chatroom;

/**
 *  Returns the cooldown to send next message for chat room.
 *
 *  @param chatroom     The STSChat object you want to get the cooldown time.
 *
 *  @return The cooldown in seconds.
 */
- (NSTimeInterval)cooldownForChatroom:(STSChat *)chatroom ;

/**
 *  Update the chat room event delegate.
 *
 *  @param delegate     Chat room event delegate.
 *  @param chatroom     The STSChat object you want to set with the event delegate.
 */
- (void)setEventDelegate:(nullable id<STSChatEventDelegate>)delegate forChatroom:(STSChat *)chatroom;

@end

@interface STSChatManager(DataChaanel)

/**
 *  Send aggregate data to data channel.
 *
 *  @param data         The Aggregate data string. Should be between 1~50 characters.
 *  @param chatroom     The STSChat object you want to send message.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)sendAggregatedData:(NSString *)data chatroom:(STSChat *)chatroom
                   success:(void(^)())success failure:(void(^)(NSError * error))failure;

/**
 *  Send raw data to data channel. Raw data should be a valid JSON object only.
 *  ref: https://developer.apple.com/reference/foundation/jsonserialization/1418461-isvalidjsonobject
 *
 *  @param rawData      The jsonObject raw data.
 *  @param chatroom     The STSChat object you want to send message.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)sendRawData:(id)rawData chatroom:(STSChat *)chatroom
            success:(void(^)())success failure:(void(^)(NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
