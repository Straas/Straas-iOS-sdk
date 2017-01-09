//
//  ChatStickerExampleViewController.h
//  VideoChat
//
//  Created by Lee on 05/01/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "ChatStickerViewController.h"

@class STSChatManager;

@interface ChatStickerExampleViewController : ChatStickerViewController

+ (instancetype)viewControllerWithJWT:(NSString *)JWT
                         chatroomName:(NSString *)chatroomName
                    connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

+ (instancetype)viewControllerWithJWT:(NSString *)JWT
                         chatroomName:(NSString *)chatroomName
                    connectionOptions:(STSChatroomConnectionOptions)connectionOptions
                   chatViewController:(id)chatViewController;

@end
