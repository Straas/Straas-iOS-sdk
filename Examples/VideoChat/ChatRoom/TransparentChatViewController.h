//
//  TransparentChatViewController.h
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"

static NSString *TransparentMessengerCellIdentifier = @"TransparentMessengerCell";

@interface TransparentChatViewController : ChatViewController

+ (CGFloat)cellLeftPadding;

@end
