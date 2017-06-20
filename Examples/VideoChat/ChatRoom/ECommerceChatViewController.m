//
//  ECommerceChatViewController.m
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "ECommerceChatViewController.h"
#import <SlackTextViewController/SLKTextViewController.h>
#import <StraaSCoreSDK/StraaSCoreSDK.h>
#import "FloatingImageView.h"

@interface ECommerceChatViewController ()<DataChannelEventDelegate>

@property (nonatomic) TransparentChatViewController *chatVC;
@property (nonatomic) NSString * chatroomName;
@property (nonatomic) STSChatroomConnectionOptions options;
@property (nonatomic) UIView * toolbarView;
@property (nonatomic) UIButton * showKeyboardButton;
@property (nonatomic) UIButton * likeButton;
@property (nonatomic) UILabel * likeCountLabel;
@property (nonatomic) UIView * backgroundView;
@property (nonatomic) NSDictionary<NSString *, UIImage *> * emojis;
@property (nonatomic) STSChatManager * manager;
@property (nonatomic) NSMutableDictionary * cachedUserTapCount;

@end

@implementation ECommerceChatViewController

- (instancetype)init {
    self = [super init];
    if(self) {
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
    _chatVC = [TransparentChatViewController new];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // For demo purpose, we use a still image to represent a live streaming video.
    [self addStreamingCanvas];

    // Add a transparent chat view to display messages.
    [self addTransparentChatView];

    // Add toolbar
    [self addToolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addObserver:self forKeyPath:@"chatVC.textViewEditable" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserver:self forKeyPath:@"chatVC.textViewEditable" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Notifications

- (void)willShowKeyboard:(NSNotification *)notification {
    NSArray *constraints = self.view.constraints;
    for (NSLayoutConstraint *constraint in constraints) {
        if (constraint.firstItem == self.chatVC.view &&
            constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = CGRectGetHeight(self.chatVC.view.superview.bounds);
            break;
        }
    }
}

- (void)willHideKeyboard:(NSNotification *)notification {
    NSArray *constraints = self.view.constraints;
    for (NSLayoutConstraint *constraint in constraints) {
        if (constraint.firstItem == self.chatVC.view &&
            constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = 0;
            break;
        }
    }
}

#pragma mark - Public Methods

- (void)addStreamingCanvas {
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_chatroom_background"]];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.contentMode = UIViewContentModeScaleToFill;
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];

    // Setup atuo layout
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"view" : view}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"view" : view}]];
    [NSLayoutConstraint activateConstraints:constraints];
    _backgroundView = view;
}

#pragma mark - Private Methods

- (void)addTransparentChatView {
    [self addChildViewController:self.chatVC];
    [self.view addSubview:self.chatVC.view];
    [self.chatVC didMoveToParentViewController:self];
    self.chatVC.dataChannelDelegate = self;
    // Setup auto layout
    self.chatVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chatVC]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"chatVC":self.chatVC.view}]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.chatVC.view
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.chatVC.view.superview
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:0.3
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)addToolbar {
    [self.view addSubview:self.toolbarView];
    
    [self.toolbarView addSubview:self.showKeyboardButton];
    [self.toolbarView addSubview:self.likeButton];
    [self.toolbarView addSubview:self.likeCountLabel];
    
    // Setup auto layout
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary * views = @{@"toolbarView":self.toolbarView,
                             @"chatVC":self.chatVC.view,
                             @"showKeyboardButton":self.showKeyboardButton,
                             @"likeButton":self.likeButton,
                             @"likeCountLabel": self.likeCountLabel};
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[toolbarView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatVC]-0-[toolbarView(60)]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[showKeyboardButton(50)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[showKeyboardButton(50)]-5-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[likeButton(40)]-10-|"
                                                                             options:0 metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[likeButton(40)]-10-|"
                                                                             options:0 metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[likeCountLabel(35)]-12.5-|"
                                                                             options:0 metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[likeCountLabel(16)]"
                                                                             options:0 metrics:nil
                                                                               views:views]];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Accessor

