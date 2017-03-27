//
//  MessageTableViewCell.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 9/1/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconLabel.h"

static CGFloat kMessageTableViewCellAvatarHeight = 40.0;

static NSString *MessengerCellIdentifier = @"MessengerCell";
static NSString *StickerCellIdentifier = @"StickerCell";
static NSString *AutoCompletionCellIdentifier = @"AutoCompletionCell";


@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) IconLabel *titleLabel;
@property (nonatomic, strong) UILabel *sideLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UIImageView * stickerImageView;
@property (nonatomic, strong) UIView *separatorLineView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic) BOOL usedForMessage;

+ (CGFloat)defaultFontSize;

@end
