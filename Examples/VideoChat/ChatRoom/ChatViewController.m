//
//  MessageViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//
//  ChatViewController.m
//  Modified by StraaS.io
//

#import "ChatViewController.h"
#import "MessageTableViewCell.h"
#import "MessageTextView.h"
#import "TypingIndicatorView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <StraaSCoreSDK/StraaSCoreSDK.h>
#import "STSChatMessage+VideoChatUtility.h"
#import "UIAlertController+VideoChatUtility.h"
#import "STSChatUser+VieoChatUtility.h"
#import "NSTimer+SafeTimer.h"
#import "STSMessageLongPressGestureRecognizer.h"
#import "UIViewController+VideoChatUtility.h"

#define DEBUG_CUSTOM_TYPING_INDICATOR 0

@interface ChatViewController ()

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong, nullable) STSChatMessage * pinnedMessage;

@property (nonatomic, strong) NSArray *searchResult;

@property (nonatomic, readwrite) NSString * JWT;
@property (nonatomic, readwrite) NSString * chatroomName;
@property (nonatomic, readwrite) STSChatroomConnectionOptions connectionOptions;
@property (nonatomic, readwrite) STSChatManager * manager;
@property (nonatomic) STSChat * currentChat;
@property (nonatomic) STSChatUser * currentUser;

@property (nonatomic, getter=hasUpdatedNickname) BOOL updatedNickname;
@property (nonatomic) NSString * fakeName;

//Custom view
@property (nonatomic) UIActivityIndicatorView * indicator;
@property (nonatomic) UIButton * jumpToLatestButton;
@property (nonatomic) NSLayoutConstraint * jumpToLatestButtonYPositionConstraint;
@property (nonatomic) NSMutableArray * allLayoutConstraints;
@property (nonatomic) STSPinnedMessageView * pinnedMessageView;
@property (nonatomic) UIView * emptySectionHeaderFooterView;
@property (nonatomic) NSLayoutConstraint * pinnedMessageYPositionConstraint;
@property (nonatomic) NSMutableArray * cachedAddedMessages;
@property (nonatomic) NSMutableArray * cachedRemovedMessageIds;
@property (nonatomic, weak) NSTimer * updateTableViewTimer;
@end

@interface STSChatMessage (FakeMsg)
@property (nonatomic) STSChatMesssageType type;
@property (nonatomic) NSURL * stickerURL;
@end

@implementation ChatViewController


- (instancetype)init {
    if (self = [super init]) {
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

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}

- (void)commonInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIContentSizeCategoryDidChangeNotification object:nil];

    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
    [self registerClassForTextView:[MessageTextView class]];
    _maxMessagesCount = 500;
    _refreshTableViewTimeInteval = 1.0;
    _autoConnect = YES;
    _shouldAddIndicatorView = YES;
    _shouldShowPinnedMessage = YES;
    _pinnedMessagePosition = STSPinnedMessagePositionTop;
    _allLayoutConstraints = [NSMutableArray new];
#if DEBUG_CUSTOM_TYPING_INDICATOR
    // Register a UIView subclass, conforming to SLKTypingIndicatorProtocol, to use a custom typing indicator view.
    [self registerClassForTypingIndicatorView:[TypingIndicatorView class]];
#endif
}

#pragma mark - Custom accessors

- (void)setShouldAddIndicatorView:(BOOL)shouldAddIndicatorView {
    if (_shouldAddIndicatorView == shouldAddIndicatorView) {
        return;
    }
    if (shouldAddIndicatorView) {
        [self addIndicatorView];
        [self addActivityIndicatorViewConstraints];
    } else {
        [self.indicator removeFromSuperview];
    }
    _shouldAddIndicatorView = shouldAddIndicatorView;
}

- (void)setPinnedMessage:(STSChatMessage *)pinnedMessage {
    _pinnedMessage = pinnedMessage;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configurePinnedMessageViewWithMessage:self.pinnedMessage];
    });
}

- (void)setShouldShowPinnedMessage:(BOOL)shouldShowPinnedMessage {
    if (_shouldShowPinnedMessage == shouldShowPinnedMessage) {
        return;
    }
    _shouldShowPinnedMessage = shouldShowPinnedMessage;
    if (_shouldShowPinnedMessage) {
        [self addPinnedMessageView];
    } else {
        [self.pinnedMessageView removeFromSuperview];
    }
    [self forceToUpdateTableSectionHeaderAndFooter];
    [self updateJumpToLatestButtonYPositionConstraint:(self.jumpToLatestButton.alpha == 1)];
}

- (void)setPinnedMessagePosition:(STSPinnedMessagePosition)pinnedMessagePosition {
    if (_pinnedMessagePosition == pinnedMessagePosition) {
        return;
    }
    _pinnedMessagePosition = pinnedMessagePosition;
    [self updatePinnedMessageYPositionConstraintIfNeeded];
    [self updatePinnedMessageShadow];
    [self forceToUpdateTableSectionHeaderAndFooter];
    [self updateJumpToLatestButtonYPositionConstraint:(self.jumpToLatestButton.alpha == 1)];
}

- (void)setInverted:(BOOL)inverted {
    [super setInverted:inverted];
    if (self.tableView) {
        [self.tableView reloadData];
    }
    if (self.pinnedMessageView) {
        [self updatePinnedMessageYPositionConstraintIfNeeded];
        [self updatePinnedMessageShadow];
    }
    if (self.jumpToLatestButton) {
        UIImage * image = [UIImage imageNamed:@"ic_arrow_downward_chatroom"];
        if (!inverted) {
            image = [[UIImage alloc] initWithCGImage: image.CGImage
                                               scale: [UIScreen mainScreen].scale
                                         orientation: UIImageOrientationDown];
        }
        [self.jumpToLatestButton setImage:image forState:UIControlStateNormal];
        [self updateJumpToLatestButtonYPositionConstraint:(self.jumpToLatestButton.alpha == 1)];
    }
}

- (STSChatUser *)currentUser {
    return [self.manager currentUserForChatroom:self.currentChat];
}

#pragma mark - Custom View.

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicator;
}

- (void)addIndicatorView {
    [self.view addSubview:self.indicator];
}

