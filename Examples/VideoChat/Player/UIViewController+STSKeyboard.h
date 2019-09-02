//
//  UIViewController+STSKeyboard.h
//  StraaS
//
//  Created by Jerome Lee on 13/6/16.
//  Copyright (c) 2017 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (STSKeyboard)

- (void)registerForKeyboardNotifications;
- (void)sts_unregisterForKeyboardNotifications;
- (void)sts_keyboardWillBeShown:(NSNotification*)notification;
- (void)sts_keyboardWillBeHidden:(NSNotification*)notification;
- (void)sts_updateLayoutWithKeyboard:(BOOL)keyboard notification:(NSNotification *)notification;

@end
