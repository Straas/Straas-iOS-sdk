//
//  UIViewController+VideoChatUtility.m
//  VideoChat
//
//  Created by shihwen.wang on 2017/6/23.
//  Copyright © 2020年 StraaS.io. All rights reserved.
//

#import "UIViewController+VideoChatUtility.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@implementation UIViewController(VideoChatUtility)

- (void)showMessage:(NSString *)message dismissAfter:(NSTimeInterval)delay
{
    if (!self.view || ([message length] == 0)) {
        return;
    }
    TTTAttributedLabel * label = [self labelWithText:message];
    label.alpha = 0;
    [self.view addSubview:label];
    NSDictionary * views = @{@"label": label};
    NSString * visualFormat = @"H:|-(>=20)-[label]-(>=20)-|";
    NSArray * constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];

    visualFormat = @"V:|-(>=30)-[label]-(30)-|";
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];

    NSLayoutConstraint * constraint =
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];
    [NSLayoutConstraint activateConstraints:@[constraint]];
    [UIView animateWithDuration:0.3 animations:^{
        label.alpha = 1;
    }];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}

- (TTTAttributedLabel *)labelWithText:(NSString *)text {
    TTTAttributedLabel * label = [TTTAttributedLabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    return label;
}

@end