- (void)addActivityIndicatorViewConstraints {
    NSMutableArray * layoutConstraints = [NSMutableArray array];
    NSLayoutConstraint * constraint;
    constraint = [NSLayoutConstraint constraintWithItem:self.indicator
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1 constant:0];
    [layoutConstraints addObject:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.indicator
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1 constant:0];
    [layoutConstraints addObject:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.indicator
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1 constant:40];
    [layoutConstraints addObject:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.indicator
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1 constant:40];
    [layoutConstraints addObject:constraint];
    [self.allLayoutConstraints addObjectsFromArray:layoutConstraints];
    [NSLayoutConstraint activateConstraints:layoutConstraints];
}

- (STSPinnedMessageView *)pinnedMessageView {
    if (!_pinnedMessageView) {
        STSPinnedMessageView * pinnedMessageView = [STSPinnedMessageView new];
        pinnedMessageView.translatesAutoresizingMaskIntoConstraints = NO;
        pinnedMessageView.hidden = !(self.pinnedMessage);
        pinnedMessageView.bodyLabel.delegate = self;
        [pinnedMessageView.pinButton addTarget:self
                                        action:@selector(unpinMessage)
                              forControlEvents:UIControlEventTouchUpInside];
        _pinnedMessageView = pinnedMessageView;
    }
    return _pinnedMessageView;
}

- (void)addPinnedMessageView {
    if (!self.isViewLoaded) {
        return;
    }
    if ([[self.view subviews] containsObject:self.pinnedMessageView]) {
        return;
    }
    [self.view insertSubview:self.pinnedMessageView belowSubview:self.textInputbar];
    NSLayoutConstraint * constraint =
    [NSLayoutConstraint constraintWithItem:self.pinnedMessageView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1
                                  constant:0];
    [NSLayoutConstraint activateConstraints:@[constraint]];
    [self.allLayoutConstraints addObject:constraint];

    constraint =
    [NSLayoutConstraint constraintWithItem:self.pinnedMessageView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];
    [NSLayoutConstraint activateConstraints:@[constraint]];
    [self.allLayoutConstraints addObject:constraint];
    [self updatePinnedMessageYPositionConstraintIfNeeded];
}

- (void)updatePinnedMessageYPositionConstraintIfNeeded {
    if (!self.pinnedMessageView) {
        return;
    }
    if (self.pinnedMessageYPositionConstraint) {
        [NSLayoutConstraint deactivateConstraints:@[self.pinnedMessageYPositionConstraint]];
        [self.allLayoutConstraints removeObject:self.pinnedMessageYPositionConstraint];
        self.pinnedMessageYPositionConstraint = nil;
    }
    NSLayoutConstraint * constraint =
    [self pinnedMessageYPositionConstraintWithInverted:self.inverted
                                              position:self.pinnedMessagePosition];
    if (constraint) {
        [NSLayoutConstraint activateConstraints:@[constraint]];
        self.pinnedMessageYPositionConstraint = constraint;
        [self.allLayoutConstraints addObject:self.pinnedMessageYPositionConstraint];
    }
}

- (NSLayoutConstraint *)pinnedMessageYPositionConstraintWithInverted:(BOOL)inverted
                                                            position:(STSPinnedMessagePosition)position
{
    if (!self.pinnedMessageView
        || !self.tableView
        || ![[self.pinnedMessageView superview] isEqual:[self.tableView superview]] ) {
        return nil;
    }

    NSLayoutAttribute attribute;
    switch (position) {
        case STSPinnedMessagePositionTop:
            attribute = NSLayoutAttributeTop;
            break;
        case STSPinnedMessagePositionBottom:
            attribute = NSLayoutAttributeBottom;
            break;
        case STSPinnedMessagePositionAlignWithTheLatestMessage:
            attribute = inverted ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
            break;

        default:
            break;
    }
    return
    [NSLayoutConstraint constraintWithItem:self.pinnedMessageView
                                 attribute:attribute
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.tableView
                                 attribute:attribute
                                multiplier:1
                                  constant:0];
}

- (void)updatePinnedMessageShadow {
    if (!self.pinnedMessageView) {
        return;
    }
    if (![self pinnedMessageOnTheTop]) {
        self.pinnedMessageView.layer.shadowColor = [UIColor clearColor].CGColor;
    } else {
        self.pinnedMessageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.pinnedMessageView.layer.shadowOpacity = 0.2;
        self.pinnedMessageView.layer.shadowRadius = 2;
        self.pinnedMessageView.layer.shadowOffset = CGSizeMake(0, 1);
    }
}

- (void)configurePinnedMessageViewWithMessage:(STSChatMessage *)message {
    self.pinnedMessageView.hidden = !message;
    if (message.creator.avatar) {
        NSURL * URL = [NSURL URLWithString:message.creator.avatar];
        [self.pinnedMessageView.avatarView sd_setImageWithURL:URL
                                             placeholderImage:self.avatarPlaceholderImage
                                                      options:SDWebImageRefreshCached];
    } else {
        self.pinnedMessageView.avatarView.image = self.avatarPlaceholderImage;
    }
    NSString * creatorRole = message.creator.role;
    [self.pinnedMessageView.titleLabel setIconImage:[self iconImageForRole:creatorRole]];
    self.pinnedMessageView.titleLabel.textColor = [self textColorForRole:creatorRole];
    self.pinnedMessageView.titleLabel.text = message.creator.name;
    self.pinnedMessageView.bodyLabel.text = message.text;
    [self.pinnedMessageView setNeedsLayout];
    [self.pinnedMessageView layoutIfNeeded];
    [self forceToUpdateTableSectionHeaderAndFooter];
    [self updateJumpToLatestButtonYPositionConstraint:(self.jumpToLatestButton.alpha == 1)];
}

- (UIButton *)jumpToLatestButton {
    if (!_jumpToLatestButton) {
        UIButton * jumpToLatestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        jumpToLatestButton.translatesAutoresizingMaskIntoConstraints = NO;
        jumpToLatestButton.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:171.0/255.0 blue:181.0/255.0 alpha:1];
        jumpToLatestButton.titleLabel.textColor = [UIColor whiteColor];
        jumpToLatestButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [jumpToLatestButton addTarget:self action:@selector(didPressJumpToLatestButton:) forControlEvents:UIControlEventTouchUpInside];
        [jumpToLatestButton setTitle:NSLocalizedString(@"jump_to_lastest_message", nil) forState:UIControlStateNormal];
        [jumpToLatestButton setImage:[UIImage imageNamed:@"ic_arrow_downward_chatroom"] forState:UIControlStateNormal];
        jumpToLatestButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 10);
        jumpToLatestButton.layer.cornerRadius = 15;
        jumpToLatestButton.alpha = 0;
        _jumpToLatestButton = jumpToLatestButton;
    }
    return _jumpToLatestButton;
}

