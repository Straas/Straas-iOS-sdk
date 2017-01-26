//
//  ChatStickerExampleViewController.h
//  VideoChat
//
//  Created by Lee on 05/01/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "ChatStickerViewController.h"

@class STSChatManager;
@class ChatViewController;

@interface ChatStickerExampleViewController : ChatStickerViewController

+ (instancetype)viewControllerWithJWT:(NSString *)JWT
                         chatroomName:(NSString *)chatroomName
                    connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

+ (instancetype)viewControllerWithChatViewController:(ChatViewController *)chatViewController;

@end