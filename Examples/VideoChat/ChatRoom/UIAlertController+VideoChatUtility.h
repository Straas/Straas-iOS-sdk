//
//  UIAlertController+VideoChatUtility.h
//  VideoChat
//
//  Created by Lee on 9/8/16.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (VideoChatUtility)

+ (UIAlertController *)nicknameAlertControllerWithCurrentNickname:(NSString *)nickname
                                              cancelActionHandler:(void (^)(UIAlertAction *))cancelActionHandler
                                             confirmActionHandler:(void (^)(UIAlertAction *, NSString *))confirmActionHandler;

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title
                                        message:(NSString *)message
                           confirmActionHandler:(void (^)(UIAlertAction *))confirmActionHandler;

+ (UIAlertController *)messageAlertControllerWithTitle:(NSString *)title
                                               message:(NSString *)message
                                      pinActionHandler:(void (^)(UIAlertAction *))pinActionHandler
                                   deleteActionHandler:(void (^)(UIAlertAction *))deleteActionHandler
                                    unpinActionHandler:(void (^)(UIAlertAction *))pinActionHandler
                                   cancelActionHandler:(void (^)(UIAlertAction *))cancelActionHandler;

@end
