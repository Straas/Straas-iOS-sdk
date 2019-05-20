//
//  StreamingFiltersViewController.m
//  VideoChat
//
//  Created by Allen on 2019/1/28.
//  Copyright © 2019 StraaS.io. All rights reserved.
//

#import "StreamingFiltersViewController.h"
#import <StraaSStreamingSDK/StraaSStreamingSDK.h>
#import <StraaSCoreSDK/StraaSCoreSDK.h>
#import "UIColor+STSColor.h"

@interface StreamingFiltersViewController() <STSStreamingManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *skinBeautifyButton;

@property (nonatomic) STSStreamingManager *streamingManager;

@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
@property (weak, nonatomic) IBOutlet UISlider *smoothnessSlider;

@property (strong, nonatomic) STSSkinBeautifyFilter *skinBeautifyFilter;
@property (strong, nonatomic) GPUImageFilterGroup *skinBeautifyFilterGroup;

@property (nonatomic, assign) BOOL isSkinBeautifyFilterOn;

@end

@implementation StreamingFiltersViewController

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StreamingFiltersViewController * vc =
    [storyboard instantiateViewControllerWithIdentifier:@"StreamingFiltersViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self hideNavigationControllerIfNecessary];

    self.smoothnessSlider.maximumValue = 2.0;

    self.skinBeautifyFilter = [STSSkinBeautifyFilter filter];

    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    [filterGroup addFilter:self.skinBeautifyFilter];
    [filterGroup setInitialFilters:@[self.skinBeautifyFilter]];
    [filterGroup setTerminalFilter:self.skinBeautifyFilter];
    self.skinBeautifyFilterGroup = filterGroup;

    self.isSkinBeautifyFilterOn = NO;
    [self updateSkinBeautifyFilter];

    __weak StreamingFiltersViewController * weakSelf = self;
    [STSApplication configureApplication:^(BOOL success, NSError *error) {
        if (success) {
            [self prepare];
        } else {
            NSString * errorMsg =
            [NSString stringWithFormat: @"Configure application failed with error: %@", error];
            [weakSelf onErrorWithTitle:@"Error" message:errorMsg];
        }
    }];
}

- (void)prepare {
    [self setupStreamingManager];
    if (!self.streamingManager) {
        return;
    }
    __weak StreamingFiltersViewController * weakSelf = self;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    STSStreamingPrepareConfig * config = [STSStreamingPrepareConfig new];
    config.outputImageOrientation = orientation;
    config.maxResolution = STSStreamingResolution720p;
    config.fitAllCamera = NO;
    [self.streamingManager prepareWithPreviewView:self.previewView
                                    configuration:config
                                          success:^(CGSize outputSize) {
                                              NSLog(@"prepare success with output size: %@", NSStringFromCGSize(outputSize));
                                              weakSelf.streamingManager.captureDevicePosition = AVCaptureDevicePositionFront;
                                          } failure:^(NSError * error) {
                                              NSString * errorMsg =
                                              [NSString stringWithFormat:@"Prepare failed with error: %@", error];
                                              [weakSelf onErrorWithTitle:@"Error" message:errorMsg];
                                          }];
}

- (void)setupStreamingManager {
    if (self.streamingManager) {
        return;
    }
    self.streamingManager = [STSStreamingManager streamingManagerWithJWT:@""];
    self.streamingManager.delegate = self;
    self.streamingManager.captureDevicePosition = AVCaptureDevicePositionBack;
    self.streamingManager.flipFrontCameraOutputHorizontally = YES;
}

- (void)onErrorWithTitle:(NSString *)errorTitle message:(NSString *)errorMessage {
    [self showAlertWithTitle:errorTitle message:errorMessage];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:
     [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)hideNavigationControllerIfNecessary {
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        return;
    }
    BOOL isLandscape =
    UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    self.navigationController.navigationBarHidden = isLandscape;
}

- (IBAction)cameraButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if (!self.streamingManager) {
        return;
    }
    if (self.streamingManager.captureDevicePosition == AVCaptureDevicePositionFront) {
        self.streamingManager.captureDevicePosition = AVCaptureDevicePositionBack;
    } else {
        self.streamingManager.captureDevicePosition = AVCaptureDevicePositionFront;
    }
}

- (IBAction)skinBeautifyButtonPressed:(id)sender {
    self.isSkinBeautifyFilterOn = !self.isSkinBeautifyFilterOn;
}

- (void)setIsSkinBeautifyFilterOn:(BOOL)isSkinBeautifyFilterOn {
    _isSkinBeautifyFilterOn = isSkinBeautifyFilterOn;

    if (_isSkinBeautifyFilterOn) {
        self.brightnessSlider.enabled = YES;
        self.smoothnessSlider.enabled = YES;
        [self.skinBeautifyButton setTitleColor:[UIColor STSBlueButtonColor] forState:UIControlStateNormal];

        self.streamingManager.filterGroup = self.skinBeautifyFilterGroup;
    } else {
        self.brightnessSlider.enabled = NO;
        self.smoothnessSlider.enabled = NO;
        [self.skinBeautifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        self.streamingManager.filterGroup = nil;
    }
}

- (void)updateSkinBeautifyFilter {
    if (!self.skinBeautifyFilter) {
        return;
    }

    self.skinBeautifyFilter.brightnessLevel = self.brightnessSlider.value;
    self.skinBeautifyFilter.skinSmoothnessLevel = self.smoothnessSlider.value;
}

- (IBAction)brightnessSliderValueChanged:(id)sender {
    [self updateSkinBeautifyFilter];
}

- (IBAction)smoothnessSliderValueChanged:(id)sender {
    [self updateSkinBeautifyFilter];
}

@end
