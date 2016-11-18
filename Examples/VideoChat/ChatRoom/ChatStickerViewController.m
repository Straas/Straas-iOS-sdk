//
//  ChatStickerViewController.m
//  VideoChat
//
//  Created by Lee on 04/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import "ChatStickerViewController.h"
#import "ChatViewController.h"
#import "StickersInputView.h"

@interface ChatStickerViewController ()<ChatStickerDelegate>
@property (nonatomic) StickersInputView * stickerView;
@property (nonatomic, getter=isStickerViewShowing) BOOL stickerViewShowing;
@property (nonatomic) NSLayoutConstraint * stickerHeightConstraint;
@property (nonatomic) ChatViewController * chatVC;
@end

@implementation ChatStickerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addChildViewController:self.chatVC];
    [self.view addSubview:self.chatVC.view];
    [self.view addSubview:self.stickerView];
    self.chatVC.delegate = self;
    self.stickerView.delegate = self.chatVC;
    NSDictionary * views = @{@"chatVC": self.chatVC.view,
    @"stickerView": self.stickerView};
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chatVC]-0-|" options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[stickerView]-0-|" options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chatVC]-0-[stickerView]-0-|" options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];
    [self setStickerViewHeight:0.0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)chatStickerDidLoad:(NSArray *)stickers {
    [self.stickerView setStickers:stickers];
}

- (void)showStickerView:(BOOL)animated {
    self.stickerViewShowing = YES;
    [self setStickerViewHeight:215];
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        [self.view layoutIfNeeded];
    }
}

- (void)dismissStickerView:(BOOL)animated {
    self.stickerViewShowing = NO;
    [self setStickerViewHeight:0];
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        [self.view layoutIfNeeded];
    }
}

- (void)setStickerViewHeight:(CGFloat)height {
    if (self.stickerHeightConstraint) {
        [NSLayoutConstraint deactivateConstraints:@[self.stickerHeightConstraint]];
    }
    self.stickerHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.stickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:height];
    [NSLayoutConstraint activateConstraints:@[self.stickerHeightConstraint]];
}

#pragma mark - accessor.

- (StickersInputView *)stickerView {
    if (!_stickerView) {
        _stickerView = [[[NSBundle mainBundle] loadNibNamed:kStickersInputView owner:self options:nil] objectAtIndex:0];
        _stickerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stickerView;
}

- (ChatViewController *)chatVC {
    if (!_chatVC) {
        _chatVC = [ChatViewController new];
        _chatVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _chatVC;
}

@end
