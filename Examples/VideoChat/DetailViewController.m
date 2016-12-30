//
//  DetailViewController.m
//  VideoChat
//
//  Created by Luke Jang on 8/26/16.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import "DetailViewController.h"
#import "ChatStickerViewController.h"
#import "StreamingViewController.h"

NSString * const STSMessagingServiceKeyword = @"StraaS.io chat room";
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
        [self addChatView];
    }
    if ([self.detailItem isEqualToString:STSStreamingServiceKeyword]) {
        [self addStreamingView];
    }
}

- (void)addChatView {
    ChatStickerViewController * controller = [ChatStickerViewController new];
    controller.JWT = self.JWT;
    controller.chatroomName = <#PUT_YOUR_CHATROOMNAME_HERE#>;
    controller.connectionOptions = <#PUT_YOUR_CONNECTIONOPTIONS_HERE#>;
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.view addSubview:controller.view];
    controller.view.clipsToBounds = YES;
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary * views = @{@"chatRoom": controller.view};
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[chatRoom]|"
                                                          options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[chatRoom]|"
                                                          options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)addStreamingView {
    StreamingViewController * controller = [StreamingViewController new];
    self.contentViewController = controller;
    controller.JWT = self.JWT;
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.view addSubview:controller.view];
    controller.view.clipsToBounds = YES;
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary * views = @{@"streamingView": controller.view};
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[streamingView]|"
                                                          options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[streamingView]|"
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