- (void)didPressJumpToLatestButton:(UIButton *)button {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self dismissJumpToLatestButton];
    [self dismissKeyboard:YES];
}

- (void)dismissJumpToLatestButton {
    [self updateJumpToLatestButtonYPositionConstraint:NO];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.jumpToLatestButton.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)dismissJumpToLatestButtonIfNeeded {
    if ([self isTableViewReachBottom:self.tableView] && self.jumpToLatestButton.alpha == 1) {
        [self dismissJumpToLatestButton];
    }
}

- (void)showJumpToLatestButtonIfNeeded {
    if ((![self isTableViewReachBottom:self.tableView] && self.jumpToLatestButton.alpha == 0) ||
        self.keyboardStatus == SLKKeyboardStatusDidShow) {
        [self showJumpToLatestButton];
    }
}

- (void)showJumpToLatestButton {
    [self updateJumpToLatestButtonYPositionConstraint:YES];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.jumpToLatestButton.alpha = 1;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)addJumpToLatestButton {
    if ([[self.view subviews] containsObject:self.pinnedMessageView]) {
        [self.view insertSubview:self.jumpToLatestButton belowSubview:self.pinnedMessageView];
    } else {
        [self.view insertSubview:self.jumpToLatestButton belowSubview:self.textInputbar];
    }
    NSMutableArray * layoutConstraints = [NSMutableArray array];
    [layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:self.jumpToLatestButton
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.tableView
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1 constant:0]];
    [layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:self.jumpToLatestButton
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1 constant:30]];
    [layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:self.jumpToLatestButton
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1 constant:120]];
    [self updateJumpToLatestButtonYPositionConstraint:NO];
    [self.allLayoutConstraints addObjectsFromArray:layoutConstraints];
    [NSLayoutConstraint activateConstraints:layoutConstraints];
}

- (void)updateJumpToLatestButtonYPositionConstraint:(BOOL)showJumpToLatestButton {
    if (!self.jumpToLatestButton) {
        return;
    }
    if (self.jumpToLatestButtonYPositionConstraint) {
        [NSLayoutConstraint deactivateConstraints:@[self.jumpToLatestButtonYPositionConstraint]];
        [self.allLayoutConstraints removeObject:self.jumpToLatestButtonYPositionConstraint];
        self.jumpToLatestButtonYPositionConstraint = nil;
    }
    NSLayoutConstraint * constraint =
    [self jumpToLatestButtonYPositionConstraintWithInverted:self.inverted
                                     showJumpToLatestButton:showJumpToLatestButton
                                     pinnedMessageVisiblity:[self isPinnedMessageViewVisible]
                                      pinnedMessagePosition:self.pinnedMessagePosition];
    if (constraint) {
        [NSLayoutConstraint activateConstraints:@[constraint]];
        self.jumpToLatestButtonYPositionConstraint = constraint;
        [self.allLayoutConstraints addObject:self.jumpToLatestButtonYPositionConstraint];
    }
}

- (NSLayoutConstraint *)jumpToLatestButtonYPositionConstraintWithInverted:(BOOL)inverted
                                                   showJumpToLatestButton:(BOOL)showJumpToLatestButton
                                                   pinnedMessageVisiblity:(BOOL)isPinnedMessageViewVisible
                                                    pinnedMessagePosition:(STSPinnedMessagePosition)pinnedMessagePosition
{
    if (!self.jumpToLatestButton
        || !self.tableView
        || ![[self.jumpToLatestButton superview] isEqual:[self.tableView superview]] ) {
        return nil;
    }

    NSLayoutAttribute attribute = self.inverted ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
    CGFloat constant = showJumpToLatestButton ? 10 : -40;
    BOOL jumpToLatestButtonOnTheTop = !self.inverted;
    BOOL shouldAdjust = ([self pinnedMessageOnTheTop] == jumpToLatestButtonOnTheTop);
    if (isPinnedMessageViewVisible && shouldAdjust) {
        constant += CGRectGetHeight(self.pinnedMessageView.frame);
    }
    if (inverted) {
        constant = -constant;
    }
    return
    [NSLayoutConstraint constraintWithItem:self.jumpToLatestButton
                                 attribute:attribute
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.tableView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
}

- (void)disconnectCurrentChatIfNeeded {
    if (self.currentChat) {
        [self.manager disconnectFromChatroom:self.currentChat];
    }
}

- (void)connectToChatWithJWT:(NSString *)JWT chatroomName:(NSString *)chatroomName connectionOptions:(STSChatroomConnectionOptions)connectionOptions {
    if (![JWT isEqualToString:self.JWT] || ![chatroomName isEqualToString:self.chatroomName] || connectionOptions != self.connectionOptions) {
        [self disconnectCurrentChatIfNeeded];
    }
    [self.indicator startAnimating];
    self.JWT = JWT;
    self.chatroomName = chatroomName;
    self.connectionOptions = connectionOptions;
    __weak ChatViewController * weakSelf = self;
    [STSApplication configureApplication:^(BOOL success, NSError *error) {
        if (weakSelf.configurationFinishHandler) {
            weakSelf.configurationFinishHandler(success,error);
            weakSelf.configurationFinishHandler = success ? nil : weakSelf.configurationFinishHandler;
        }
        if (success) {
            [weakSelf.manager connectToChatroom:chatroomName
                                            JWT:JWT
                                        options:connectionOptions
                                  eventDelegate:weakSelf.eventDelegate];
        } else {
            [self.indicator stopAnimating];
        }
    }];
}

- (void)disconnect {
    [self.manager disconnectFromChatroom:self.currentChat];
}

- (BOOL)isTextViewEditable {
    return self.textView.isEditable;
}

- (void)setTextViewEditable:(BOOL)textViewEditable {
    self.textView.editable = textViewEditable;
}

- (UIView *)emptySectionHeaderFooterView {
    if (!_emptySectionHeaderFooterView) {
        UIView * emptySectionHeaderFooterView = [UIView new];
        emptySectionHeaderFooterView.backgroundColor = [UIColor clearColor];
        _emptySectionHeaderFooterView = emptySectionHeaderFooterView;
    }
    return _emptySectionHeaderFooterView;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.textViewEditable = NO;
    // SLKTVC's configuration
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = YES;
    if (self.shouldAddIndicatorView) {
        [self addIndicatorView];
        [self addActivityIndicatorViewConstraints];
    }
    if (self.shouldShowPinnedMessage) {
        [self addPinnedMessageView];
    }
    [self addJumpToLatestButton];
    [self showStickerButtonIfNeeded];
    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [self.singleTapGesture addTarget:self action:@selector(didTapTableView)];
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 120;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;

    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editorLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    self.textInputbar.backgroundColor = [UIColor colorWithWhite:249./255. alpha:1.0];
    self.textInputbar.layer.shadowColor = [UIColor colorWithWhite:111.0/256.0 alpha:1.0].CGColor;
    self.textInputbar.layer.shadowOpacity = 0.12;
    self.textInputbar.layer.shadowRadius = 1;
    self.textInputbar.layer.shadowOffset = CGSizeMake(0, -1);

#if !DEBUG_CUSTOM_TYPING_INDICATOR
    self.typingIndicatorView.canResignByTouch = YES;
#endif

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:MessengerCellIdentifier];
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:StickerCellIdentifier];
    [self.autoCompletionView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:AutoCompletionCellIdentifier];
}

