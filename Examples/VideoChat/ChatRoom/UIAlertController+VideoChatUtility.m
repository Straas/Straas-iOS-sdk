//
//  UIAlertController+VideoChatUtility.m
//  VideoChat
//
//  Created by Lee on 9/8/16.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import "UIAlertController+VideoChatUtility.h"

@implementation UIAlertController (VideoChatUtility)

+ (UIAlertController *)nicknameAlertControllerWithCurrentNickname:(NSString *)nickname
                                              cancelActionHandler:(void (^)(UIAlertAction *))cancelActionHandler
                                             confirmActionHandler:(void (^)(UIAlertAction *, NSString *))confirmActionHandler {
    NSString *title = NSLocalizedString(@"chatroom input nickname", nil);
    NSString *confirm = NSLocalizedString(@"confirm", nil);
    NSString *cancel = NSLocalizedString(@"cancel", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancel
                                                            style:UIAlertActionStyleCancel
                                                          handler:cancelActionHandler];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:confirm
                                                             style:UIAlertActionStyleDefault
                                                           handler:
                                     ^(UIAlertAction *action) {
                                         UITextField * textField = alertController.textFields.firstObject;
                                         confirmActionHandler(action, [textField text]);
                                     }];
    confirmAction.enabled = NO;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:NSOperationQueuePriorityNormal usingBlock:^(NSNotification * _Nonnull note) {
            confirmAction.enabled = ![textField.text isEqualToString:@""] &&
                                    ![textField.text isEqualToString:nickname];
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    return alertController;
}

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message confirmActionHandler:(void (^)(UIAlertAction *))confirmActionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSString *confirm = NSLocalizedString(@"confirm", nil);
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:confirmActionHandler];
    [alertController addAction:confirmAction];
    return alertController;
}

@end
