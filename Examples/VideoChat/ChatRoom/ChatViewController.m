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

@import StraaSMessagingSDK;
@import StraaSCoreSDK;

#import "STSChatMessage+VideoChatUtility.h"
#import "UIAlertController+VideoChatUtility.h"
#import "STSChatUser+VieoChatUtility.h"

#define DEBUG_CUSTOM_TYPING_INDICATOR 0

@interface ChatViewController () <STSChatEventDelegate>

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) NSArray *searchResult;

@property (nonatomic) STSChatManager * manager;
@property (nonatomic) STSChat * currentChat;

@property (nonatomic, getter=hasUpdatedNickname) BOOL updatedNickname;
@property (nonatomic) NSString * fakeName;

@end

@interface STSChatMessage (FakeMsg)
@property (nonatomic) STSChatMesssageType type;
@property (nonatomic) NSURL * stickerURL;
@end

@implementation ChatViewController 

- (instancetype)init
{
    self = [super initWithTableViewStyle:UITableViewStylePlain];
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

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}

- (void)commonInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIContentSizeCategoryDidChangeNotification object:nil];

    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
    [self registerClassForTextView:[MessageTextView class]];
#if DEBUG_CUSTOM_TYPING_INDICATOR
    // Register a UIView subclass, conforming to SLKTypingIndicatorProtocol, to use a custom typing indicator view.
    [self registerClassForTypingIndicatorView:[TypingIndicatorView class]];
#endif
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureStraaSMessaging];

    // SLKTVC's configuration
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = YES;

    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [self.singleTapGesture addTarget:self action:@selector(didTapTableView)];
    self.textInputbar.autoHideRightButton = YES;
    [self.leftButton setImage:[UIImage imageNamed:@"btn-stickers"] forState:UIControlStateNormal];
    self.leftButton.tintColor = [UIColor colorWithWhite:0.6 alpha:1];
    self.leftButton.userInteractionEnabled = NO;
    self.textInputbar.maxCharCount = 120;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;

    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editorLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];

#if !DEBUG_CUSTOM_TYPING_INDICATOR
    self.typingIndicatorView.canResignByTouch = YES;
#endif

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:MessengerCellIdentifier];
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:StickerCellIdentifier];
    [self.autoCompletionView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:AutoCompletionCellIdentifier];
}

#pragma mark StraaS Messaging Configuration

- (void)configureStraaSMessaging {
    self.messages = [NSMutableArray array];
    self.textView.editable = NO;

    [STSApplication configureApplication:^(BOOL success, NSError *error) {
        if (success) {
            [self.manager connectToChatroom:self.chatroomName JWT:self.JWT options:self.connectionOptions eventDelegate:self];
        } else {
            NSLog(@"STSApplication configure fail with error = %@", error);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_FOREVER, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.manager disconnectFromChatroom:self.currentChat];
        });
    }];
}

- (STSChatManager *)manager {
    if (!_manager) {
        _manager = [STSChatManager new];
    }
    return _manager;
}

- (STSChat *)currentChat {
    return [self.manager chatForChatroomName:self.chatroomName isPersonalChat:self.isPersonalChat];
}

- (BOOL)isPersonalChat {
    return self.connectionOptions & STSChatroomConnectionIsPersonalChat;
}

#pragma mark STSChatEventDelegate

