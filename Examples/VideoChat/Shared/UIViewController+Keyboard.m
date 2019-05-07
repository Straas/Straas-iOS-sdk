//
//  UIViewController+Keyboard.m
//  LiveHouse
//
//  Created by Luke Jang on 12/9/14.
//  Copyright © 2019年 StraaS.io. All rights reserved.
//

#import "UIViewController+Keyboard.h"

@implementation UIViewController (Keyboard)

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillBeShown:(NSNotification*)notification
{
    [self updateLayoutWithKeyboard:YES notification:notification];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [self updateLayoutWithKeyboard:NO notification:notification];
}

- (void)updateLayoutWithKeyboard:(BOOL)keyboard notification:(NSNotification *)notification
{
    NSAssert(NO, @"Please override this method");
}

@end