#pragma mark StraaS Messaging Configuration

- (STSChatManager *)manager {
    if (!_manager) {
        _manager = [STSChatManager new];
    }
    return _manager;
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (NSMutableArray *)cachedAddedMessages {
    if (!_cachedAddedMessages) {
        _cachedAddedMessages = [NSMutableArray array];
    }
    return _cachedAddedMessages;
}

- (NSMutableArray *)cachedRemovedMessageIds {
    if (!_cachedRemovedMessageIds) {
        _cachedRemovedMessageIds = [NSMutableArray array];
    }
    return _cachedRemovedMessageIds;
}

- (STSChat *)currentChat {
    return [self.manager chatForChatroomName:self.chatroomName isPersonalChat:self.isPersonalChat];
}

- (BOOL)isPersonalChat {
    return self.connectionOptions & STSChatroomConnectionIsPersonalChat;
}

- (id<STSChatEventDelegate>)eventDelegate {
    if (!_eventDelegate) {
        _eventDelegate = self;
    }
    return _eventDelegate;
}

- (UIImage *)avatarPlaceholderImage {
    if (!_avatarPlaceholderImage) {
        _avatarPlaceholderImage = [UIImage imageNamed:@"img-guest-photo"];
    }
    return _avatarPlaceholderImage;
}

- (UIImage *)stickerPlaceholderImage {
    if (!_stickerPlaceholderImage) {
        _stickerPlaceholderImage = [UIImage imageNamed:@"img_sticker_default"];
    }
    return _stickerPlaceholderImage;
}

- (UIImage *)stickerInputButtonImage {
    if (!_stickerInputButtonImage) {
        _stickerInputButtonImage = [UIImage imageNamed:@"btn-stickers"];
    }
    return _stickerInputButtonImage;
}

- (UIImage *)textInputButtonImage {
    if (!_textInputButtonImage) {
        _textInputButtonImage = [UIImage imageNamed:@"btn_ic_keyboard"];
    }
    return _textInputButtonImage;
}

- (void)showStickerButtonIfNeeded {
    if (!self.delegate) {
        return;
    }
    [self.leftButton setImage:self.stickerInputButtonImage forState:UIControlStateNormal];
    self.leftButton.tintColor = [UIColor colorWithWhite:0.6 alpha:1];
    self.leftButton.userInteractionEnabled = NO;
}

#pragma mark STSChatEventDelegate

- (void)chatroomConnected:(STSChat *)chatroom {
    if ([self.delegate respondsToSelector:@selector(chatStickerDidLoad:)]) {
        [self.delegate chatStickerDidLoad:chatroom.stickers];
    }
    [self startUpdateTableViewTimer];
    self.leftButton.userInteractionEnabled = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicator stopAnimating];
    });
    __weak ChatViewController * weakSelf = self;
    STSGetMessagesConfiguration * configuration = [STSGetMessagesConfiguration new];
    configuration.perPage = @40;
    [self.manager getMessagesForChatroom:chatroom configuration:configuration success:^(NSArray<STSChatMessage *> * _Nonnull messages) {
        [weakSelf.messages removeAllObjects];
        [weakSelf.messages addObjectsFromArray:messages];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf updateTextViewForChatroom:chatroom];
        });
    } failure:^(NSError * _Nonnull error) {

    }];
    [self getPinnedMessage];
}

- (void)chatroomInputModeChanged:(STSChat *)chatroom {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTextViewForChatroom:chatroom];
    });
}

- (void)chatroom:(STSChat *)chatroom usersUpdated:(NSArray<STSChatUser *> *)users {
    STSChatUser * currentUser = [self.manager currentUserForChatroom:chatroom];
    __weak ChatViewController * weakSelf = self;
    for (STSChatUser * user in users) {
        if ([user isEqual:currentUser]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateTextViewForChatroom:chatroom];
            });
        }
    }
}

- (void)chatroom:(STSChat *)chatroom messageAdded:(STSChatMessage *)message {
    if (!message) {
        return;
    }
    [self.cachedAddedMessages insertObject:message atIndex:0];
}

- (void)chatroom:(STSChat *)chatroom messageRemoved:(NSString *)messageId {
    if (!messageId) {
        return;
    }
    __block BOOL deleteMesageFromCached = NO;
    [self.cachedAddedMessages enumerateObjectsUsingBlock:^(STSChatMessage * msg, NSUInteger index, BOOL * _Nonnull stop) {
        if ([msg.messageId isEqualToString:messageId]) {
            [self.cachedAddedMessages removeObject:msg];
            deleteMesageFromCached = YES;
            * stop = YES;
            return;
        }
    }];
    if (!deleteMesageFromCached) {
        [self.cachedRemovedMessageIds addObject:messageId];
    }
}

