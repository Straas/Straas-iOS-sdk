//
//  UIAlertController+VideoChatUtility.m
//  VideoChat
//
//  Created by Lee on 9/8/16.
//  Copyright © 2020 StraaS.io. All rights reserved.
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

+ (UIAlertController *)messageAlertControllerWithTitle:(NSString *)title
                                               message:(NSString *)message
                                      pinActionHandler:(void (^)(UIAlertAction *))pinActionHandler
                                   deleteActionHandler:(void (^)(UIAlertAction *))deleteActionHandler
                                    unpinActionHandler:(void (^)(UIAlertAction *))unpinActionHandler
                                   cancelActionHandler:(void (^)(UIAlertAction *))cancelActionHandler
{
    UIAlertController * alertController =
    [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    NSString * actionTitle;
    UIAlertAction * action;
    if (pinActionHandler) {
        actionTitle = NSLocalizedString(@"pin_message_to_top", nil);
        action =
        [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:pinActionHandler];
        [alertController addAction:action];
    }
    if (deleteActionHandler) {
        actionTitle = NSLocalizedString(@"deleate_message", nil);
        action =
        [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:deleteActionHandler];
        [alertController addAction:action];
    }
    if (unpinActionHandler) {
        actionTitle = NSLocalizedString(@"unping_message", nil);
        action =
        [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:unpinActionHandler];
        [alertController addAction:action];
    }
    actionTitle = NSLocalizedString(@"cancel", nil);
    [alertController addAction:
     [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:cancelActionHandler]];
    return alertController;
}

@end
