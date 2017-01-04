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

- (instancetype)initWithJWT:(NSString *)JWT
               chatroomName:(NSString *)chatroomName
          connectionOptions:(STSChatroomConnectionOptions)connectionOptions;

+ (instancetype)new __attribute__((unavailable("Use chatStickerViewControllerWithJWT:chatroomName:connectionOptions: instead.")));
- (instancetype)init  __attribute__((unavailable("Use initWithJWT:chatroomName:connectionOptions: instead.")));

@end
