//
//  STSPinnedMessageView.m
//  VideoChat
//
//  Created by shihwen.wang on 2017/6/21.
//  Copyright © 2020年 StraaS.io. All rights reserved.
//

#import "STSPinnedMessageView.h"
#import <SlackTextViewController/SLKUIConstants.h>

static const CGFloat kSTSPinnedMessageViewAvatarSize = 40.0;
static const CGFloat kSTSPinnedMessageViewBodyMinHeight = 20;
static const CGFloat kSTSPinnedMessageViewBodyMaxHeight = 999;
static const CGFloat kSTSPinnedMessageViewMarginBottom = 10;
static const CGFloat kSTSPinnedMessageViewMarginLeft = 15;
static const CGFloat kSTSPinnedMessageViewMarginTop = 10;
static const CGFloat kSTSPinnedMessageViewPinButtonSize = 44;
static const CGFloat kSTSPinnedMessageViewTitleHeight = 20;
static const CGFloat kSTSPinnedMessageViewAvatarMarginRight = 10;
static const CGFloat kSTSPinnedMessageViewPinButtonMarginLeft = 5;

@interface STSPinnedMessageView()
@property (nonatomic, strong) IconLabel * titleLabel;
@property (nonatomic, strong) TTTAttributedLabel * bodyLabel;
@property (nonatomic, strong) UIImageView * avatarView;
@property (nonatomic, strong) UIButton * pinButton;
@end

@implementation STSPinnedMessageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self commonInit];
}

- (void)commonInit
{
    self.backgroundColor = [UIColor colorWithWhite:244./255. alpha:1];
    [self addDefaultSubviews];
}

- (void)addDefaultSubviews {
    [self addSubview:self.avatarView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.bodyLabel];
    [self addSubview:self.pinButton];

    NSDictionary * views = @{@"avatarView": self.avatarView,
                             @"titleLabel": self.titleLabel,
                             @"bodyLabel": self.bodyLabel,
                             @"pinButton": self.pinButton};

    NSDictionary *metrics = @{@"avatarSize": @(kSTSPinnedMessageViewAvatarSize),
                              @"bodyMinHeight": @(kSTSPinnedMessageViewBodyMinHeight),
                              @"bodyMaxHeight": @(kSTSPinnedMessageViewBodyMaxHeight),
                              @"pinButtonSize": @(kSTSPinnedMessageViewPinButtonSize),
                              @"titleHeight": @(kSTSPinnedMessageViewTitleHeight),
                              @"leftMargin": @(kSTSPinnedMessageViewMarginLeft),
                              @"topMargin": @(kSTSPinnedMessageViewMarginTop),
                              @"bottomMargin": @(kSTSPinnedMessageViewMarginBottom),
                              @"avatarRightMargin": @(kSTSPinnedMessageViewAvatarMarginRight),
                              @"leftMargin": @(kSTSPinnedMessageViewPinButtonMarginLeft)};

    NSString * visualFormat =
    @"H:|-(leftMargin)-[avatarView(avatarSize)]-(avatarRightMargin)-[titleLabel]-(leftMargin)-[pinButton(pinButtonSize)]-0-|";
    NSArray * constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
    [NSLayoutConstraint activateConstraints:constraints];

    visualFormat =
    @"H:|-(leftMargin)-[avatarView(avatarSize)]-(avatarRightMargin)-[bodyLabel]-(leftMargin)-[pinButton(pinButtonSize)]-0-|";
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
    [NSLayoutConstraint activateConstraints:constraints];

    visualFormat = @"V:|-(topMargin)-[avatarView(avatarSize)]-(>=bottomMargin)-|";
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
    [NSLayoutConstraint activateConstraints:constraints];

    visualFormat = @"V:|-(topMargin)-[titleLabel(titleHeight)]-(0)-[bodyLabel(>=bodyMinHeight@bodyMaxHeight)]-(bottomMargin)-|";
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
    [NSLayoutConstraint activateConstraints:constraints];

    visualFormat = @"V:|-0-[pinButton(pinButtonSize)]";
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (IconLabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [IconLabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.87];
        _titleLabel.font = [UIFont boldSystemFontOfSize:[STSPinnedMessageView defaultFontSize]];
    }
    return _titleLabel;
}

- (TTTAttributedLabel *)bodyLabel
{
    if (!_bodyLabel) {
        _bodyLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _bodyLabel.backgroundColor = [UIColor clearColor];
        _bodyLabel.userInteractionEnabled = YES;
        _bodyLabel.numberOfLines = 2;
        _bodyLabel.textColor = [UIColor colorWithWhite:0 alpha:0.54];
        _bodyLabel.font = [UIFont systemFontOfSize:[STSPinnedMessageView defaultFontSize]];

        _bodyLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        _bodyLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        UIColor *lightBlue = [UIColor colorWithRed:80./255. green:154/255. blue:255./255. alpha:1.0];
        _bodyLabel.linkAttributes =
        @{ (id)kCTForegroundColorAttributeName: lightBlue,
           (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleSingle]};
        CGColorRef lightGreyRef = [[UIColor colorWithWhite:204./255. alpha:1.0] CGColor];
        _bodyLabel.activeLinkAttributes =
        @{ (id)kCTForegroundColorAttributeName: lightBlue,
           (id)kTTTBackgroundFillColorAttributeName: (__bridge id)lightGreyRef,
           (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleSingle]};
    }
    return _bodyLabel;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        _avatarView.userInteractionEnabled = NO;
        _avatarView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _avatarView.layer.cornerRadius = kSTSPinnedMessageViewAvatarSize/2.0;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.image = [UIImage imageNamed:@"img-guest-photo"];
    }
    return _avatarView;
}

- (UIButton *)pinButton
{
    if (!_pinButton) {
        _pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pinButton.translatesAutoresizingMaskIntoConstraints = NO;
        _pinButton.backgroundColor = [UIColor clearColor];
        UIImage * image = [UIImage imageNamed:@"ic_pin_message"];
        [_pinButton setImage:image forState:UIControlStateNormal];
    }
    return _pinButton;
}

+ (CGFloat)defaultFontSize
{
    CGFloat pointSize = 14.0;
    NSString * contentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
    pointSize += SLKPointSizeDifferenceForCategory(contentSizeCategory);
    return pointSize;
}

@end
