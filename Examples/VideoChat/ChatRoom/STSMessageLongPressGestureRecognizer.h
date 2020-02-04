//
//  STSMessageLongPressGestureRecognizer.h
//  VideoChat
//
//  Created by shihwen.wang on 2017/6/21.
//  Copyright © 2020年 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StraaSMessagingSDK/StraaSMessagingSDK.h>

@interface STSMessageLongPressGestureRecognizer : UILongPressGestureRecognizer

@property (nonatomic, nullable) STSChatMessage * message;

@end
