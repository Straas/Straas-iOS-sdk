//
//  ChatStickerViewController.h
//  VideoChat
//
//  Created by Lee on 04/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StraaSMessagingSDK/STSChatroomConnectionOptions.h>

@class ChatViewController;

@interface ChatStickerViewController : UIViewController

@property (nonatomic, readonly) ChatViewController * chatVC;
+ (instancetype)chatStickerViewControllerWithJWT:(NSString *)JWT
                                    chatroomName:(NSString *)chatroomName
                               connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

@end
