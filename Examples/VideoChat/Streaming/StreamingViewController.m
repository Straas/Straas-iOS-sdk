//
//  StreamingViewController.m
//  VideoChat
//
//  Created by shihwen.wang on 2016/11/7.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import "StreamingViewController.h"

CGFloat const kSTSStreamingViewInputMinWidth = 180.0;
CGFloat const kSTSStreamingViewInputHeight = 30.0;
CGFloat const kSTSStreamingViewSubviewMargin = 10.0;

@interface StreamingViewController ()
@property (nonatomic) UIScrollView * scrollView;
@property (nonatomic) NSMutableArray<NSLayoutConstraint *> * allLayoutConstraints;
@property (nonatomic) NSArray<NSLayoutConstraint *> * scrollViewLayoutConstraints;
@end

@implementation StreamingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    [self addPreviewView];
    [self addScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateLayout];
}

#pragma mark - subviews

- (void)addPreviewView {
    if (!_previewView) {
        _previewView = [UIView new];
        _previewView.translatesAutoresizingMaskIntoConstraints = NO;
        _previewView.backgroundColor = [UIColor blackColor];
    }
    [self.view addSubview:_previewView];
    [self addCameraButton];
}

- (void)addCameraButton {
    if (!_previewView) {
        return;
    }
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
        _cameraButton.backgroundColor = [UIColor clearColor];
        [_cameraButton setImage:[UIImage imageNamed:@"camera"]
                       forState:UIControlStateNormal];
        [_cameraButton addTarget:self
                          action:@selector(cameraButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    [_previewView addSubview:_cameraButton];
}

- (void)addScrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:_scrollView];
    [self addTitleInput];
    [self addSynopsisInput];
    [self addStartButton];
    [self addStatusLabel];
}

- (void)addTitleInput {
    if (!_scrollView) {
        return;
    }
    if (!_titleInput) {
        NSString * placeholderStr = @"Title";
        UIFont * font = [UIFont systemFontOfSize:18];
        _titleInput = [UITextField new];
        _titleInput.translatesAutoresizingMaskIntoConstraints = NO;
        _titleInput.borderStyle = UITextBorderStyleNone;
        _titleInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        _titleInput.textColor = [UIColor whiteColor];
        _titleInput.font = font;
        _titleInput.attributedPlaceholder =
        [self attributeString:placeholderStr
          withForegroundColor:[UIColor lightGrayColor]
                         font:font];
    }
    [_scrollView addSubview:_titleInput];
}

- (void)addSynopsisInput {
    if (!_scrollView) {
        return;
    }
    if (!_synopsisInput) {
        NSString * placeholderStr = @"Synopsis";
        UIFont * font = [UIFont systemFontOfSize:18];
        _synopsisInput = [UITextField new];
        _synopsisInput.translatesAutoresizingMaskIntoConstraints = NO;
        _synopsisInput.borderStyle = UITextBorderStyleNone;
        _synopsisInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        _synopsisInput.textColor = [UIColor whiteColor];
        _synopsisInput.font = font;
        _synopsisInput.attributedPlaceholder =
        [self attributeString:placeholderStr
          withForegroundColor:[UIColor lightGrayColor]
                         font:font];
    }
    [_scrollView addSubview:_synopsisInput];
}

- (void)addStartButton {
    if (!_scrollView) {
        return;
    }
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.translatesAutoresizingMaskIntoConstraints = NO;
        _startButton.backgroundColor = [UIColor darkGrayColor];
        [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        [_startButton addTarget:self
                         action:@selector(startButtonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
        _startButton.hidden = YES;
    }
    [_scrollView addSubview:_startButton];
}

- (void)addStatusLabel {
    if (!_scrollView) {
        return;
    }
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _statusLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:18];
        _statusLabel.numberOfLines = 1;
        _statusLabel.text = @"Connecting...";
    }
    [_scrollView addSubview:_statusLabel];
}

#pragma mark - layout

- (void)updateLayout {
    if (self.allLayoutConstraints) {
        self.scrollViewLayoutConstraints = nil;
        [NSLayoutConstraint deactivateConstraints:self.allLayoutConstraints];
    }
    self.allLayoutConstraints = [NSMutableArray array];
    [self addPreviewViewLayoutConstraints];
    [self addCameraButtonLayoutConstraints];
    [self updateScrollViewLayoutConstraints];
    [self addTitleInputLayoutConstraints];
    [self addSynopsisInputLayoutConstraints];
    [self addStartButtonLayoutConstraints];
    [self addStatusLabelLayoutConstraints];
}

