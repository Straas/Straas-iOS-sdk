//
//  DetailViewController.m
//  VideoChat
//
//  Created by Luke Jang on 8/26/16.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import "DetailViewController.h"
#import "ChatExampleViewController.h"
#import "ECommerceChatViewController.h"
#import "ChatStickerExampleViewController.h"
#import "STSStreamingViewController.h"
#import "StreamingFiltersViewController.h"
#import "STSPlayerViewController.h"
#import "STSConstant.h"
#import <VideoChat-Swift.h>

NSString * const STSPlayerServiceBasicPlayerViewKeyword = @"StraaS.io PlayerView";
NSString * const STSMessagingServiceKeyword = @"StraaS.io default chatroom";
NSString * const STSMessagingServiceCustomUIKeyword = @"StraaS.io customed chatroom";
NSString * const STSMessagingServiceECommerceUIKeyword = @"StraaS.io ECommerce chatroom";
NSString * const STSStreamingServiceKeyword = @"StraaS.io streaming";
NSString * const STSStreamingFiltersServiceKeyword = @"StraaS.io streaming filters";
NSString * const STSStreamingNewServiceKeyword = @"StraaS.io new streaming";

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
    if ([self.detailItem isEqualToString:STSStreamingFiltersServiceKeyword]) {
        [self addStreamingFiltersView];
    }
    if ([self.detailItem isEqualToString:STSPlayerServiceBasicPlayerViewKeyword]) {
        [self addBasicPlayerView];
    }
    if ([self.detailItem isEqualToString:STSStreamingNewServiceKeyword]) {
        [self addNewStreamingView];
    }
}

- (void)addBasicPlayerView {
    STSPlayerViewController * controller = [STSPlayerViewController viewControllerFromStoryboard];
    controller.JWT = self.JWT;
    [self addControllerAndSetAutoLayout:controller];
}

- (void)addDefaultChatView {
    ChatViewController * controller = [ChatViewController new];
    [self addControllerAndSetAutoLayout:controller];
    [controller connectToChatWithJWT:self.JWT chatroomName:self.chatroomName];
}

- (void)addCustomChatView {
    ChatExampleViewController * chatExampleViewController = [ChatExampleViewController new];
    ChatStickerExampleViewController * controller =
    [ChatStickerExampleViewController viewControllerWithChatViewController:chatExampleViewController];
    controller.stickerViewShowingHeight = 180;
    [self addControllerAndSetAutoLayout:controller];
    [controller connectToChatWithJWT:self.JWT chatroomName:self.chatroomName];
}

- (void)addECommerceChatView {
    ECommerceChatViewController *controller = [ECommerceChatViewController new];
    [self addControllerAndSetAutoLayout:controller];
    [controller connectToChatWithJWT:self.JWT chatroomName:self.chatroomName];
}

- (void)addStreamingView {
    STSStreamingViewController * controller = [STSStreamingViewController viewControllerFromStoryboard];
    [self addControllerAndSetAutoLayout:controller];
}

- (void)addStreamingFiltersView {
    StreamingFiltersViewController * controller = [StreamingFiltersViewController viewControllerFromStoryboard];
    [self addControllerAndSetAutoLayout:controller];
}

- (void)addControllerAndSetAutoLayout:(UIViewController *)controller {
    [self addChildViewController:controller];
    self.contentViewController = controller;
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

- (void)addNewStreamingView {
    STSNewStreamingViewController * controller = [STSNewStreamingViewController viewControllerFromStoryboard];
    [self addControllerAndSetAutoLayout:controller];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
