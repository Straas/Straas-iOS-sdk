//
//  ChatStickerExampleViewController.h
//  VideoChat
//
//  Created by Lee on 05/01/2017.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import "ChatStickerViewController.h"

@class STSChatManager;
@class ChatViewController;

@interface ChatStickerExampleViewController : ChatStickerViewController

+ (instancetype)viewControllerWithChatViewController:(ChatViewController *)chatViewController;

@end
