//
//  STSPinnedMessageView.h
//  VideoChat
//
//  Created by shihwen.wang on 2017/6/21.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconLabel.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSPinnedMessageView : UIView

@property (nonatomic, strong, readonly) IconLabel * titleLabel;
@property (nonatomic, strong, readonly) TTTAttributedLabel * bodyLabel;
@property (nonatomic, strong, readonly) UIImageView * avatarView;
@property (nonatomic, strong, readonly) UIButton * pinButton;

@end

NS_ASSUME_NONNULL_END