- (void)chatroomConnected:(STSChat *)chatroom {
    NSLog(@"\"%@\" connected", chatroom.chatroomName);
    if ([self.delegate respondsToSelector:@selector(chatStickerDidLoad:)]) {
        [self.delegate chatStickerDidLoad:chatroom.stickers];
    }
    self.leftButton.userInteractionEnabled = YES;

    __weak ChatViewController * weakSelf = self;
    [self.manager getMessagesForChatroom:chatroom configuration:nil success:^(NSArray<STSChatMessage *> * _Nonnull messages) {
        [weakSelf.messages removeAllObjects];
        [weakSelf.messages addObjectsFromArray:messages];
        [weakSelf.tableView reloadData];
        [weakSelf updateTextViewForChatRoom:chatroom];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)chatroomDisconnected:(STSChat *)chatroom {
    NSLog(@"\"%@\" disconnected", chatroom.chatroomName);
}

- (void)chatroom:(STSChat *)chatroom failToConnect:(NSError *)error {
    NSLog(@"\"%@\" fail to connect", chatroom.chatroomName);
    NSLog(@"%@", error);
}

- (void)chatroom:(STSChat *)chatroom error:(NSError *)error {
    NSLog(@"chatroom %@ error %@", chatroom.chatroomName, error);
}

- (void)chatroomInputModeChanged:(STSChat *)chatroom {
    [self updateTextViewForChatRoom:chatroom];
}

-(void)chatroom:(STSChat *)chatroom usersJoined:(NSArray<STSChatUser *> *)users {
    NSLog(@"%@ joined %@", users, chatroom.chatroomName);
}

- (void)chatroom:(STSChat *)chatroom usersUpdated:(NSArray<STSChatUser *> *)users {
    STSChatUser * currentUser = [self.manager currentUserForChatroom:chatroom];
    __weak ChatViewController * weakSelf = self;
    for (STSChatUser * user in users) {
        if ([user isEqual:currentUser]) {
            [weakSelf updateTextViewForChatRoom:chatroom];
        }
    }
    NSLog(@"%@ updated in %@", users, chatroom);
}
- (void)chatroom:(STSChat *)chatroom usersLeft:(NSArray<NSNumber *> *)userLabels {
    NSLog(@"%@ left %@", userLabels, chatroom.chatroomName);
}

- (void)chatroomUserCount:(STSChat *)chatroom {
    NSLog(@"%@ user count = %d", chatroom, (int)chatroom.userCount);
}

- (void)chatroom:(STSChat *)chatroom messageAdded:(STSChatMessage *)message {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewRowAnimation rowAnimation = self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition = self.inverted ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;

    [self.tableView beginUpdates];
    [self.messages insertObject:message atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];

    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];

    // Fixes the cell from blinking (because of the transform, when using translucent cells)
    // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)chatRoom:(NSString *)chatRoomName messageRemoved:(NSString *)messageId {
    [self.messages enumerateObjectsUsingBlock:^(STSChatMessage * msg, NSUInteger index, BOOL * _Nonnull stop) {
        if ([msg.messageId isEqualToString:messageId]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewRowAnimation rowAnimation = self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
            [self.tableView beginUpdates];
            [self.messages removeObject:msg];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
            [self.tableView endUpdates];
            * stop = YES;
            return;
        }
    }];
}

- (void)chatRoomMessageFlushed:(NSString *)chatRoomName {
    [self.messages removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark Event Handler

- (void)updateTextViewForChatRoom:(STSChat *)chatroom {
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
    self.textView.editable = editable;
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
                [self.leftButton setImage:[UIImage imageNamed:@"btn-stickers"] forState:UIControlStateNormal];
                [self.delegate dismissStickerView:NO];
            }
            return NSLog(@"Will Show");
        case SLKKeyboardStatusDidShow:
            return NSLog(@"Did Show");
        case SLKKeyboardStatusWillHide:     return NSLog(@"Will Hide");
        case SLKKeyboardStatusDidHide:      return NSLog(@"Did Hide");
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
    [self.leftButton setImage:[UIImage imageNamed:@"btn-stickers"] forState:UIControlStateNormal];
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
        [self.leftButton setImage:[UIImage imageNamed:@"btn-stickers"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(dismissStickerView:)]) {
            [self.delegate dismissStickerView:(self.keyboardStatus == SLKKeyboardStatusDidShow)];
        }
        [self presentKeyboard:NO];
    } else {
        [self.leftButton setImage:[UIImage imageNamed:@"btn_ic_keyboard"] forState:UIControlStateNormal];
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
        [self.leftButton setImage:[UIImage imageNamed:@"btn-stickers"] forState:UIControlStateNormal];
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
- (void)didSelectStickerKey:(NSString *)key imageURL:(NSString *)imageURL{
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
                                          [weakSelf updateTextViewForChatRoom:weakSelf.currentChat];
                                          NSLog(@"update nickname success");
                                      } failure:^(NSError * _Nonnull error) {
                                          STSChatUser * currentUser = [self.manager currentUserForChatroom:self.currentChat];
                                          if ([currentUser.role isEqualToString:kSTSUserRoleBlocked]) {
                                              weakSelf.updatedNickname = YES;
                                              [weakSelf.textView becomeFirstResponder];
                                              [weakSelf updateTextViewForChatRoom:weakSelf.currentChat];
                                              self.fakeName = nickName;
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
    UIAlertController * alertController = [UIAlertController nicknameAlertControllerWithCurrentNickname:weakSelf.currentUsername cancelActionHandler:cancelHander confirmActionHandler:confirmHander];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)currentUsername {
    return [[self.manager currentUserForChatroom:self.currentChat] name];
}

- (BOOL)needsNickname {
    return !self.hasUpdatedNickname && self.JWT.length == 0;
}

- (void)addFakeMessage:(NSString *)fakeMessage type:(STSChatMesssageType)type imageURL:(NSString *)imageURL{
    STSChatUser * currentUser = [self.manager currentUserForChatroom:self.currentChat];
    NSDateFormatter * formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *strDate = [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".666Z"];
    strDate = [strDate stringByReplacingCharactersInRange:NSMakeRange(10, 1) withString:@"T"];
    NSString * avatar = currentUser.avatar ? : @"";
    NSString * fakeName = (self.JWT.length == 0) ? self.fakeName : currentUser.name;
    NSDictionary * fakeJson = @{@"text":fakeMessage,
                                @"createdDate": strDate,
                                @"creator": @{@"name":fakeName,
                                              @"avatar":avatar}};
    STSChatMessage * fakeMsg = [[STSChatMessage alloc] initWithJSON:fakeJson];
    fakeMsg.type = type;
    fakeMsg.stickerURL = imageURL ? [NSURL URLWithString:imageURL]: nil;
    [self chatroom:self.currentChat messageAdded:fakeMsg];
};

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
    } else {
        cell = (MessageTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:StickerCellIdentifier];
        UIImage * defaultImage = [UIImage imageNamed:@"img_sticker_default"];
        [cell.stickerImageView sd_setImageWithURL:message.stickerURL placeholderImage:defaultImage];
    }

    UIImage * avator = [UIImage imageNamed:@"img-guest-photo"];
    if (message.creator.avatar) {
        NSURL * URL = [NSURL URLWithString:message.creator.avatar];
        [cell.thumbnailView sd_setImageWithURL:URL placeholderImage:avator options:SDWebImageRefreshCached];
    } else {
        cell.thumbnailView.image = avator;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {

        STSChatMessage * message = self.messages[indexPath.row];
        if (message.type == STSChatMessageTypeSticker) {
            return kStickerTableViewCellHeight;
        }
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;

        CGFloat pointSize = [MessageTableViewCell defaultFontSize];

        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:pointSize],
                                     NSParagraphStyleAttributeName: paragraphStyle};

        CGFloat width = CGRectGetWidth(tableView.frame)-kMessageTableViewCellAvatarHeight;
        width -= 40.0;

        CGRect bodyBounds = [message.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];

        if (message.text.length == 0) {
            return 0.0;
        }

        CGFloat height = CGRectGetHeight(bodyBounds);
        height += 45.0;

        if (height < kMessageTableViewCellMinimumHeight) {
            height = kMessageTableViewCellMinimumHeight;
        }

        return height;
    }
    else {
        return kMessageTableViewCellMinimumHeight;
    }
}

#pragma mark - Lifeterm

- (void)dealloc
{
    [self.manager disconnectFromChatroom:self.currentChat];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
