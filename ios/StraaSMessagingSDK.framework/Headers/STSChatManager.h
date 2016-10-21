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
 *  @param chatRoomName Identifier of chat room.
 */
- (void)chatRoomConnected:(NSString *)chatRoomName;

/**
 *  Chat room disconnected.
 *
 *  @param chatRoomName Identifier of chat room.
 */
- (void)chatRoomDisconnected:(NSString *)chatRoomName;

/**
 *  Chat room fail to connect.
 *
 *  @param chatRoomName Identifier of chat room.
 *  @param error        The error object contains detail info.
 */
- (void)chatRoom:(NSString *)chatRoomName failToConnect:(NSError *)error;

/**
 *  Error happened for chat room.
 *
 *  @param chatRoomName Identifier of chat room.
 *  @param error        The error object contains error detail.
 */
- (void)chatRoom:(NSString *)chatRoomName error:(NSError *)error;

/**
 *  Chat room input mode changed.
 *
 *  @param chatRoomName Identifier of chat room.
 */
- (void)chatRoomInputModeChanged:(NSString *)chatRoomName;

/**
 *  Users joined to chat room.
 *
 *  @param chatRoomName Identifier of chat room.
 *  @param users        New user objects.
 */
- (void)chatRoom:(NSString *)chatRoomName usersJoined:(NSArray<STSChatUser *> *)users;

/**
 *  Users info updated for chat room.
 *
 *  @param chatRoomName Identifier of chat room.
 *  @param users        Updated user objects
 */
- (void)chatRoom:(NSString *)chatRoomName usersUpdated:(NSArray<STSChatUser *> *)users;

/**
 *  Users left from chat room.
 *
 *  @param chatRoomName Identifier of chat room.
 *  @param userLabels   Unique identifier of left users.
 */
- (void)chatRoom:(NSString *)chatRoomName usersLeft:(NSArray<NSNumber *> *)userLabels;

/**
 *  User count updated for chat room. Please check the chat object for new member count and guest count.
 *
 *  @param chatRoomName Identifier of chat room.
 */
- (void)chatRoomUserCount:(NSString *)chatRoomName;

/**
 *  Message was added to chat room.
 *
 *  @param chatRoomName Identifier of chat room.
 *  @param message      New message object.
 */
- (void)chatRoom:(NSString *)chatRoomName messageAdded:(STSChatMessage *)message;

/**
 *  Message was removed from chat room.
 *
 *  @param chatRoomName Identifier of chat room.
 *  @param messageId    Removed message object ID.
 */
- (void)chatRoom:(NSString *)chatRoomName messageRemoved:(NSString *)messageId;

/**
 *  All message in chat room was flushed for chat room.
 *
 *  @param chatRoomName Identifier of chat room.
 */
- (void)chatRoomMessageFlushed:(NSString *)chatRoomName;

@end

/**
 *  StraaS.io chat room manager, support multi-connection management.
 */
@interface STSChatManager : NSObject

/**
 *  A collection of connected chat room IDs.
 */
@property (nonatomic, readonly) NSSet<NSString *> * connectedChatRoomNames;

/**
 *  Connect to chat room with user JWT.
 *
 *  @param chatRoomName  Identifier of chat room. Don't pass nil or this method return early.
 *  @param JWT           User identity information. For StraaS.io CMS member, a member JWT should be
                         used here. Use an empty string to represent guest. Don't pass nil or this
                         method return early.
 *  @param autoCreate    Create a new chat room or not, if the chat room ID can not be found. Note:
                         auto-create feature needs to be enabled by the server side. Please contact
                         StraaS.io support for further information.
 *  @param eventDelegate Chat event delegate. Chat manager not retain this delegate.
 */
- (void)connectToChatRoom:(NSString *)chatRoomName JWT:(NSString *)JWT autoCreate:(BOOL)autoCreate
            eventDelegate:(nullable id<STSChatEventDelegate>)eventDelegate;

/**
 *  Disconnect from a connected chat room.
 *
 *  @param chatRoomName Identifier of chat room.
 */
- (void)disconnectFromChatRoom:(NSString *)chatRoomName;

/**
 *  Get chat room active users, maximum 200 users.
 *
 *  @param chatRoomName Identifier of chat room.
 *  @param success      Handler for successful request. It takes an `NSArray` of `STSChatUser`
                        argument that contains chat room active users.
 *  @param failure      Error handler.
 */
- (void)getUsersForChatRoom:(NSString *)chatRoomName
                    success:(void(^)(NSArray<STSChatUser *> * users))success
                    failure:(void(^)(NSError *))failure;

/**
 *  Get chat room messages, maximum 100 messages.
 *
 *  @param chatRoomName Identifier of chat room.
 *  @param success      Handler for successful request. It takes an `NSArray` of `STSChatMessage`
                        argument that contains chat room messages.
 *  @param failure      Error handler.
 */
- (void)getMessagesForChatRoom:(NSString *)chatRoomName
                       success:(void(^)(NSArray<STSChatMessage *> * messages))success
                       failure:(void(^)(NSError *))failure;

/**
 *  Update nickname for guest user.
 *
 *  @param nickname     New nickname. Should be between 1~20 characters.
 *  @param chatRoomName Identifier of chat room.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)updateGuestNickname:(NSString *)nickname chatRoom:(NSString *)chatRoomName
                    success:(void(^)())success failure:(void(^)(NSError * error))failure;

/**
 *  Send chat message.
 *
 *  @param message      Message text. Should be between 1~120 characters.
 *  @param chatRoomName Identifier of chat room.
 *  @param success      Handler for successful request.
 *  @param failure      Error handler.
 */
- (void)sendMessage:(NSString *)message chatRoom:(NSString *)chatRoomName
            success:(void(^)())success failure:(void(^)(NSError * error))failure;

/**
 *  Returns the chat object.
 *
 *  @param chatRoomName Identifier of chat room.
 *
 *  @return A `STSChat` instance if the chat room is connected, or nil.
 */
- (nullable STSChat *)chatForChatRoom:(NSString *)chatRoomName;

/**
 *  Returns the current chat user object.
 *
 *  @param chatRoomName Identifier of chat room.
 *
 *  @return A `STSChatUser` instance if the chat room is connected, or nil.
 */
- (nullable STSChatUser *)currentUserForChatRoom:(NSString *)chatRoomName;

/**
 *  Returns the cooldown to send next message for chat room.
 *
 *  @param chatRoomName Identifier of chat room.
 *
 *  @return The cooldown in seconds.
 */
- (NSTimeInterval)cooldownForChatRoom:(NSString *)chatRoomName;

/**
 *  Update the chat room event delegate.
 *
 *  @param delegate     Chat room event delegate.
 *  @param chatRoomName Identifier of chat room.
 */
- (void)setEventDelegate:(nullable id<STSChatEventDelegate>)delegate forChatRoom:(NSString *)chatRoomName;

@end

NS_ASSUME_NONNULL_END