- (void)chatroomMessageFlushed:(STSChat *)chatroom {
    [self.messages removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)chatroomDisconnected:(STSChat *)chatroom {
    [self cancelUpdateTableViewTimer];
}

- (void)chatroom:(STSChat *)chatroom usersLeft:(NSArray<NSNumber *> *)userLabels {}
- (void)chatroomUserCount:(STSChat *)chatroom {}
- (void)chatroom:(STSChat *)chatroom failToConnect:(NSError *)error {
    [self.indicator stopAnimating];
}
- (void)chatroom:(STSChat *)chatroom error:(NSError *)error {}
- (void)chatroom:(STSChat *)chatroom usersJoined:(NSArray<STSChatUser *> *)users {}
- (void)chatroom:(STSChat *)chatroom aggregatedItemsAdded:(NSArray<STSAggregatedItem *> *)aggregatedItems {}
- (void)chatroom:(STSChat *)chatroom rawDataAdded:(STSChatMessage *)rawData {}

- (void)chatroom:(STSChat *)chatroom pinnedMessageUpdated:(STSChatMessage *)pinnedMessage {
    self.pinnedMessage = pinnedMessage;
}

#pragma mark Event Handler

- (void)updateTextViewForChatroom:(STSChat *)chatroom {
    STSChatInputMode mode = chatroom.mode;
    STSChatUser * currentUser = [self.manager currentUserForChatroom:chatroom];
    NSString * placeholder;
    BOOL editable;
    switch (mode) {
        case STSChatInputNormal:
            editable = YES;
            placeholder = self.needsNickname ? @"Please Enter a Nickname" : @"Message";
            break;
        case STSChatInputMember:
            if (self.JWT.length != 0) {
                editable = YES;
                placeholder = @"Message";
            } else {
                editable = NO;
                placeholder = @"Only member can send message";
            }
            break;
        case STSChatInputMaster:
            if ([currentUser canChatInAnchorMode]) {
                editable = YES;
                placeholder = @"Message";
            } else {
                editable = NO;
                placeholder = @"Only master can send message";
            }
            break;
        default:
            editable = NO;
            placeholder = @"Conneting to Chatroom...";
            break;
    }
    self.textViewEditable = editable;
    self.textView.placeholder = placeholder;
}

#pragma mark - Overriden Methods

- (BOOL)forceTextInputbarAdjustmentForResponder:(UIResponder *)responder
{
    if ([responder isKindOfClass:[UIAlertController class]]) {
        return YES;
    }

    // On iOS 9, returning YES helps keeping the input view visible when the keyboard if presented from another app when using multi-tasking on iPad.
    return SLK_IS_IPAD;
}

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status
{
    // Notifies the view controller that the keyboard changed status.

    switch (status) {
        case SLKKeyboardStatusWillShow:
            if ([self.delegate isStickerViewShowing]) {
                [self.leftButton setImage:self.stickerInputButtonImage forState:UIControlStateNormal];
            }
            return NSLog(@"Will Show");
        case SLKKeyboardStatusDidShow:
            return NSLog(@"Did Show");
        case SLKKeyboardStatusWillHide:
            return NSLog(@"Will Hide");
        case SLKKeyboardStatusDidHide:
            [self dismissJumpToLatestButtonIfNeeded];
            return NSLog(@"Did Hide");
    }
}

- (void)didPressRightButton:(id)sender
{
    [self.textView resignFirstResponder];
    NSString * messageText = [self.textView.text copy];
    STSChatUser * currentUser = [self.manager currentUserForChatroom:self.currentChat];
    if ([self.delegate respondsToSelector:@selector(dismissStickerView:)]) {
        [self.delegate dismissStickerView:NO];
    }
    if (self.delegate) {
        [self.leftButton setImage:self.stickerInputButtonImage forState:UIControlStateNormal];
    }
    if (!messageText) {
        [super didPressRightButton:sender];
        return;
    }
    if ([currentUser.role isEqualToString:kSTSUserRoleBlocked]) {
        [self addFakeMessage:messageText type:STSChatMessageTypeText imageURL:nil];
    } else {
        [self.manager sendMessage:messageText chatroom:self.currentChat success:^{

        } failure:^(NSError * _Nonnull error) {

        }];
    }
    [super didPressRightButton:sender];
}

- (NSString *)keyForTextCaching
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)didPasteMediaContent:(NSDictionary *)userInfo
{
    // Notifies the view controller when the user has pasted a media (image, video, etc) inside of the text view.
    [super didPasteMediaContent:userInfo];

    SLKPastableMediaType mediaType = [userInfo[SLKTextViewPastedItemMediaType] integerValue];
    NSString *contentType = userInfo[SLKTextViewPastedItemContentType];
    id data = userInfo[SLKTextViewPastedItemData];

    NSLog(@"%s : %@ (type = %ld) | data : %@",__FUNCTION__, contentType, (unsigned long)mediaType, data);
}

- (BOOL)canPressRightButton
{
    STSChatInputMode mode = self.currentChat.mode;
    STSChatUser * currentUser = [self.manager currentUserForChatroom:self.currentChat];
    return ((mode == STSChatInputNormal) ||
            (mode == STSChatInputMember && self.JWT.length != 0) ||
            (mode == STSChatInputMaster && ([currentUser canChatInAnchorMode])));
}

- (void)didPressLeftButton:(id)sender {
    STSChatInputMode mode = self.currentChat.mode;
    if (mode == STSChatInputMaster || (mode == STSChatInputMember && self.JWT.length == 0)) {
        return;
    }
    if ([self needsNickname]) {
        [self presentNicknameInputView];
        return;
    }
    if ([self.delegate isStickerViewShowing]) {
        [self.leftButton setImage:self.stickerInputButtonImage forState:UIControlStateNormal];
        BOOL keyBoardDidShow = (self.keyboardStatus == SLKKeyboardStatusDidShow);
        if ([self.delegate respondsToSelector:@selector(dismissStickerView:)]) {
            [self.delegate dismissStickerView:keyBoardDidShow];
        }
        keyBoardDidShow ? [self dismissKeyboard:YES]: [self presentKeyboard:NO];
    } else {
        [self.leftButton setImage:self.textInputButtonImage forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(showStickerView:)]) {
            [self.delegate showStickerView:(self.keyboardStatus == SLKKeyboardStatusDidHide)];
        }
        [self dismissKeyboard:NO];
    }
}

