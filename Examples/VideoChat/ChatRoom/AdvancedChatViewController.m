//
//  AdvancedChatViewController.m
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "AdvancedChatViewController.h"
#import <SlackTextViewController/SLKTextViewController.h>
#import <StraaSCoreSDK/StraaSCoreSDK.h>
#import "TransparentChatViewController.h"

@interface AdvancedChatViewController ()

@property (nonatomic) TransparentChatViewController *chatVC;

@end

@implementation AdvancedChatViewController

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
                                                       multiplier:0.4
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

#pragma mark - Button Click Events

- (void)onShowKeyboardButtonClick:(id)sender {
    [self.chatVC presentKeyboard:NO];
}

#pragma mark - Public Methods

- (void)connectToChatWithJWT:(NSString *)JWT chatroomName:(NSString *)chatroomName connectionOptions:(STSChatroomConnectionOptions)connectionOptions {
    [self.chatVC connectToChatWithJWT:JWT chatroomName:chatroomName connectionOptions:connectionOptions];
}

@end
