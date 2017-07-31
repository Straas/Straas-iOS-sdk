//
//  TransparentMessageTableViewCell.h
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StraaSMessagingSDK/STSChatMessage.h>
#import <StraaSMessagingSDK/STSChatUser.h>

extern CGFloat const kTransparentCellLabelPaddingLeft;
extern CGFloat const kTransparentCellLabelPaddingRight;
extern CGFloat const kTransparentCellLabelPaddingTop;
extern CGFloat const kTransparentCellLabelPaddingBottom;

extern CGFloat const kTransparentCellBackgroundMaskHorizontalPadding;
extern CGFloat const kTransparentCellBackgroundMaskVerticalPadding;

@interface TransparentMessageTableViewCell : UITableViewCell

+ (CGFloat)estimateCellHeightWithMessage:(STSChatMessage *)message widthToFit:(CGFloat)width;

- (void)setMessage:(STSChatMessage *)message;

@end