- (void)addPreviewViewLayoutConstraints {
    if (!self.previewView || ![self.previewView superview]) {
        return;
    }
    NSMutableArray * layoutConstraints = [NSMutableArray array];
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat size = MIN(width, height);
    NSDictionary * views = @{@"previewView": self.previewView};
    NSDictionary * metrics = @{@"size": @(size)};
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[previewView(size)]"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [layoutConstraints addObjectsFromArray:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[previewView(size)]"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [layoutConstraints addObjectsFromArray:constraints];
    [NSLayoutConstraint activateConstraints:layoutConstraints];
    [self.allLayoutConstraints addObjectsFromArray:layoutConstraints];
}

- (void)addCameraButtonLayoutConstraints {
    if (!self.cameraButton || ![self.cameraButton superview]) {
        return;
    }
    NSMutableArray * layoutConstraints = [NSMutableArray array];
    NSDictionary * views = @{@"cameraButton": self.cameraButton};
    NSDictionary * metrics = @{@"margin": @(kSTSStreamingViewSubviewMargin)};
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[cameraButton]"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [layoutConstraints addObjectsFromArray:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[cameraButton]"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [layoutConstraints addObjectsFromArray:constraints];
    [NSLayoutConstraint activateConstraints:layoutConstraints];
    [self.allLayoutConstraints addObjectsFromArray:layoutConstraints];
}

- (void)updateScrollViewLayoutConstraints {
    if (self.scrollViewLayoutConstraints) {
        [self.allLayoutConstraints removeObjectsInArray:self.scrollViewLayoutConstraints];
        [NSLayoutConstraint deactivateConstraints:self.scrollViewLayoutConstraints];
        self.scrollViewLayoutConstraints = nil;
    }
    if (!self.scrollView || ![self.scrollView superview]) {
        return;
    }
    NSMutableArray * layoutConstraints = [NSMutableArray array];
    NSDictionary * views = @{@"scrollView": self.scrollView};
    if ([self isWidthBiggerThanHeight]) {
        CGFloat width = [self inputWidth] + kSTSStreamingViewSubviewMargin;
        NSDictionary * metrics = @{@"width": @(width)};
        NSArray * constraints;
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[scrollView(width)]-(0)-|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
        [layoutConstraints addObjectsFromArray:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[scrollView]-(0)-|"
                                                              options:0
                                                              metrics:nil
                                                                views:views];
        [layoutConstraints addObjectsFromArray:constraints];
    } else {
        CGFloat height = CGRectGetHeight(self.view.frame)-CGRectGetWidth(self.view.frame);
        height = MAX(height, 130);
        NSDictionary * metrics = @{@"height": @(height)};
        NSArray * constraints;
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[scrollView]-(0)-|"
                                                              options:0
                                                              metrics:nil
                                                                views:views];
        [layoutConstraints addObjectsFromArray:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[scrollView(height)]-(0)-|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
        [layoutConstraints addObjectsFromArray:constraints];
    }
    [NSLayoutConstraint activateConstraints:layoutConstraints];
    [self.allLayoutConstraints addObjectsFromArray:layoutConstraints];
    self.scrollViewLayoutConstraints = layoutConstraints;
}