- (void)didTapTableView {
    if (![self.delegate isStickerViewShowing]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(dismissStickerView:)]) {
        [self.leftButton setImage:self.stickerInputButtonImage forState:UIControlStateNormal];
        [self.delegate dismissStickerView:YES];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture {
    BOOL shouldBegin = [super gestureRecognizerShouldBegin:gesture];
    return shouldBegin ? YES: [self.delegate isStickerViewShowing];
}

- (BOOL)canShowTypingIndicator
{
#if DEBUG_CUSTOM_TYPING_INDICATOR
    return YES;
#else
    return [super canShowTypingIndicator];
#endif
}

- (void)didChangeAutoCompletionPrefix:(NSString *)prefix andWord:(NSString *)word
{
    self.searchResult = nil;

    BOOL show = (self.searchResult.count > 0);

    [self showAutoCompletionView:show];
}

- (CGFloat)heightForAutoCompletionView
{
    CGFloat cellHeight = [self.autoCompletionView.delegate tableView:self.autoCompletionView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cellHeight*self.searchResult.count;
}

#pragma mark - sticker view;
- (void)didSelectStickerKey:(NSString *)key imageURL:(NSString *)imageURL {
    STSChatUser * currentUser = [self.manager currentUserForChatroom:self.currentChat];
    if ([currentUser.role isEqualToString:kSTSUserRoleBlocked]) {
        [self addFakeMessage:key type:STSChatMessageTypeSticker imageURL:imageURL];
    } else {
        [self.manager sendMessage:key chatroom:self.currentChat success:^{

        } failure:^(NSError * _Nonnull error) {

        }];
    }
}

#pragma mark - private custom method
- (void)presentNicknameInputView {
    [self.textView resignFirstResponder];
    __weak ChatViewController * weakSelf = self;
    void (^cancelHander)(UIAlertAction *) = ^(UIAlertAction * action) {
        NSLog(@"update canceled");
    };
    void (^confirmHander)(UIAlertAction *, NSString *) = ^(UIAlertAction * action, NSString * nickName) {
        if ([nickName isEqualToString:@""]) {
            NSLog(@"nickname update invalid");
            return ;
        }
        [weakSelf.manager updateGuestNickname:nickName
                                     chatroom:weakSelf.currentChat
                                      success:^{
                                          weakSelf.updatedNickname = YES;
                                          [weakSelf.textView becomeFirstResponder];
                                          [weakSelf updateTextViewForChatroom:weakSelf.currentChat];
                                          NSLog(@"update nickname success");
                                      } failure:^(NSError * _Nonnull error) {
                                          STSChatUser * currentUser = [weakSelf.manager currentUserForChatroom:weakSelf.currentChat];
                                          if ([currentUser.role isEqualToString:kSTSUserRoleBlocked]) {
                                              weakSelf.updatedNickname = YES;
                                              [weakSelf.textView becomeFirstResponder];
                                              [weakSelf updateTextViewForChatroom:weakSelf.currentChat];
                                              weakSelf.fakeName = nickName;
                                              return;
                                          }
                                          UIAlertController * failureController =
                                          [UIAlertController alertControllerWithTitle:@"Failed to set nickname."
                                                                              message:@"Oops, it seems that you failed to update nickname for some reason. Try to update again later."
                                                                 confirmActionHandler:nil];
                                          [weakSelf presentViewController:failureController animated:YES completion:nil];
                                          NSLog(@"update nickname failure with error: %@", error);
                                      }];
    };
    UIAlertController * alertController = [UIAlertController nicknameAlertControllerWithCurrentNickname:weakSelf.currentUsername
                                                                                    cancelActionHandler:cancelHander
                                                                                   confirmActionHandler:confirmHander];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)currentUsername {
    return [[self.manager currentUserForChatroom:self.currentChat] name];
}

- (BOOL)needsNickname {
    return !self.hasUpdatedNickname && self.JWT.length == 0;
}

- (UIImage *)iconImageForRole:(NSString *)userRole {
    if ([userRole isEqualToString:kSTSUserRoleNormal] ||
        [userRole isEqualToString:kSTSUserRoleBlocked]) {
        return nil;
    } else if ([userRole isEqualToString:kSTSUserRoleMaster]) {
        return [UIImage imageNamed:@"ic_host_chatroom"];
    } else {
        return [UIImage imageNamed:@"ic_moderator_chatroom"];
    }
}

- (UIColor *)textColorForRole:(NSString *)userRole {
    if ([userRole isEqualToString:kSTSUserRoleNormal] ||
        [userRole isEqualToString:kSTSUserRoleBlocked]) {
        return [UIColor blackColor];
    } else if ([userRole isEqualToString:kSTSUserRoleMaster]) {
        return [UIColor colorWithRed:242.0/255.0 green:154.0/255.0 blue:11.0/255.0 alpha:1];
    } else {
        return [UIColor colorWithRed:123.0/255.0 green:75.0/255.0 blue:163.0/255.0 alpha:1];
    }
}

- (void)addFakeMessage:(NSString *)fakeMessage type:(STSChatMesssageType)type imageURL:(NSString *)imageURL {
    STSChatUser * currentUser = [self.manager currentUserForChatroom:self.currentChat];
    NSDateFormatter * formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *strDate = [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".666Z"];
    strDate = [strDate stringByReplacingCharactersInRange:NSMakeRange(10, 1) withString:@"T"];
    NSString * avatar = currentUser.avatar ? : @"";
    NSString * fakeName = (self.JWT.length == 0) ? self.fakeName : currentUser.name;
    fakeName = fakeName ? fakeName : @"";
    NSDictionary * fakeJson = @{@"text":fakeMessage,
                                @"createdDate": strDate,
                                @"creator": @{@"name":fakeName,
                                              @"avatar":avatar}};
    STSChatMessage * fakeMsg = [[STSChatMessage alloc] initWithJSON:fakeJson];
    fakeMsg.type = type;
    fakeMsg.stickerURL = imageURL ? [NSURL URLWithString:imageURL]: nil;
    [self chatroom:self.currentChat messageAdded:fakeMsg];
};

- (void)forceToUpdateTableSectionHeaderAndFooter {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)getPinnedMessage {
    __weak ChatViewController * weakSelf = self;
    [self.manager getPinnedMessageForChat:self.currentChat success:^(STSChatMessage *message){
        weakSelf.pinnedMessage = message;
    } failure:^(NSError * error){
    }];
}

- (void)pinMessage:(NSString *)messageId {
    if (![self currentUserCanManageMessages]) {
        return;
    }
    [self.indicator startAnimating];
    __weak ChatViewController * weakSelf = self;
    [self.manager pinMessage:messageId chatroom:self.currentChat success:^{
        [weakSelf.indicator stopAnimating];
    } failure:^(NSError * error) {
        [weakSelf.indicator stopAnimating];
        [weakSelf showOperationFailedAlert];
    }];
}

- (void)unpinMessage {
    if (![self currentUserCanManageMessages]) {
        return;
    }
    [self.indicator startAnimating];
    __weak ChatViewController * weakSelf = self;
    [self.manager unpinMessageFromChatroom:self.currentChat success:^{
        [weakSelf.indicator stopAnimating];
    } failure:^(NSError * error) {
        [weakSelf.indicator stopAnimating];
        [weakSelf showOperationFailedAlert];
    }];
}

- (void)deleteMessage:(NSString *)messageId {
    if (![self currentUserCanManageMessages]) {
        return;
    }
    [self.indicator startAnimating];
    __weak ChatViewController * weakSelf = self;
    [self.manager removeMessage:messageId chatroom:self.currentChat success:^{
        [weakSelf.indicator stopAnimating];
    } failure:^(NSError * error){
        [weakSelf.indicator stopAnimating];
        [weakSelf showOperationFailedAlert];
    }];
}

- (void)didLongPressCell:(STSMessageLongPressGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    if (![self currentUserCanManageMessages]) {
        return;
    }
    STSChatMessage * message = gesture.message;
    if (!message) {
        return;
    }

    void (^pinHandler)(UIAlertAction *) = nil;
    if (message.type == STSChatMessageTypeText && ![self isPinnedMessage:message]) {
        pinHandler = ^(UIAlertAction *action) {
            [self pinMessage:message.messageId];
        };
    }

    void (^deleteHandler)(UIAlertAction *) = nil;
    if (![self isPinnedMessage:message]) {
        deleteHandler = ^(UIAlertAction *action) {
            [self deleteMessage:message.messageId];
        };
    }

    void (^unpinHandler)(UIAlertAction *) = nil;
    if ([self isPinnedMessage:message]) {
        unpinHandler = ^(UIAlertAction *action) {
            [self unpinMessage];
        };
    }
    NSString * messageString =
    (message.type == STSChatMessageTypeText) ? [NSString stringWithFormat:@"\"%@\"", message.text] : nil;
    UIAlertController * alertController =
    [UIAlertController messageAlertControllerWithTitle:nil
                                               message:messageString
                                      pinActionHandler:pinHandler
                                   deleteActionHandler:deleteHandler
                                    unpinActionHandler:unpinHandler
                                   cancelActionHandler:nil];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isPinnedMessage:(STSChatMessage *)targetMessage {
    if (!self.pinnedMessage) {
        return NO;
    }
    return [self.pinnedMessage.messageId isEqualToString:targetMessage.messageId];
}

- (BOOL)currentUserCanManageMessages {
    return [self.currentUser.role isEqualToString:kSTSUserRoleMaster]
    || [self.currentUser.role isEqualToString:kSTSUserRoleModerator]
    || [self.currentUser.role isEqualToString:kSTSUserRoleGlobalManager]
    || [self.currentUser.role isEqualToString:kSTSUserRoleLocalManager];
}

- (void)showOperationFailedAlert {
    [self showMessage:NSLocalizedString(@"operation_failed_message", nil) dismissAfter:1];
}

- (BOOL)isPinnedMessageViewVisible {
    return self.shouldShowPinnedMessage
    && self.pinnedMessageView
    && CGRectGetHeight(self.pinnedMessageView.frame)
    && !self.pinnedMessageView.hidden;
}

- (BOOL)pinnedMessageOnTheTop {
    return (self.pinnedMessagePosition == STSPinnedMessagePositionTop) ||
    (!self.inverted && (self.pinnedMessagePosition == STSPinnedMessagePositionAlignWithTheLatestMessage));
}

#pragma mark - update tableView timer

- (void)startUpdateTableViewTimer {
    __weak ChatViewController * weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.updateTableViewTimer = [NSTimer safeScheduledTimerWithTimeInterval:weakSelf.refreshTableViewTimeInteval
                                                                          block:^{[weakSelf updateTabelViewTimerFired];}
                                                                        repeats:YES];
    });
}

- (void)updateTabelViewTimerFired {
    NSUInteger cachedAddedMessagesCount = self.cachedAddedMessages.count;
    NSUInteger cachedRemovedMessageIdsCount = self.cachedRemovedMessageIds.count;
    if (cachedAddedMessagesCount == 0 && cachedRemovedMessageIdsCount == 0) {
        return;
    }
    if (cachedAddedMessagesCount != 0) {
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, cachedAddedMessagesCount)];
        [self.messages insertObjects:self.cachedAddedMessages atIndexes:indexSet];
        [self showJumpToLatestButtonIfNeeded];
}
    for (NSString * messageId in self.cachedRemovedMessageIds) {
        for (STSChatMessage * message in self.messages) {
            if ([message.messageId isEqualToString:messageId]) {
                [self.messages removeObject:message];
                break;
            }
        }
    }
    if (![self isTableViewReachBottom:self.tableView]) {
        CGPoint contentOffset = self.tableView.contentOffset;
        [self.tableView reloadData];
        //Force tableview layout, or content offset would have issue.
        [self.tableView setNeedsLayout];
        [self.tableView layoutIfNeeded];
        CGFloat diffContentOffsetY = [self diffContentOffSetYForTableView:self.tableView
                                                 cachedAddedMessagesCount:cachedAddedMessagesCount];
        contentOffset.y += diffContentOffsetY;
        self.tableView.contentOffset = contentOffset;
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView setContentOffset:contentOffset animated:NO];
        });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
      });
    }

    [self.cachedAddedMessages removeAllObjects];
    [self.cachedRemovedMessageIds removeAllObjects];
    [self removeMessagesCachedIfNeeded];
}

