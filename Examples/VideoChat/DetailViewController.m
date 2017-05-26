//
//  DetailViewController.m
//  VideoChat
//
//  Created by Luke Jang on 8/26/16.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import "DetailViewController.h"
#import "ChatExampleViewController.h"
#import "ECommerceChatViewController.h"
#import "ChatStickerExampleViewController.h"
#import "StreamingViewController.h"

NSString * const STSMessagingServiceKeyword = @"StraaS.io default chatroom";
NSString * const STSMessagingServiceCustomUIKeyword = @"StraaS.io customed chatroom";
NSString * const STSMessagingServiceECommerceUIKeyword = @"StraaS.io ECommerce chatroom";
NSString * const STSStreamingServiceKeyword = @"StraaS.io streaming";

@interface DetailViewController ()
@property (nonatomic) UIViewController * contentViewController;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (NSString *)JWT {
    return <#PUT_YOUR_MEMEBER_JWT_HERE#>;
}

- (NSString *)chatroomName {
    return <#PUT_YOUR_CHATROOMNAME_HERE#>;
}

- (STSChatroomConnectionOptions)chatroomConnectionOptions {
    return <#PUT_YOUR_CONNECTIONOPTIONS_HERE#>;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        self.navigationItem.title = [self.detailItem description];
    }
    if ([self.detailItem isEqualToString:STSMessagingServiceKeyword]) {
        [self addDefaultChatView];
    }
    if ([self.detailItem isEqualToString:STSMessagingServiceCustomUIKeyword]) {
        [self addCustomChatView];
    }
    if ([self.detailItem isEqualToString:STSMessagingServiceECommerceUIKeyword]) {
        [self addECommerceChatView];
    }
    if ([self.detailItem isEqualToString:STSStreamingServiceKeyword]) {
        [self addStreamingView];
    }
}

- (void)addDefaultChatView {
    ChatViewController * controller = [ChatViewController new];
    [self addControllerAndSetAutoLayout:controller];
    [controller connectToChatWithJWT:self.JWT chatroomName:self.chatroomName connectionOptions:self.chatroomConnectionOptions];
}

- (void)addCustomChatView {
    ChatExampleViewController * chatExampleViewController = [ChatExampleViewController new];
    ChatStickerExampleViewController * controller =
    [ChatStickerExampleViewController viewControllerWithChatViewController:chatExampleViewController];
    controller.stickerViewShowingHeight = 180;
    [self addControllerAndSetAutoLayout:controller];
    [controller connectToChatWithJWT:self.JWT chatroomName:self.chatroomName connectionOptions:self.chatroomConnectionOptions];
}

- (void)addECommerceChatView {
    ECommerceChatViewController *controller = [ECommerceChatViewController new];
    [self addControllerAndSetAutoLayout:controller];
    [controller connectToChatWithJWT:self.JWT chatroomName:self.chatroomName connectionOptions:self.chatroomConnectionOptions];
}

- (void)addStreamingView {
    StreamingViewController * controller = [StreamingViewController new];
    self.contentViewController = controller;
    controller.JWT = self.JWT;
    [self addControllerAndSetAutoLayout:controller];
}

- (void)addControllerAndSetAutoLayout:(UIViewController *)controller {
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.view addSubview:controller.view];
    controller.view.clipsToBounds = YES;
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary * views = @{@"controllerView": controller.view};
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[controllerView]|"
                                                          options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[controllerView]|"
                                                          options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
