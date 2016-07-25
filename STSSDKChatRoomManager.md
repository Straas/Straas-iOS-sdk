---
layout: page
title: STSSDKChatRoomManager
permalink: /STSSDKChatRoomManager/
---

# Chat Room Manager

`STSSDKChatRoomManager` manages the real-time chat room powered by StraaS Messaging Service.

### Initialization

```
+ (instancetype)managerWithAccessToken:(NSString *)accessToken
                                   JWT:(NSString *)JWT
```

Create an `STSSDKChatRoomManager` object.

### Properties

- `mode`, read-only<br>
  Chat room mode.
- `cooldown`, read-only<br>
  Wait time before another message can be sent.
- `user`, read-only<br>
  Current user.
- `memberCount`, read-only<br>
  Number of logged in users.
- `guestCount`, read-only<br>
  Number of guest users.
- `allMessages`, read-only<br>
  All messages in chat room since user joined.
- `JWT`<br>
  User identity information.

### Tasks

`- (void)connectToChannel:(NSString *)channel`<br>
  Join chat room for channel. If chat room does not exist, create one and join it.

`- (void)disconnect`<br>
  Leave chat room.

`- (NSArray *)listUsersWithMaxCount:(NSUInteger)maxCount`<br>
  List chat room users with the max count limitation. Max count argument larger than 200 will be treat as 200.

`- (void)updateGuestNickname:(NSString *)nickname`<br>
  Update current guest nickname. If current user is not guest, do nothing.

`- (void)sendMessage:(NSString *)message`<br>
  Post a message to chat room.

### Notifications

- `STSSDKChatRoomDidConnectNotification`<br>
  Notifies observers that a chat room manager just successfully connected to a chat room.
- `STSSDKChatRoomDidDisconnectNotification`<br>
  Notifies observers that a chat room manager just disconnected from a chat room.
- `STSSDKChatRoomModeDidChangeNotification`<br>
  Notifies observers that chat room mode has changed.
- `STSSDKChatRoomMessagesDidChangeNotification`<br>
  Notifies observers that messages in the chat room has changed.
