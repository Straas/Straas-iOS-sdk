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
                                    chatroomName:(NSString *)chatroomName
                               connectionOptions:(STSChatroomConnectionOptions)connectionOptions {
    ChatStickerViewController * viewController =
    [[ChatStickerViewController alloc] initWithJWT:JWT
                                      chatroomName:chatroomName
                                 connectionOptions:connectionOptions];
    return viewController;
}

+ (instancetype)chatStickerViewControllerWithJWT:(NSString *)JWT
                                    chatroomName:(NSString *)chatroomName
                               connectionOptions:(STSChatroomConnectionOptions)connectionOptions
                              chatViewController:(id)chatViewController {
    ChatStickerViewController * viewController =
    [[ChatStickerViewController alloc] initWithJWT:JWT
                                      chatroomName:chatroomName
                                 connectionOptions:connectionOptions
                                chatViewController:chatViewController];
    return viewController;
}

- (instancetype)initWithJWT:(NSString *)JWT
               chatroomName:(NSString *)chatroomName
          connectionOptions:(STSChatroomConnectionOptions)connectionOptions {
    if (self = [super init]) {
        ChatViewController * chatVC =
        [ChatViewController chatViewControllerWithJWT:JWT
                                         chatroomName:chatroomName
                                    connectionOptions:connectionOptions];
        self.chatVC = chatVC;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithJWT:(NSString *)JWT
               chatroomName:(NSString *)chatroomName
          connectionOptions:(STSChatroomConnectionOptions)connectionOptions
         chatViewController:(id)chatViewController {
    NSAssert([chatViewController isKindOfClass:[chatViewController class]],
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

- (STSChatroomConnectionOptions)connectionOptions {
    return self.chatVC.connectionOptions;
}

- (STSChatManager *)manager {
    return self.chatVC.manager;
}

- (NSUInteger)stickerViewShowingHeight {
    if (!_stickerViewShowingHeight) {
        _stickerViewShowingHeight = defaultStickerViewHeight;
    }
    return _stickerViewShowingHeight;
}

#pragma mark - Public methods
- (void)configureApplication:(void (^)())success failure:(void (^)(NSError *))failure {
    [self.chatVC configureApplication:^(BOOL succeedConfiguration, NSError *error) {
        succeedConfiguration? success():failure(error);
    }];
}

- (void)connectToChat {
    [self.chatVC connectToChat];
}

- (void)connectToChatWithJWT:(NSString *)JWT chatroomName:(NSString *)chatroomName connectionOptions:(STSChatroomConnectionOptions)connectionOptions {
    [self.chatVC connectToChatWithJWT:JWT chatroomName:chatroomName connectionOptions:connectionOptions];
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

- (void)chatroom:(STSChat *)chatroom aggregatedDataAdded:(NSDictionary *)aggregatedData {
    [self.chatVC chatroom:chatroom aggregatedDataAdded:aggregatedData];
}

- (void)chatroom:(STSChat *)chatroom rawDataAdded:(id)rawData {
    [self.chatVC chatroom:chatroom rawDataAdded:rawData];
}

@end
