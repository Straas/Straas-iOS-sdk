//
//  ChatExampleViewController.m
//  VideoChat
//
//  Created by Lee on 09/01/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "ChatExampleViewController.h"

@interface ChatExampleViewController ()

@end

@implementation ChatExampleViewController {
    __weak id _weakSelf;
}

#pragma mark - STSChatEventDelegate
//This is the example showing you how to customize the STSChatEventEelegate callback.
- (void)chatroomConnected:(STSChat *)chatroom {
    [super chatroomConnected:chatroom];
    NSLog(@"ChatExampleViewController: \"%@\" connected", chatroom.chatroomName);
}

- (void)chatroomDisconnected:(STSChat *)chatroom {
    [super chatroomDisconnected:chatroom];
    NSLog(@"ChatExampleViewController: \"%@\" disconnected", chatroom.chatroomName);
}

- (void)chatroom:(STSChat *)chatroom failToConnect:(NSError *)error {
    [super chatroom:chatroom failToConnect:error];
    NSLog(@"ChatExampleViewController: \"%@\" fail to connect", chatroom.chatroomName);
    NSLog(@"%@", error);
}

- (void)chatroom:(STSChat *)chatroom error:(NSError *)error {
    [super chatroom:chatroom error:error];
    NSLog(@"ChatExampleViewController: \"%@\" occured error %@", chatroom.chatroomName, error);
}

- (void)chatroomInputModeChanged:(STSChat *)chatroom {
    [super chatroomInputModeChanged:chatroom];
    NSLog(@"ChatExampleViewController: \"%@\" input mode change to %lu", chatroom.chatroomName, chatroom.mode);
}

- (void)chatroom:(STSChat *)chatroom usersJoined:(NSArray<STSChatUser *> *)users {
    [super chatroom:chatroom usersJoined:users];
    NSLog(@"ChatExampleViewController: %@ joined \"%@\"", users, chatroom.chatroomName);
    
}

- (void)chatroom:(STSChat *)chatroom usersUpdated:(NSArray<STSChatUser *> *)users {
    [super chatroom:chatroom usersUpdated:users];
    NSLog(@"ChatExampleViewController: %@ updated in \"%@\"", users, chatroom.chatroomName);
}

- (void)chatroom:(STSChat *)chatroom usersLeft:(NSArray<NSNumber *> *)userLabels {
    [super chatroom:chatroom usersLeft:userLabels];
    NSLog(@"ChatExampleViewController: %@ left \"%@\"", userLabels, chatroom.chatroomName);
}

- (void)chatroomUserCount:(STSChat *)chatroom {
    [super chatroomUserCount:chatroom];
    NSLog(@"ChatExampleViewController: \"%@\" user count = %d", chatroom.chatroomName, (int)chatroom.userCount);
}

- (void)chatroom:(STSChat *)chatroom messageAdded:(STSChatMessage *)message {
    [super chatroom:chatroom messageAdded:message];
    NSLog(@"ChatExampleViewController: \"%@\" add message:%@", chatroom.chatroomName, message.text);
}

- (void)chatroom:(STSChat *)chatroom messageRemoved:(NSString *)messageId {
    [super chatroom:chatroom messageRemoved:messageId];
    NSLog(@"ChatExampleViewController: \"%@\" remove message:%@", chatroom.chatroomName, messageId);
}

- (void)chatroomMessageFlushed:(STSChat *)chatroom {
    [super chatroomMessageFlushed:chatroom];
    NSLog(@"ChatExampleViewController: \"%@\" \n message flushed", chatroom.chatroomName);
}

- (void)chatroom:(STSChat *)chatroom aggregatedDataAdded:(NSDictionary *)aggregatedData {
    [super chatroom:chatroom aggregatedDataAdded:aggregatedData];
    NSLog(@"ChatExampleViewController: \"%@\" \n aggregated data add: %@", chatroom.chatroomName, aggregatedData);
}

- (void)chatroom:(STSChat *)chatroom rawDataAdded:(id)rawData {
    [super chatroom:chatroom rawDataAdded:rawData];
    NSLog(@"ChatExampleViewController: \"%@\" \n raw data add: %@", chatroom.chatroomName, rawData);
}

@end
