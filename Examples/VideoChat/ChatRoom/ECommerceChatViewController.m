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
#import "TransparentChatViewController.h"
#import "FloatingImageView.h"

@interface ECommerceChatViewController ()<DataChannelEventDelegate>

@property (nonatomic) TransparentChatViewController *chatVC;
@property (nonatomic) NSString * chatroomName;
@property (nonatomic) STSChatroomConnectionOptions options;
@property (nonatomic) UIButton * likeButton;
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

    // Add control buttons
    [self addControlButtons];

    [self addLikebutton];

}

#pragma mark - Private Methods

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
}

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
                                                       multiplier:0.43
                                                         constant:0]];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)addControlButtons {
    UIButton *showKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [showKeyboardButton setImage:[UIImage imageNamed:@"btn_msg_typing"] forState:UIControlStateNormal];
    [showKeyboardButton addTarget:self action:@selector(onShowKeyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showKeyboardButton];

    // Setup auto layout
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[showKeyboardButton(50)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"showKeyboardButton":showKeyboardButton}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatVC]-10-[showKeyboardButton(50)]-5-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"showKeyboardButton":showKeyboardButton,
                                                                                       @"chatVC":self.chatVC.view}]];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)addLikebutton {
    [self.view addSubview:self.likeButton];
    NSArray * constrants = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(37)]-15-|"
                                                                   options:0 metrics:nil
                                                                     views:@{@"button":self.likeButton}];
    [NSLayoutConstraint activateConstraints:constrants];
    constrants = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(37)]-10-|"
                                                         options:0 metrics:nil
                                                           views:@{@"button":self.likeButton}];
    [NSLayoutConstraint activateConstraints:constrants];
}

#pragma mark - Accessor

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"btn_emoji"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(didTapLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        _likeButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _likeButton;
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
    return [self.manager chatForChatroomName:self.chatroomName isPersonalChat:NO];
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
        imageView.center = CGPointMake(self.likeButton.center.x,
                                       self.likeButton.frame.origin.y + image.size.height/2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:imageView];
            [imageView animateInView:self.view];
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

@end
