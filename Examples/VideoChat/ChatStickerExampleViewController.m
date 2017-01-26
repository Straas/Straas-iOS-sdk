//
//  ChatroomExampleViewController.m
//  VideoChat
//
//  Created by Lee on 05/01/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "ChatStickerExampleViewController.h"
#import "ChatExampleViewController.h"

@interface ChatStickerExampleViewController ()

@end

@implementation ChatStickerExampleViewController {
    __weak id _weakSelf;
}

+ (instancetype)viewControllerWithJWT:(NSString *)JWT
                         chatroomName:(NSString *)chatroomName
                    connectionOptions:(STSChatroomConnectionOptions)connectionOptions {
    ChatStickerExampleViewController * viewController =
    [[ChatStickerExampleViewController alloc] initWithJWT:JWT
                                          chatroomName:chatroomName
                                     connectionOptions:connectionOptions];
    return viewController;
}

+ (instancetype)viewControllerWithChatViewController:(ChatViewController *)chatViewController {
    NSAssert([chatViewController isKindOfClass:[ChatViewController class]],
             @"chatViewController should be ChatViewController class of its subclass");
    ChatStickerExampleViewController * viewController =
    [ChatStickerExampleViewController chatStickerViewControllerWithChatViewController:chatViewController];
    return viewController;
}

- (instancetype)initWithJWT:(NSString *)JWT
               chatroomName:(NSString *)chatroomName
          connectionOptions:(STSChatroomConnectionOptions)connectionOptions {
    if (self = [super initWithJWT:JWT chatroomName:chatroomName connectionOptions:connectionOptions]) {
        //Do custom init here.
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _weakSelf = self;
    [self configureApplication:^{
        [_weakSelf connectToChat];
    } failure:^(NSError *error) {
        NSLog(@"fail to connect to chat with error %@", error);
    }];
}

#pragma mark - STSChatEventDelegate
//This is the example showing you how to customize the STSChatEventEelegate callback.
- (void)chatroomConnected:(STSChat *)chatroom {
    [super chatroomConnected:chatroom];
    NSLog(@"ChatStickerExampleViewController: \"%@\" connected", chatroom.chatroomName);
}

- (void)chatroomDisconnected:(STSChat *)chatroom {
    [super chatroomDisconnected:chatroom];
    NSLog(@"ChatStickerExampleViewController: \"%@\" disconnected", chatroom.chatroomName);
}

- (void)chatroom:(STSChat *)chatroom failToConnect:(NSError *)error {
    [super chatroom:chatroom failToConnect:error];
    NSLog(@"ChatStickerExampleViewController: \"%@\" fail to connect", chatroom.chatroomName);
    NSLog(@"%@", error);
}

- (void)chatroom:(STSChat *)chatroom error:(NSError *)error {
    [super chatroom:chatroom error:error];
    NSLog(@"ChatStickerExampleViewController: \"%@\" occured error %@", chatroom.chatroomName, error);
}

- (void)chatroomInputModeChanged:(STSChat *)chatroom {
    [super chatroomInputModeChanged:chatroom];
    NSLog(@"ChatStickerExampleViewController: \"%@\" input mode change to %lu", chatroom.chatroomName, chatroom.mode);
}

- (void)chatroom:(STSChat *)chatroom usersJoined:(NSArray<STSChatUser *> *)users {
    [super chatroom:chatroom usersJoined:users];
    NSLog(@"ChatStickerExampleViewController: %@ joined \"%@\"", users, chatroom.chatroomName);
    
}

- (void)chatroom:(STSChat *)chatroom usersUpdated:(NSArray<STSChatUser *> *)users {
    [super chatroom:chatroom usersUpdated:users];
    NSLog(@"ChatStickerExampleViewController: %@ updated in \"%@\"", users, chatroom.chatroomName);
}

- (void)chatroom:(STSChat *)chatroom usersLeft:(NSArray<NSNumber *> *)userLabels {
    [super chatroom:chatroom usersLeft:userLabels];
    NSLog(@"ChatStickerExampleViewController: %@ left \"%@\"", userLabels, chatroom.chatroomName);
}

- (void)chatroomUserCount:(STSChat *)chatroom {
    [super chatroomUserCount:chatroom];
    NSLog(@"ChatStickerExampleViewController: \"%@\" user count = %d", chatroom.chatroomName, (int)chatroom.userCount);
}

- (void)chatroom:(STSChat *)chatroom messageAdded:(STSChatMessage *)message {
    [super chatroom:chatroom messageAdded:message];
    NSLog(@"ChatStickerExampleViewController: \"%@\" add message:%@", chatroom.chatroomName, message.text);
}

- (void)chatroom:(STSChat *)chatroom messageRemoved:(NSString *)messageId {
    [super chatroom:chatroom messageRemoved:messageId];
    NSLog(@"ChatStickerExampleViewController: \"%@\" remove message:%@", chatroom.chatroomName, messageId);
}

- (void)chatroomMessageFlushed:(STSChat *)chatroom {
    [super chatroomMessageFlushed:chatroom];
    NSLog(@"ChatStickerExampleViewController: \"%@\" \n message flushed", chatroom.chatroomName);
}

- (void)chatroom:(STSChat *)chatroom aggregatedDataAdded:(NSDictionary *)aggregatedData {
    [super chatroom:chatroom aggregatedDataAdded:aggregatedData];
    NSLog(@"ChatStickerExampleViewController: \"%@\" \n aggregated data add: %@", chatroom.chatroomName, aggregatedData);
}

- (void)chatroom:(STSChat *)chatroom rawDataAdded:(id)rawData {
    [super chatroom:chatroom rawDataAdded:rawData];
    NSLog(@"ChatStickerExampleViewController: \"%@\" \n raw data add: %@", chatroom.chatroomName, rawData);
}

@end