- (CGFloat)diffContentOffSetYForTableView:(UITableView *)tableView
                 cachedAddedMessagesCount:(NSUInteger)cachedAddedMessagesCount {
    CGFloat contentOffsetY = 0;
    for (NSUInteger i = 0; i < cachedAddedMessagesCount; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CGRect cellBounds = [tableView rectForRowAtIndexPath:indexPath];
        contentOffsetY += CGRectGetHeight(cellBounds);
    }
    return contentOffsetY;
}

- (void)cancelUpdateTableViewTimer {
    if (!self.updateTableViewTimer) {
        return;
    }
    [self.updateTableViewTimer invalidate];
    self.updateTableViewTimer = nil;
}

- (void)removeMessagesCachedIfNeeded {
    if (self.messages.count <= self.maxMessagesCount ||
        self.maxMessagesCount == 0) {
        return;
    }
    NSRange deleteRange = NSMakeRange(self.maxMessagesCount, self.messages.count - self.maxMessagesCount);
    [self.messages removeObjectsInRange:deleteRange];

}

#pragma mark - SLKTextViewDelegate Methods

- (BOOL)textView:(SLKTextView *)textView shouldOfferFormattingForSymbol:(NSString *)symbol
{
    if ([symbol isEqualToString:@">"]) {

        NSRange selection = textView.selectedRange;

        // The Quote formatting only applies new paragraphs
        if (selection.location == 0 && selection.length > 0) {
            return YES;
        }

        // or older paragraphs too
        NSString *prevString = [textView.text substringWithRange:NSMakeRange(selection.location-1, 1)];

        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:[prevString characterAtIndex:0]]) {
            return YES;
        }

        return NO;
    }

    return [super textView:textView shouldOfferFormattingForSymbol:symbol];
}

