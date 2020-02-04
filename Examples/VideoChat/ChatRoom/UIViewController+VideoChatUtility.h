//
//  UIViewController+VideoChatUtility.h
//  VideoChat
//
//  Created by shihwen.wang on 2017/6/23.
//  Copyright © 2020年 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIViewController(VideoChatUtility)
- (void)showMessage:(NSString *)message dismissAfter:(NSTimeInterval)delay;
@end

NS_ASSUME_NONNULL_END
