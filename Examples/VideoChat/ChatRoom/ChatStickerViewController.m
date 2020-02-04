//
//  ChatStickerViewController.m
//  VideoChat
//
//  Created by Lee on 04/11/2016.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import "ChatStickerViewController.h"
#import "ChatViewController.h"
#import "StickersInputView.h"

NSUInteger const defaultStickerViewHeight = 215;

@interface ChatStickerViewController ()
@property (nonatomic) StickersInputView * stickerView;
@property (nonatomic, getter=isStickerViewShowing) BOOL stickerViewShowing;
@property (nonatomic) NSLayoutConstraint * stickerHeightConstraint;
@property (nonatomic) NSUInteger stickerViewHeight;
@property (nonatomic) ChatViewController * chatVC;
@end

@implementation ChatStickerViewController

+ (instancetype)chatStickerViewControllerWithJWT:(NSString *)JWT
                                    chatroomName:(NSString *)chatroomName {
    ChatStickerViewController * viewController =
    [[ChatStickerViewController alloc] initWithJWT:JWT
                                      chatroomName:chatroomName];
    return viewController;
}

+ (instancetype)chatStickerViewControllerWithChatViewController:(ChatViewController *)chatViewController {
    ChatStickerViewController * viewController =
    [[ChatStickerViewController alloc] initWithChatViewController:chatViewController];
    return viewController;
}

- (instancetype)initWithJWT:(NSString *)JWT
               chatroomName:(NSString *)chatroomName {
    if (self = [super init]) {
        ChatViewController * chatVC = [ChatViewController new];
        self.chatVC = chatVC;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithChatViewController:(ChatViewController *)chatViewController {
    NSAssert([chatViewController isKindOfClass:[ChatViewController class]],
             @"chatViewController should be kind of ChatViewController object.");
    if (self = [super init]) {
        self.chatVC = chatViewController;
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
    self.chatVC.eventDelegate = self;
    self.chatVC.delegate = self;
    self.chatVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.chatVC];
    [self.view addSubview:self.chatVC.view];
    [self.view addSubview:self.stickerView];
    self.stickerViewShowingHeight = defaultStickerViewHeight;
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
    [self setStickerViewHeight:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - accessor.

- (StickersInputView *)stickerView {
    if (!_stickerView) {
        _stickerView = [[[NSBundle mainBundle] loadNibNamed:kStickersInputView owner:self options:nil] objectAtIndex:0];
        _stickerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stickerView;
}

- (NSString *)JWT {
    return self.chatVC.JWT;
}

- (NSString *)chatroomName {
    return self.chatVC.chatroomName;
}

- (STSChatManager *)manager {
    return self.chatVC.manager;
}

- (void)setStickerViewShowingHeight:(NSUInteger)stickerViewShowingHeight {
    self.stickerView.stickerInputViewHeight = stickerViewShowingHeight;
    _stickerViewShowingHeight = stickerViewShowingHeight;
}

#pragma mark - Public methods

- (void)connectToChatWithJWT:(NSString *)JWT chatroomName:(NSString *)chatroomName {
    [self.chatVC connectToChatWithJWT:JWT chatroomName:chatroomName];
}

- (void)disconnect {
    [self.chatVC disconnect];
}

- (void)chatStickerDidLoad:(NSArray *)stickers {
    [self.stickerView setStickers:stickers];
}

- (void)showStickerView:(BOOL)animated {
    self.stickerViewShowing = YES;
    [self setStickerViewHeight:self.stickerViewShowingHeight];
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

- (void)setStickerViewHeight:(NSUInteger)stickerViewHeight {
    _stickerViewHeight = stickerViewHeight;
    [self updateStickerViewHeight:stickerViewHeight];
}

- (void)updateStickerViewHeight:(CGFloat)height {
    if (self.stickerHeightConstraint) {
        [NSLayoutConstraint deactivateConstraints:@[self.stickerHeightConstraint]];
    }
    self.stickerHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.stickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:height];
    [NSLayoutConstraint activateConstraints:@[self.stickerHeightConstraint]];
}

#pragma mark - STSChatEvnetDelegate

- (void)chatroomConnected:(STSChat *)chatroom {
    [self.chatVC chatroomConnected:chatroom];
}

- (void)chatroomDisconnected:(STSChat *)chatroom {
    [self.chatVC chatroomDisconnected:chatroom];
}

- (void)chatroom:(STSChat *)chatroom failToConnect:(NSError *)error {
    [self.chatVC chatroom:chatroom failToConnect:error];
}

- (void)chatroom:(STSChat *)chatroom error:(NSError *)error {
    [self.chatVC chatroom:chatroom error:error];
}

- (void)chatroomInputModeChanged:(STSChat *)chatroom {
    [self.chatVC chatroomInputModeChanged:chatroom];
}

- (void)chatroom:(STSChat *)chatroom usersJoined:(NSArray<STSChatUser *> *)users {
    [self.chatVC chatroom:chatroom usersJoined:users];
}

- (void)chatroom:(STSChat *)chatroom usersUpdated:(NSArray<STSChatUser *> *)users {
    [self.chatVC chatroom:chatroom usersUpdated:users];
}

- (void)chatroom:(STSChat *)chatroom usersLeft:(NSArray<NSNumber *> *)userLabels {
    [self.chatVC chatroom:chatroom usersLeft:userLabels];
}

- (void)chatroomUserCount:(STSChat *)chatroom {
    [self.chatVC chatroomUserCount:chatroom];
}

- (void)chatroom:(STSChat *)chatroom messageAdded:(STSChatMessage *)message {
    [self.chatVC chatroom:chatroom messageAdded:message];
}

- (void)chatroom:(STSChat *)chatroom messageRemoved:(NSString *)messageId {
    [self.chatVC chatroom:chatroom messageRemoved:messageId];
}

- (void)chatroomMessageFlushed:(STSChat *)chatroom {
    [self.chatVC chatroomMessageFlushed:chatroom];
}

- (void)chatroom:(STSChat *)chatroom aggregatedItemsAdded:(NSArray<STSAggregatedItem *> *)aggregatedItems {
    [self.chatVC chatroom:chatroom aggregatedItemsAdded:aggregatedItems];
}

- (void)chatroom:(STSChat *)chatroom rawDataAdded:(STSChatMessage *)rawData {
    [self.chatVC chatroom:chatroom rawDataAdded:rawData];
}

- (void)chatroom:(STSChat *)chatroom pinnedMessageUpdated:(STSChatMessage *)pinnedMessage {
    [self.chatVC chatroom:chatroom pinnedMessageUpdated:pinnedMessage];
}

@end
