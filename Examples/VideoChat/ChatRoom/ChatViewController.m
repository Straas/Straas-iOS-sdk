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

@import StraaSMessagingSDK;
@import StraaSCoreSDK;

#import "STSChatMessage+VideoChatUtility.h"
#import "UIAlertController+VideoChatUtility.h"

#define DEBUG_CUSTOM_TYPING_INDICATOR 0

@interface ChatViewController () <STSChatEventDelegate>

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) NSArray *searchResult;

@property (nonatomic) STSChatManager * manager;
@property (nonatomic) NSString * chatRoomName;
@property (nonatomic) NSString * JWT;

@property (nonatomic, getter=hasUpdatedNickname) BOOL updatedNickname;
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
    
    self.textInputbar.autoHideRightButton = YES;
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
        [self.manager connectToChatRoom:self.chatRoomName JWT:self.JWT autoCreate:YES eventDelegate:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_FOREVER, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.manager disconnectFromChatRoom:self.chatRoomName];
        });
    }];
}

- (STSChatManager *)manager {
    if (!_manager) {
        _manager = [STSChatManager new];
    }
    return _manager;
}

- (NSString *)chatRoomName {
#warning It is a placeholder, should be replaced with an existing channel code.
    return @"Winterfell";
}

- (NSString *)JWT {
#warning It is a placeholder, should be replaced with a CMS member JWT.
    return @"";
}

#pragma mark STSChatEventDelegate

- (void)chatRoomConnected:(NSString *)chatRoomName {
    NSLog(@"\"%@\" connected", chatRoomName);
    __weak ChatViewController * weakSelf = self;
    [self.manager getMessagesForChatRoom:chatRoomName success:^(NSArray<STSChatMessage *> * _Nonnull messages) {
        [weakSelf.messages addObjectsFromArray:messages];
        [weakSelf.tableView reloadData];
        [weakSelf updateTextViewForChatRoom:chatRoomName];
    } failure:^(NSError * _Nonnull error) {

    }];
}

- (void)chatRoomDisconnected:(NSString *)chatRoomName {
    NSLog(@"\"%@\" disconnected", chatRoomName);
}

- (void)chatRoom:(NSString *)chatRoomName failToConnect:(NSError *)error {
    NSLog(@"\"%@\" fail to connect", chatRoomName);
    NSLog(@"%@", error);
}

- (void)chatRoom:(NSString *)chatRoomName error:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)chatRoomInputModeChanged:(NSString *)chatRoomName {
    [self updateTextViewForChatRoom:chatRoomName];
}

- (void)chatRoom:(NSString *)chatRoomName usersJoined:(NSArray<STSChatUser *> *)users {
    NSLog(@"%@ joined %@", users, chatRoomName);
}

- (void)chatRoom:(NSString *)chatRoomName usersUpdated:(NSArray<STSChatUser *> *)users {
    NSLog(@"%@ updated in %@", users, chatRoomName);
}

- (void)chatRoom:(NSString *)chatRoomName usersLeft:(NSArray<NSNumber *> *)userLabels {
    NSLog(@"%@ left %@", userLabels, chatRoomName);
}

- (void)chatRoomUserCount:(NSString *)chatRoomName {
    NSLog(@"%@ user count", chatRoomName);
}

- (void)chatRoom:(NSString *)chatRoomName messageAdded:(STSChatMessage *)message {
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

}

- (void)chatRoomMessageFlushed:(NSString *)chatRoomName {
    [self.messages removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark Event Handler

- (void)updateTextViewForChatRoom:(NSString *)chatRoomName {
    STSChatInputMode mode = [[self.manager chatForChatRoom:chatRoomName] mode];
    if (mode == STSChatInputNormal) {
        self.textView.editable = YES;
        if ([self needsNickname]) {
            self.textView.placeholder = @"Please Enter a Nickname";
        } else {
            self.textView.placeholder = @"Message";
        }
        return;
    }
    if (mode == STSChatInputMember && self.JWT.length != 0) {
        self.textView.editable = YES;
        self.textView.placeholder = @"Message";
        return;
    }
    self.textView.editable = NO;
    self.textView.placeholder = @"Only member can send message";
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
        case SLKKeyboardStatusWillShow:     return NSLog(@"Will Show");
        case SLKKeyboardStatusDidShow:      return NSLog(@"Did Show");
        case SLKKeyboardStatusWillHide:     return NSLog(@"Will Hide");
        case SLKKeyboardStatusDidHide:      return NSLog(@"Did Hide");
    }
}

- (void)didPressRightButton:(id)sender
{
    [self.textView resignFirstResponder];

    [self.manager sendMessage:[self.textView.text copy] chatRoom:self.chatRoomName success:^{

    } failure:^(NSError * _Nonnull error) {

    }];

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
    STSChatInputMode mode = [[self.manager chatForChatRoom:self.chatRoomName] mode];
    return ((mode == STSChatInputNormal) ||
            (mode == STSChatInputMember && self.JWT.length != 0));
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
                                     chatRoom:weakSelf.chatRoomName
                                      success:^{
                                          weakSelf.updatedNickname = YES;
                                          [weakSelf.textView becomeFirstResponder];
                                          [weakSelf updateTextViewForChatRoom:weakSelf.chatRoomName];
                                          NSLog(@"update nickname success");
                                      } failure:^(NSError * _Nonnull error) {
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
    return [[self.manager currentUserForChatRoom:self.chatRoomName] name];
}

- (BOOL)needsNickname {
    return !self.hasUpdatedNickname && self.JWT.length == 0;
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
    } else {
        cell = (MessageTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:StickerCellIdentifier];
        NSData * imageData = [NSData dataWithContentsOfURL:message.stickerURL];
        cell.stickerImageView.image = [UIImage imageWithData:imageData];
    }
    
    UIImage * avator = [UIImage imageNamed:@"img-guest-photo"];
    if (message.creator.avatar) {
        NSURL * URL = [NSURL URLWithString:message.creator.avatar];
        NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
        avator = [UIImage imageWithData:data];
    }
    cell.thumbnailView.image = avator;
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
    [self.manager disconnectFromChatRoom:self.chatRoomName];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