- (BOOL)textView:(SLKTextView *)textView shouldInsertSuffixForFormattingWithSymbol:(NSString *)symbol prefixRange:(NSRange)prefixRange
{
    if ([symbol isEqualToString:@">"]) {
        return NO;
    }

    return [super textView:textView shouldInsertSuffixForFormattingWithSymbol:symbol prefixRange:prefixRange];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self needsNickname]) {
        [self presentNicknameInputView];
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return self.messages.count;
    }
    else {
        return self.searchResult.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        return [self messageCellForRowAtIndexPath:indexPath];
    }
    else {
        return [self autoCompletionCellForRowAtIndexPath:indexPath];
    }
}

- (MessageTableViewCell *)messageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STSChatMessage * message = self.messages[indexPath.row];
    MessageTableViewCell *cell;
    if (message.type == STSChatMessageTypeText) {
        cell = (MessageTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MessengerCellIdentifier];
        cell.bodyLabel.delegate = self;
    } else {
        cell = (MessageTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:StickerCellIdentifier];
        [cell.stickerImageView sd_setImageWithURL:message.stickerURL placeholderImage:self.stickerPlaceholderImage];
    }

    STSMessageLongPressGestureRecognizer * longPressGR = nil;
    for (UIGestureRecognizer *  gr in cell.gestureRecognizers) {
        if ([gr isKindOfClass:[STSMessageLongPressGestureRecognizer class]]) {
            longPressGR = (STSMessageLongPressGestureRecognizer*)gr;
            break;
        }
    }
    if (!longPressGR) {
        longPressGR =
        [[STSMessageLongPressGestureRecognizer alloc]
         initWithTarget:self action:@selector(didLongPressCell:)];
        [cell addGestureRecognizer:longPressGR];
    }
    longPressGR.message = message;

    if (message.creator.avatar) {
        NSURL * URL = [NSURL URLWithString:message.creator.avatar];
        [cell.thumbnailView sd_setImageWithURL:URL placeholderImage:self.avatarPlaceholderImage options:SDWebImageRefreshCached];
    } else {
        cell.thumbnailView.image = self.avatarPlaceholderImage;
    }
    NSString * creatorRole = message.creator.role;
    [cell.titleLabel setIconImage:[self iconImageForRole:creatorRole]];
    cell.titleLabel.textColor = [self textColorForRole:creatorRole];

    cell.titleLabel.text = message.creator.name;
    cell.sideLabel.text = message.shortCreatedDate;
    cell.bodyLabel.text = message.text;

    cell.indexPath = indexPath;
    cell.usedForMessage = YES;

    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;

    return cell;
}

- (MessageTableViewCell *)autoCompletionCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = (MessageTableViewCell *)[self.autoCompletionView dequeueReusableCellWithIdentifier:AutoCompletionCellIdentifier];
    cell.indexPath = indexPath;

    NSString *text = self.searchResult[indexPath.row];

    if ([self.foundPrefix isEqualToString:@"#"]) {
        text = [NSString stringWithFormat:@"# %@", text];
    }
    else if (([self.foundPrefix isEqualToString:@":"] || [self.foundPrefix isEqualToString:@"+:"])) {
        text = [NSString stringWithFormat:@":%@:", text];
    }

    cell.titleLabel.text = text;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.autoCompletionView]) {

        NSMutableString *item = [self.searchResult[indexPath.row] mutableCopy];

        if ([self.foundPrefix isEqualToString:@"@"] && self.foundPrefixRange.location == 0) {
            [item appendString:@":"];
        }
        else if (([self.foundPrefix isEqualToString:@":"] || [self.foundPrefix isEqualToString:@"+:"])) {
            [item appendString:@":"];
        }

        [item appendString:@" "];

        [self acceptAutoCompletionWithString:item keepPrefix:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    STSChatMessage * msg = self.messages[indexPath.row];
    if (msg.type == STSChatMessageTypeText) {
        return [MessageTableViewCell estimateBodyLabelHeightWithText:msg.text
                                                          widthToFit:tableView.bounds.size.width];
    } else {
        return 115.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    STSChatMessage * msg = self.messages[indexPath.row];
    if (msg.type == STSChatMessageTypeText) {
        return [MessageTableViewCell estimateBodyLabelHeightWithText:msg.text
                                                          widthToFit:tableView.bounds.size.width];
    } else {
        return 115.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![self shouldShowPinnedMessageAtTheSectionHeader]){
        return nil;
    }
    UIView * view = self.emptySectionHeaderFooterView;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self shouldShowPinnedMessageAtTheSectionHeader]){
        return nil;
    }
    UIView * view = self.emptySectionHeaderFooterView;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!self.pinnedMessage || !self.shouldShowPinnedMessage) {
        return 0;
    }
    if (![self shouldShowPinnedMessageAtTheSectionHeader]) {
        return 0;
    }
    return CGRectGetHeight(self.pinnedMessageView.frame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!self.pinnedMessage || !self.shouldShowPinnedMessage) {
        return 0;
    }
    if ([self shouldShowPinnedMessageAtTheSectionHeader]) {
        return 0;
    }
    return CGRectGetHeight(self.pinnedMessageView.frame);
}

- (void)scrollViewDidScroll:(UITableView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    if ([self isTableViewReachBottom:scrollView] && self.jumpToLatestButton.alpha != 0) {
        [self dismissJumpToLatestButton];
    }
}

- (BOOL)isTableViewReachBottom:(UITableView *)tableView {
    return tableView.contentOffset.y <= 0;
}

- (BOOL)shouldShowPinnedMessageAtTheSectionHeader {
    switch (self.pinnedMessagePosition) {
        case STSPinnedMessagePositionTop:
            return !self.inverted;
        case STSPinnedMessagePositionBottom:
            return self.inverted;
        case STSPinnedMessagePositionAlignWithTheLatestMessage:
        default:
            return YES;
    }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Lifeterm

- (void)dealloc
{
    [self.manager disconnectFromChatroom:self.currentChat];
    [self cancelUpdateTableViewTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
