//
//  ChatStickerViewController.h
//  VideoChat
//
//  Created by Lee on 04/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StraaSMessagingSDK/STSChatroomConnectionOptions.h>

@interface ChatStickerViewController : UIViewController

@property (nonatomic) NSString * JWT;
@property (nonatomic) NSString * chatroomName;
@property (nonatomic) STSChatroomConnectionOptions connectionOptions;

@end
