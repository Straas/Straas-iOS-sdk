//
//  QRCodeScannerViewController.m
//  LFLiveKitSample
//
//  Created by shihwen.wang on 2017/8/18.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#import "STSQRCodeScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface STSQRCodeScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, nullable) AVCaptureSession * captureSession;
@property (nonatomic, nullable) AVCaptureVideoPreviewLayer * videoPreviewLayer;
@property (nonatomic, nullable) UIView * qrCodeFrameView;
@property (nonatomic, nullable) UIView * videoView;
@property (nonatomic, nullable) UILabel * hintLabel;
@property (nonatomic, nullable) UIView * containerView;
@property (nonatomic, nullable) UIButton * closeButton;
@property (nonatomic, nullable) NSLayoutConstraint * containerTopConstraint;
@end

@implementation STSQRCodeScannerViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScan];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
        self.containerTopConstraint.constant = isPortrait ? 20 : 0;
        [self updateVideoOrientation];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.videoPreviewLayer.frame = self.videoView.layer.bounds;
    }];
}

#pragma mark -

- (void)startScan {
    if (self.captureSession) {
        return;
    }
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError * error;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSString * title = @"Unable to start scanning.";
        NSString * message = [NSString stringWithFormat:@"Error: %@", error];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:
         [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    self.captureSession = [AVCaptureSession new];
    [self.captureSession addInput:input];

    AVCaptureMetadataOutput * output = [AVCaptureMetadataOutput new];
    [self.captureSession addOutput:output];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];

    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.videoView.layer addSublayer:self.videoPreviewLayer];
    self.videoPreviewLayer.frame = self.videoView.layer.bounds;
    [self updateVideoOrientation];
    [self.captureSession startRunning];
}

- (void)stopScan {
    [self.captureSession stopRunning];
    self.videoPreviewLayer = nil;
    self.captureSession = nil;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Manage subviews

- (void)addSubviews {
    [self addContainerView];
    [self addVideoView];
    [self addScanHintLabel];
    [self addCloseButton];
    [self addQRCodeFrameView];
}

- (void)addContainerView {
    UIView * containerView = [UIView new];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    containerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:containerView];
    self.containerView = containerView;

    NSArray * constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[containerView]-(0)-|"
                                            options:0
                                            metrics:nil
                                              views:@{@"containerView": containerView}];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[containerView]-(0)-|"
                                            options:0
                                            metrics:nil
                                              views:@{@"containerView": containerView}];
    [NSLayoutConstraint activateConstraints:constraints];

    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    CGFloat top = isPortrait ? 20 : 0;
    NSLayoutConstraint * constraint =
    [NSLayoutConstraint constraintWithItem:containerView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:top];
    self.containerTopConstraint = constraint;
    self.containerTopConstraint.active = YES;
}

- (void)addVideoView {
    if (!self.containerView) {
        return;
    }
    UIView * videoView = [UIView new];
    videoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:videoView];
    self.videoView = videoView;

    NSArray * constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[videoView]-(0)-|"
                                            options:0
                                            metrics:nil
                                              views:@{@"videoView": videoView}];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[videoView]-(0)-|"
                                            options:0
                                            metrics:nil
                                              views:@{@"videoView": videoView}];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)addScanHintLabel {
    if (!self.containerView) {
        return;
    }
    UILabel * label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"Scan QR code.";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:label];

    NSArray * constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[label]-(10)-|"
                                            options:0
                                            metrics:nil
                                              views:@{@"label": label}];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(30)]-(20)-|"
                                            options:0
                                            metrics:nil
                                              views:@{@"label": label}];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)addCloseButton {
    if (!self.containerView) {
        return;
    }
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setImage:[UIImage imageNamed:@"nav-icon-close_n"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton = button;
    [self.containerView addSubview:button];
    NSArray * constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[button(44)]"
                                            options:0
                                            metrics:nil
                                              views:@{@"button": button}];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[button(44)]"
                                            options:0
                                            metrics:nil
                                              views:@{@"button": button}];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)addQRCodeFrameView {
    UIView * qrCodeFrameView = [UIView new];
    qrCodeFrameView.layer.borderColor = [UIColor greenColor].CGColor;
    qrCodeFrameView.layer.borderWidth = 2;
    [self.view addSubview:qrCodeFrameView];
    self.qrCodeFrameView = qrCodeFrameView;
}

- (void)updateVideoOrientation {
    if ([self.videoPreviewLayer.connection isVideoOrientationSupported]) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft:
                videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            case UIInterfaceOrientationLandscapeRight:
                videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            default:
                break;
        }
        [self.videoPreviewLayer.connection setVideoOrientation:videoOrientation];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count] == 0) {
        self.qrCodeFrameView.frame = CGRectZero;
        return;
    }
    AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects[0];
    if (metadataObject.type == AVMetadataObjectTypeQRCode) {
        NSString * qrCode = metadataObject.stringValue;
        if (qrCode) {
            AVMetadataObject * qrCodeObject =
            [self.videoPreviewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            self.qrCodeFrameView.frame = qrCodeObject.bounds;
            [self.delegate scanner:self didGetQRCode:qrCode];
        }
    }
}

@end
