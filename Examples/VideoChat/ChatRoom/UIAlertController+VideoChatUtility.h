//
//  UIAlertController+VideoChatUtility.h
//  VideoChat
//
//  Created by Lee on 9/8/16.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (VideoChatUtility)

+ (UIAlertController *)nicknameAlertControllerWithCurrentNickname:(NSString *)nickname
                                              cancelActionHandler:(void (^)(UIAlertAction *))cancelActionHandler
                                             confirmActionHandler:(void (^)(UIAlertAction *, NSString *))confirmActionHandler;

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title
                                        message:(NSString *)message
                           confirmActionHandler:(void (^)(UIAlertAction *))confirmActionHandler;

@end