- (void)addTitleInputLayoutConstraints {
    if (!self.titleInput || ![self.titleInput superview]) {
        return;
    }
    NSMutableArray * layoutConstraints = [NSMutableArray array];
    CGFloat width = [self inputWidth];
    NSDictionary * metrics = @{@"width": @(width),
                               @"height": @(kSTSStreamingViewInputHeight),
                               @"margin": @(kSTSStreamingViewSubviewMargin)};
    NSDictionary * views = @{@"titleInput": self.titleInput};
    NSArray * constraints;
    if ([self isWidthBiggerThanHeight]) {
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[titleInput(width)]-(margin)-|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
    } else {
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[titleInput(width)]-(margin)-|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
    }
    [layoutConstraints addObjectsFromArray:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[titleInput(height)]"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [layoutConstraints addObjectsFromArray:constraints];
    [NSLayoutConstraint activateConstraints:layoutConstraints];
    [self.allLayoutConstraints addObjectsFromArray:layoutConstraints];
}

- (void)addSynopsisInputLayoutConstraints {
    if (!self.synopsisInput || ![self.synopsisInput superview] || !self.titleInput) {
        return;
    }
    NSMutableArray * layoutConstraints = [NSMutableArray array];
    CGFloat width = [self inputWidth];
    NSDictionary * metrics = @{@"width": @(width),
                               @"height": @(kSTSStreamingViewInputHeight),
                               @"margin": @(kSTSStreamingViewSubviewMargin)};
    NSDictionary * views = @{@"synopsisInput": self.synopsisInput,
                             @"titleInput": self.titleInput};
    NSArray * constraints;
    if ([self isWidthBiggerThanHeight]) {
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[synopsisInput(width)]-(margin)-|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
    } else {
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[synopsisInput(width)]-(margin)-|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
    }
    [layoutConstraints addObjectsFromArray:constraints];
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleInput]-(margin)-[synopsisInput(height)]"
                                            options:0
                                            metrics:metrics
                                              views:views];
    [layoutConstraints addObjectsFromArray:constraints];
    [NSLayoutConstraint activateConstraints:layoutConstraints];
    [self.allLayoutConstraints addObjectsFromArray:layoutConstraints];
}

- (void)addStartButtonLayoutConstraints {
    if (!self.startButton || ![self.startButton superview] || !self.synopsisInput) {
        return;
    }
    NSMutableArray * layoutConstraints = [NSMutableArray array];
    CGFloat width = [self inputWidth];
    NSDictionary * metrics = @{@"width": @(width),
                               @"height": @(kSTSStreamingViewInputHeight),
                               @"margin": @(kSTSStreamingViewSubviewMargin)};
    NSDictionary * views = @{@"startButton": self.startButton,
                             @"synopsisInput": self.synopsisInput};
    NSArray * constraints;
    if ([self isWidthBiggerThanHeight]) {
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[startButton(width)]-(margin)-|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
    } else {
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[startButton(width)]-(margin)-|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
    }
    [layoutConstraints addObjectsFromArray:constraints];
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[synopsisInput]-(margin)-[startButton(height)]"
                                            options:0
                                            metrics:metrics
                                              views:views];
    [layoutConstraints addObjectsFromArray:constraints];
    [NSLayoutConstraint activateConstraints:layoutConstraints];
    [self.allLayoutConstraints addObjectsFromArray:layoutConstraints];
}

- (void)addStatusLabelLayoutConstraints {
    if (!self.statusLabel || ![self.statusLabel superview] || !self.startButton) {
        return;
    }
    NSMutableArray * layoutConstraints = [NSMutableArray array];
    NSDictionary * views = @{@"statusLabel": self.statusLabel};
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[statusLabel]-(0)-|"
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [layoutConstraints addObjectsFromArray:constraints];

    NSLayoutConstraint * constraint;
    constraint =
    [NSLayoutConstraint constraintWithItem:self.statusLabel
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.startButton
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1
                                  constant:0];
    [layoutConstraints addObject:constraint];
    constraint =
    [NSLayoutConstraint constraintWithItem:self.statusLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.startButton
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    [layoutConstraints addObject:constraint];
    [NSLayoutConstraint activateConstraints:layoutConstraints];
    [self.allLayoutConstraints addObjectsFromArray:layoutConstraints];
}

#pragma mark - utility

- (BOOL)isWidthBiggerThanHeight {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    return (width > height);
}

- (CGFloat)inputWidth {
    CGFloat width;
    if ([self isWidthBiggerThanHeight]) {
        width = CGRectGetWidth(self.view.frame) - CGRectGetHeight(self.view.frame);
        width = MAX(width, kSTSStreamingViewInputMinWidth);
    } else {
        width = CGRectGetWidth(self.view.frame) - 2 * kSTSStreamingViewSubviewMargin;
    }

    return width;
}

- (NSMutableAttributedString *)attributeString:(NSString *)string
                           withForegroundColor:(UIColor *)color
                                          font:(UIFont *)font
{
    NSMutableAttributedString * attributedString =
    [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:color
                             range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:NSMakeRange(0, string.length)];
    return attributedString;
}

#pragma mark - button actions

- (void)startButtonPressed:(UIButton *)sender {
}

- (void)cameraButtonPressed:(UIButton *)sender {
}

@end
