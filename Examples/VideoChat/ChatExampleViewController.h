//
//  ChatExampleViewController.h
//  VideoChat
//
//  Created by Lee on 09/01/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "ChatViewController.h"

@class STSChatManager;

@interface ChatExampleViewController : ChatViewController

+ (instancetype)viewControllerWithJWT:(NSString *)JWT
                         chatroomName:(NSString *)chatroomName
                    connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

@end
