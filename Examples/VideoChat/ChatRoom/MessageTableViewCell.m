//
//  MessageTableViewCell.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 9/1/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "MessageTableViewCell.h"
#import <SlackTextViewController/SLKUIConstants.h>

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];

        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews
{
    [self.contentView addSubview:self.thumbnailView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.sideLabel];
    [self.contentView addSubview:self.separatorLineView];

    NSMutableDictionary *views = [@{@"thumbnailView": self.thumbnailView,
                                    @"titleLabel": self.titleLabel,
                                    @"sideLabel": self.sideLabel,
                                    @"lineView": self.separatorLineView,
                                    } mutableCopy];

    NSDictionary *metrics = @{@"tumbSize": @(kMessageTableViewCellAvatarHeight),
                              @"padding": @15,
                              @"right": @10,
                              @"left": @5
                              };

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[thumbnailView(tumbSize)]-right-[titleLabel(>=0)]-padding-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-right-[thumbnailView(tumbSize)]-(>=0)-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(1)]-0-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[thumbnailView(tumbSize)]-right-[lineView(>=0)]-padding-|" options:0 metrics:metrics views:views]];

    if ([self.reuseIdentifier isEqualToString:MessengerCellIdentifier]) {
        [self.contentView addSubview:self.bodyLabel];
        [views addEntriesFromDictionary:@{@"bodyLabel": self.bodyLabel}];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-right-[titleLabel(20)]-left-[bodyLabel(>=0@999)]-right-|" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sideLabel(36)]-padding-|" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(12)-[sideLabel(16)]" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[thumbnailView(tumbSize)]-right-[bodyLabel(>=0)]-padding-|" options:0 metrics:metrics views:views]];
    }
    else if ([self.reuseIdentifier isEqualToString:StickerCellIdentifier]) {
        [self.contentView addSubview:self.stickerImageView];
        [views addEntriesFromDictionary:@{@"stickerView":self.stickerImageView}];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-right-[titleLabel(20)]-left-[stickerView(70)]-right-|" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sideLabel(36)]-padding-|" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(12)-[sideLabel(16)]" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[thumbnailView(tumbSize)]-right-[stickerView(70)]" options:0 metrics:metrics views:views]];
    }
    else {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:0 metrics:metrics views:views]];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    CGFloat pointSize = [MessageTableViewCell defaultFontSize];

    self.titleLabel.font = [UIFont boldSystemFontOfSize:pointSize];
    self.sideLabel.font = [UIFont systemFontOfSize:12.0];
    self.bodyLabel.font = [UIFont systemFontOfSize:pointSize];

    self.titleLabel.text = @"";
    self.sideLabel.text = @"";
    self.bodyLabel.text = @"";

}

#pragma mark - Getters

- (IconLabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [IconLabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.87];
        _titleLabel.font = [UIFont boldSystemFontOfSize:[MessageTableViewCell defaultFontSize]];
    }
    return _titleLabel;
}

- (UILabel *)sideLabel
{
    if (!_sideLabel) {
        _sideLabel = [UILabel new];
        _sideLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _sideLabel.backgroundColor = [UIColor clearColor];
        _sideLabel.userInteractionEnabled = NO;
        _sideLabel.numberOfLines = 0;
        _sideLabel.textColor = [UIColor colorWithWhite:0 alpha:0.54];
        _sideLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _sideLabel.textAlignment = NSTextAlignmentRight;
    }
    return _sideLabel;
}

- (UILabel *)bodyLabel
{
    if (!_bodyLabel) {
        _bodyLabel = [UILabel new];
        _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _bodyLabel.backgroundColor = [UIColor clearColor];
        _bodyLabel.userInteractionEnabled = NO;
        _bodyLabel.numberOfLines = 0;
        _bodyLabel.textColor = [UIColor colorWithWhite:0 alpha:0.54];
        _bodyLabel.font = [UIFont systemFontOfSize:[MessageTableViewCell defaultFontSize]];
    }
    return _bodyLabel;
}

- (UIImageView *)thumbnailView
{
    if (!_thumbnailView) {
        _thumbnailView = [UIImageView new];
        _thumbnailView.translatesAutoresizingMaskIntoConstraints = NO;
        _thumbnailView.userInteractionEnabled = NO;
        _thumbnailView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];

        _thumbnailView.layer.cornerRadius = kMessageTableViewCellAvatarHeight/2.0;
        _thumbnailView.layer.masksToBounds = YES;
    }
    return _thumbnailView;
}

- (UIImageView *)stickerImageView {
    if (!_stickerImageView) {
        _stickerImageView = [UIImageView new];
        _stickerImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _stickerImageView.userInteractionEnabled = NO;
    }
    return _stickerImageView;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [UIView new];
        _separatorLineView.translatesAutoresizingMaskIntoConstraints = NO;
        _separatorLineView.userInteractionEnabled = NO;
        CGFloat value = 111.0/256.0;
        _separatorLineView.backgroundColor = [UIColor colorWithRed:value green:value blue:value alpha:0.12];
    }
    return _separatorLineView;
}

+ (CGFloat)defaultFontSize
{
    CGFloat pointSize = 14.0;

    NSString *contentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
    pointSize += SLKPointSizeDifferenceForCategory(contentSizeCategory);

    return pointSize;
}

+ (CGFloat)estimateBodyLabelWidth {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = bounds.size.width;
    return screenWidth - 80.0;
}

@end
