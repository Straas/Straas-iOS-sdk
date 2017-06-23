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
#import "STSAggregatedData.h"
#import "STSChatroomConnectionOptions.h"
#import "STSGetMessagesConfiguration.h"
#import "STSGetArchivedMessagesConfiguration.h"
#import "STSArchivedMessagesMeta.h"
#import "STSGetUsersType.h"

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
 *  @param message      A STSChatMessage object with valid `text` property.
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

/**
 *  The pinned message of the specific chatroom updated.
 *
 *  @param chatroom A STSChat object informing the delegate about the pinned message update.
 *  @param message  The updated pinned message.
 */
- (void)chatroom:(STSChat *)chatroom pinnedMessageUpdated:(STSChatMessage * _Nullable)pinnedMessage;

@optional
/**
 *  Tells the delegate that an array of aggregated items has been added to data channel.
 *
 *  @param chatroom A STSChat object informing the delegate about aggregated items added.
 *  @param aggregatedItems An array of STSAggregatedItem objects.
 */
- (void)chatroom:(STSChat *)chatroom aggregatedItemsAdded:(NSArray<STSAggregatedItem *> *)aggregatedItems;

/**
 *  Tells the delegate that a raw data has been added to data channel.
 *
 *  @param chatroom A STSChat object informing the delegate about raw data added.
 *  @param rawData A STSChatMessage object with valid `rawData` property from data channel.
 */
- (void)chatroom:(STSChat *)chatroom rawDataAdded:(STSChatMessage *)rawData;

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
 *  @param userType     The type of users you want to get.
 *  @param success      Handler for successful request. It takes an `NSArray` of `STSChatUser`
                        argument that contains chat room active users.
 *  @param failure      Error handler.
 */
- (void)getUsersForChatroom:(STSChat *)chatroom
                   userType:(STSGetUsersType)userType
                    success:(void(^)(NSArray<STSChatUser *> * users))success
                    failure:(void(^)(NSError * error))failure;

/**
 *  Get chat room messages.
 *  Note: If there are over 5000 ccu in the chatroom, this method will return an empty array.
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
 *  Update role for given memberId.
 *
 *  @param role         The role want to be updated for target user. Role can be either kSTSUserRoleNormal or kSTSUserRoleModerator only.
 *  @param memberId     The CMS member id.
 *  @param chatroom     The STSChat object you want to update user role.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)updateUserRole:(NSString *)role memberId:(NSString *)memberId chatroom:(STSChat *)chatroom
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
 *  Send message to chatroom. 
 *  Note: Call this method more than once a second is not allowed.
 *
 *  @param message      Message text. Should be between 1~300 characters.
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
 *  Get the pinned message of a chatroom.
 *
 *  @param chatroom The STSChat object you want to get the pinned message.
 *  @param success  Handler for successful request.
 *  @param failure  Error handler.
 */
- (void)getPinnedMessageForChat:(STSChat *)chatroom
                        success:(void(^)(STSChatMessage * _Nullable pinnedMessage))success
                        failure:(void(^)(NSError * error))failure;

/**
 *  Pins a message to the chatroom.
 *
 *  Note:
 *  1. A chatroom can only have a pinned message at once, it means this method will override the last pinned message.
 *  2. This method works only when the current user of target chatroom has the privilege.
 *
 *  @param messageId    The message Id which you want to pin.
 *  @param chatroom     The STSChat object you want to pin the message.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)pinMessage:(NSString *)messageId
          chatroom:(STSChat *)chatroom
           success:(void(^)())success
           failure:(void(^)(NSError * error))failure;

/**
 *  Unpins a message from the given chatroom.
 *  Note: This method works only when the current user of target chatroom has the privilege.
 *
 *  @param chatroom The STSChat object you want to unpin the message.
 *  @param success  Handler for successful request.
 *  @param failure  Error handler.
 */
- (void)unpinMessageFromChatroom:(STSChat *)chatroom
                         success:(void(^)())success
                         failure:(void(^)(NSError * error))failure;

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

/**
 *  The following methods are about data channel. 
 *  This kind of messages are used to broadcast data and are not subjected to the input interval and user privilege.
 *  More information, ref: https://github.com/StraaS/StraaS-web-document/wiki/Messaging-Service-Concept
 */
@interface STSChatManager(DataChannel)

/**
 *  Send a key to the data channel which will be aggregated to STSAggregatedItem in `chatroom:aggregatedItemsAdded:`.
 *
 *  @param key          The Aggregated item string key. Should be between 1~100 characters.
 *  @param chatroom     The STSChat object you want to send message.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)sendAggregatedDataWithKey:(NSString *)key chatroom:(STSChat *)chatroom
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

/**
 *  Get chat room aggregated data.
 *
 *  @param chatroom      The STSChat object you want to get aggregated data.
 *  @param configuration A STSGetMessagesConfiguration object that specifies the request rules for getting messages.
 *  @param success       Handler for successful request. It takes an `NSArray` of `STSChatMessage` 
                         argument that contains chat room messages.
 *  @param failure       Error handler.
 */
- (void)getAggregatedDataForChatroom:(STSChat *)chatroom
                       configuration:(STSGetMessagesConfiguration * _Nullable)configuration
                             success:(void(^)(NSArray<STSAggregatedData *> * arrayAggregatedData))success
                             failure:(void(^)(NSError * error))failure;

/**
 *  Get chat room raw data.
 *
 *  @param chatroom      The STSChat object you want to get raw data.
 *  @param configuration A STSGetMessagesConfiguration object that specifies the request rules for getting messages.
 *  @param success       Handler for successful request. It takes an `NSArray` of `STSChatMessage`
                         argument that contains chat room messages.
 *  @param failure       Error handler.
 */
- (void)getRawDataForChatroom:(STSChat *)chatroom
                configuration:(STSGetMessagesConfiguration * _Nullable)configuration
                      success:(void(^)(NSArray<STSChatMessage *> * arrayRawData))success
                      failure:(void(^)(NSError * error))failure;

@end

/**
 *  The following methods are about archived messages which is designed to replay history messages.
 */
@interface STSChatManager (ArchivedMessage)

/**
 *  Get archived message meta object by archived id.
 *
 *  @param chatroomName The chatroom name you want to get archived messages.
 *  @param archivedId   The archived id to retrieve archived messages meta.
 *  @param success      Handler for successful request. It takes an STSArchivedMessagesMeta
                        argument that contains the specific archived meta.
 *  @param failure      Error handler.
 */
- (void)getArchivedMessageMetaForChatroom:(NSString *)chatroomName
                               archivedId:(NSString *)archivedId
                                  success:(void(^)(STSArchivedMessagesMeta * archivedMessageMeta))success
                                  failure:(void(^)(NSError * error))failure;
/**
 *  Get chat room archived messages.
 *  The response time is increasing with the number of messages included in one single request. 
 *  Normally, our best practice suggests |endTime-startTime| < 10000 (10 sec).
 *
 *  @param chatroomName  The chatroom name you want to get archived messages.
 *  @param configuration The STSGetArchivedMessagesConfiguration object that specifies the request rules for getting archived messages.
 *  @param success       Handler for successful request. It takes an 'NSArray' of 'STSChatMessage'
                         argument that contains the specific archived messages.
 *  @param failure       Error handler.
 */
- (void)getArchivedMessagesForChatroom:(NSString *)chatroomName
                         configuration:(STSGetArchivedMessagesConfiguration *)configuration
                               success:(void(^)(NSArray<STSChatMessage *> * messages))success
                               failure:(void(^)(NSError * error))failure;


@end
NS_ASSUME_NONNULL_END