- (UIView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [UIView new];
        [_toolbarView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        _toolbarView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _toolbarView;
}

- (UIButton *)showKeyboardButton {
    if (!_showKeyboardButton) {
        _showKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showKeyboardButton setImage:[UIImage imageNamed:@"btn_msg_typing"] forState:UIControlStateNormal];
        [_showKeyboardButton addTarget:self action:@selector(onShowKeyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _showKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _showKeyboardButton;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"btn_emoji"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(didTapLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        _likeButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _likeButton;
}

- (UILabel *)likeCountLabel {
    if (!_likeCountLabel) {
        _likeCountLabel = [UILabel new];
        _likeCountLabel.font = [UIFont systemFontOfSize:11.0];
        _likeCountLabel.textColor = [UIColor colorWithRed:39./255. green:172./255. blue:174./255. alpha:1];
        _likeCountLabel.backgroundColor = [UIColor whiteColor];
        _likeCountLabel.numberOfLines = 1;
        _likeCountLabel.textAlignment = NSTextAlignmentCenter;
        _likeCountLabel.layer.cornerRadius = 8;
        _likeCountLabel.layer.masksToBounds = YES;
        _likeCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _likeCountLabel;
}

- (NSDictionary *)emojis {
    if (!_emojis) {
        _emojis = @{@"heart": [UIImage imageNamed:@"emoji_heart"],
                    @"like": [UIImage imageNamed:@"emoji_like"],
                    @"emoji": [UIImage imageNamed:@"emoji_XD"]};
    }
    return _emojis;
}

- (NSMutableDictionary *)cachedUserTapCount {
    if (!_cachedUserTapCount) {
        _cachedUserTapCount = [NSMutableDictionary dictionary];
    }
    return _cachedUserTapCount;
}

- (STSChat *)currentChat {
    return self.chatVC.currentChat;
}

- (STSChatManager *)manager {
    return self.chatVC.manager;
}

- (NSString *)chatroomName {
    return self.chatVC.chatroomName;
}

- (STSChatroomConnectionOptions)options {
    return self.chatVC.connectionOptions;
}

#pragma mark - Action
- (void)didTapLikeButton:(UIButton *)button {
    NSUInteger randomInt = (NSUInteger)arc4random_uniform(3);
    NSString * key = [self.emojis.allKeys objectAtIndex:randomInt];
    [self showFloatingImageViewWithEmojiKey:key count:1];
    [self addKeyToCached:key];
    [self.manager sendAggregatedDataWithKey:key chatroom:self.currentChat success:^{
        NSLog(@"send aggregated date success with key: %@", key);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"send aggregated data with error: %@", error);
    }];
}

- (void)showFloatingImageViewWithEmojiKey:(NSString *)key count:(NSInteger)count {
    if (count <= 0) {
        return;
    }
    UIImage * image = [self.emojis objectForKey:key];
    for (NSUInteger i = 0; i<count; i++) {
        FloatingImageView * imageView = [[FloatingImageView alloc] initWithImage:image];
        CGPoint convertedCenter = [self.view convertPoint:self.likeButton.center fromView:self.likeButton.superview];
        CGRect convertedFrame = [self.view convertRect:self.likeButton.frame fromView:self.likeButton.superview];
        imageView.center = CGPointMake(convertedCenter.x,
                                       convertedFrame.origin.y + image.size.height/2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:imageView];
            [imageView animateInView:self.view];
            self.likeCountLabel.text = @(self.likeCountLabel.text.integerValue + 1).stringValue;
        });
    }
}

- (void)addKeyToCached:(NSString *)key {
    BOOL hasCached = [self.cachedUserTapCount.allKeys containsObject:key];
    if (!hasCached) {
        [self.cachedUserTapCount addEntriesFromDictionary:@{key: @1}];
    } else {
        NSNumber * originalCount = [self.cachedUserTapCount objectForKey:key];
        self.cachedUserTapCount[key] = @(originalCount.unsignedIntegerValue + 1);
    }
}

#pragma mark - DataChannelEventDelegate

- (void)chatroomDidConnected:(STSChat *)chatroom {
    NSUInteger likeCount = 0;
    for (STSAggregatedItem * item in chatroom.totalAggregatedItems) {
        likeCount += item.count.unsignedIntegerValue;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.likeCountLabel.text = @(likeCount).stringValue;
    });
}

- (void)aggregatedItemsAdded:(NSArray<STSAggregatedItem *> *)aggregatedItems {
    for (STSAggregatedItem * item in aggregatedItems) {
        NSString * key = item.key;
        NSNumber * tapCountNumber = [self.cachedUserTapCount objectForKey:key];
        NSUInteger tapCountUInt = tapCountNumber ? tapCountNumber.unsignedIntegerValue : 0;
        [self showFloatingImageViewWithEmojiKey:key count:item.count.integerValue - tapCountUInt];
    }
    self.cachedUserTapCount = [NSMutableDictionary dictionary];
}

- (void)rawDataAdded:(STSChatMessage *)rawData {
    NSLog(@"rawData add: %@", rawData);
}

#pragma mark - Button Click Events

- (void)onShowKeyboardButtonClick:(id)sender {
    [self.chatVC presentKeyboard:NO];
}

#pragma mark - Public Methods

- (void)connectToChatWithJWT:(NSString *)JWT chatroomName:(NSString *)chatroomName connectionOptions:(STSChatroomConnectionOptions)connectionOptions {
    [self.chatVC connectToChatWithJWT:JWT chatroomName:chatroomName connectionOptions:connectionOptions];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"chatVC.textViewEditable"]) {
        BOOL editable = [change[NSKeyValueChangeNewKey] integerValue];
        self.showKeyboardButton.enabled = editable;
    }
}

@end
