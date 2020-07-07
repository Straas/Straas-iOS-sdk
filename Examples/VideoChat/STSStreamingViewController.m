//
//  STSStreamingViewController.m
//  StraaS
//
//  Created by shihwen.wang on 2016/10/28.
//  Copyright © 2020年 StraaS.io. All rights reserved.
//

#import "STSStreamingViewController.h"
#import "UIViewController+Keyboard.h"
#import "NSLayoutConstraint+STSUtility.h"
#import <StraaSStreamingSDK/StraaSStreamingSDK.h>
#import <StraaSCoreSDK/StraaSCoreSDK.h>
#import <GPUImage/GPUImageFramework.h>
#import "STSQRCodeScannerViewController.h"
#import "STSConstant.h"
#import "UIColor+STSColor.h"

typedef NS_ENUM(NSUInteger, STSStreamingFilterType){
    STSStreamingFilterTypeNone,
    STSStreamingFilterTypeGray,
    STSStreamingFilterTypeRed,
};

NSUInteger const kSTSStreamingFilterCount = 3;

NSString * const kUserDefaultsKeyStreamKey = @"kUserDefaultsKeyStreamKey";
NSString * const kUserDefaultsKeyStreamURL = @"kUserDefaultsKeyStreamURL";

@interface STSStreamingViewController()<UITextFieldDelegate, STSStreamingManagerDelegate, STSQRCodeScannerViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITextField *titleField;
@property (nonatomic, weak) IBOutlet UITextField * streamKeyField;
@property (nonatomic, weak) IBOutlet UIButton * streamKeyScanButton;
@property (nonatomic, weak) IBOutlet UISegmentedControl * streamWayControl;
@property (nonatomic, weak) IBOutlet UIButton * startButton;
@property (nonatomic, weak) IBOutlet UIButton * cameraButton;
@property (nonatomic, weak) IBOutlet UIButton * flipOutputButton;
@property (weak, nonatomic) IBOutlet UIButton * audioButton;
@property (nonatomic, weak) IBOutlet UILabel * statusLabel;
@property (nonatomic, weak) IBOutlet UILabel * bitrateLabel;
@property (nonatomic, weak) IBOutlet UILabel * fpsLabel;
@property (nonatomic, weak) IBOutlet UIView * previewView;
@property (nonatomic, weak) IBOutlet UIView * settingView;
@property (nonatomic, weak) IBOutlet UIView * streamKeySettingView;
@property (nonatomic) STSStreamingFilterType filterType;
@property (nonatomic) STSStreamingManager *streamingManager;
@property (nonatomic) BOOL shouldPrepareAgain;
@property (nonatomic, assign) STSStreamWay streamWay;
@end

@implementation STSStreamingViewController

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    STSStreamingViewController * vc =
    [storyboard instantiateViewControllerWithIdentifier:@"STSStreamingViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self hideNavigationControllerIfNecessary];
    __weak STSStreamingViewController * weakSelf = self;
    self.settingView.hidden = YES;
    self.shouldPrepareAgain = NO;

    [STSApplication configureApplication:^(BOOL success, NSError *error) {
        if (success) {
            [self prepare];
            [self updateMirrorButton];
        } else {
            NSString * errorMsg =
            [NSString stringWithFormat: @"Configure application failed with error: %@", error];
            [weakSelf onErrorWithTitle:@"Error" message:errorMsg];
        }
    }];

    NSString *cachedStreamKey = [[NSUserDefaults standardUserDefaults]
                              stringForKey:kUserDefaultsKeyStreamKey];
    self.streamKeyField.text = cachedStreamKey;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouldPrepareAgain) {
        self.shouldPrepareAgain = NO;
        [self prepare];
    }
}

- (BOOL)shouldAutorotate {
    if (self.streamingManager.state == STSStreamingStateConnecting || self.streamingManager.state == STSStreamingStateStreaming ||
        self.streamingManager.state == STSStreamingStateDisconnecting) {
        return NO;
    }
    return YES;
}

#pragma mark - IBAction

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
    [self updateFlipOutputButtonVisibility];
}

- (IBAction)startButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if (self.streamingManager.state == STSStreamingStatePrepared) {
        self.statusLabel.text = @"connecting";
        [self enableAllInputs:NO];
        switch (self.streamWayControl.selectedSegmentIndex) {
            case STSStreamWayLiveEvent:
            {
                NSString *title = self.titleField.text;
                [self startStreamingWithTitle:title];
                break;
            }
            case STSStreamWayStreamKey:
            {
                NSString *streamKey = self.streamKeyField.text;
                [self startStreamingWithStreamKey:streamKey];
                break;
            }
        }
        return;
    }
    if (self.streamingManager.state == STSStreamingStateStreaming) {
        self.statusLabel.text = @"disconnecting";
        self.startButton.enabled = NO;
        [self stopStreaming];
    }
}

- (IBAction)filterButtonPressed:(UIButton *)sender {
    if (!self.streamingManager) {
        return;
    }
    self.filterType = (self.filterType + 1) % kSTSStreamingFilterCount;
    [self updateFilter:self.filterType];
}

- (IBAction)flipOutputButtonPressed:(id)sender {
    if (self.streamingManager.captureDevicePosition != AVCaptureDevicePositionFront) {
        return;
    }
    self.streamingManager.flipFrontCameraOutputHorizontally = !self.streamingManager.flipFrontCameraOutputHorizontally;
    [self updateMirrorButton];
}

- (void)updateMirrorButton {
    if (self.streamingManager.flipFrontCameraOutputHorizontally) {
        [self.flipOutputButton setTitleColor:[UIColor STSBlueButtonColor] forState:UIControlStateNormal];
    } else {
        [self.flipOutputButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)streamWayControlValueChanged:(id)sender {
    UISegmentedControl * streamWayControl = (UISegmentedControl *)sender;
    switch (streamWayControl.selectedSegmentIndex) {
        case STSStreamWayLiveEvent:
            self.streamWay = STSStreamWayLiveEvent;
            break;
        case STSStreamWayStreamKey:
            self.streamWay = STSStreamWayStreamKey;
            break;
    }

    self.titleField.hidden = !(streamWayControl.selectedSegmentIndex == STSStreamWayLiveEvent);
    self.streamKeySettingView.hidden = !(streamWayControl.selectedSegmentIndex == STSStreamWayStreamKey);
    [self.view endEditing:YES];
}

- (IBAction)streamKeyScanButtonPressed:(id)sender {
    STSQRCodeScannerViewController * vc = [STSQRCodeScannerViewController new];
    vc.delegate = self;
    vc.streamWay = self.streamWay;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)audioButtonPressed:(id)sender {
    self.streamingManager.audioEnabled = !self.streamingManager.audioEnabled;
    if (!self.streamingManager.audioEnabled) {
        [self.audioButton setTitleColor:[UIColor colorWithRed:0.0 green:100./255. blue:255./255. alpha:1] forState:UIControlStateNormal];
    } else {
        [self.audioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
#pragma mark - private methods

- (void)prepare {
    [self setupStreamingManager];
    if (!self.streamingManager) {
        return;
    }
    __weak STSStreamingViewController * weakSelf = self;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    STSStreamingPrepareConfig * config = [STSStreamingPrepareConfig new];
    config.outputImageOrientation = orientation;
    config.maxResolution = STSStreamingResolution720p;
    config.fitAllCamera = NO;
    [self.streamingManager prepareWithPreviewView:self.previewView
                                    configuration:config
                                          success:^(CGSize outputSize) {
                                              weakSelf.startButton.enabled = YES;
                                              weakSelf.settingView.hidden = NO;
                                              NSLog(@"prepare success with output size: %@", NSStringFromCGSize(outputSize));
                                          } failure:^(NSError * error) {
                                              weakSelf.settingView.hidden = YES;
                                              NSString * errorMsg =
                                              [NSString stringWithFormat:@"Prepare failed with error: %@", error];
                                              [weakSelf onErrorWithTitle:@"Error" message:errorMsg];
                                          }];
}

- (void)setupStreamingManager {
    if (self.streamingManager) {
        return;
    }
    self.streamingManager = [STSStreamingManager streamingManagerWithJWT:[self memberJWT]];
    self.streamingManager.delegate = self;
    self.streamingManager.captureDevicePosition = AVCaptureDevicePositionBack;
    self.streamingManager.flipFrontCameraOutputHorizontally = YES;
    [self updateFlipOutputButtonVisibility];
    self.filterType = STSStreamingFilterTypeNone;
    [self updateFilter:self.filterType];
}

- (void)startStreamingWithTitle:(NSString *)title {
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([title length] == 0) {
        [self onErrorWithTitle:@"Error" message:@"The tile should not be empty."];
        return;
    }
    STSStreamingLiveEventConfig * configuration =
    [STSStreamingLiveEventConfig liveEventConfigWithTitle:title listed:YES];
//    configuration.synopsis = <#SYNOPSIS_OF_THE_LIVE_EVENT#>;
//    configuration.vodAvailable = YES;
//    configuration.vodListed = YES;
//    configuration.tags = @[@"iOS SDK test"];
//    configuration.categoryId = @(106);
//    configuration.vodMerge = YES;
//    configuration.dvrEnabled = YES;
//    configuration.profile = STSStreamingProfile1080pAndSource;
    __weak STSStreamingViewController * weakSelf = self;
    [self.streamingManager createLiveEventConfguration:configuration success:^(NSString * liveId) {
        [weakSelf startStreamingWithLiveId:liveId];
    } failure:^(NSError * error, NSString * liveId) {
        if ([error.domain isEqualToString:STSStreamingErrorDomain]
            && error.code == STSStreamingErrorCodeLiveCountLimit) {
            NSLog(@"Current member has an unended live event, try to start streaming by reusing that event. liveId=%@", liveId);
            [weakSelf startStreamingWithLiveId:liveId];
            return;
        }
        NSString * errorTitle = @"STSStreamingManager failed to create a new live event.";
        NSString * errorMsg = [NSString stringWithFormat: @"Error: %@\nLive id=%@", error, liveId];
        [weakSelf onErrorWithTitle:errorTitle message:errorMsg];
    }];
}

- (void)startStreamingWithLiveId:(NSString *)liveId {
    __weak STSStreamingViewController * weakSelf = self;
    [self.streamingManager startStreamingWithliveId:liveId success:^{
        NSLog(@"Did start streaming: liveId=%@", liveId);
        [weakSelf didStartStreaming];
    } failure:^(NSError * error) {
        if ([error.domain isEqualToString:STSStreamingErrorDomain]
            && error.code == STSStreamingErrorCodeEventExpired) {
            NSLog(@"The live event expired, try to end it and restart streaming. liveId=%@", liveId);
            [weakSelf endLiveEvent:liveId success:^{
                NSString *title = weakSelf.titleField.text;
                [weakSelf startStreamingWithTitle:title];
            } failure:^(NSError * endLiveEventError) {
                NSString * errorTitle =
                [NSString stringWithFormat:
                 @"There is an unended live event(liveId = %@), but STSStreamingManager failed to end it.", liveId];
                NSString * errorMsg = [NSString stringWithFormat: @"Error: %@", error];
                [weakSelf onErrorWithTitle:errorTitle message:errorMsg];
            }];
            return;
        }
        NSString * errorTitle = @"STSStreamingManager failed to start streaming.";
        NSString * errorMsg = [NSString stringWithFormat: @"Error: %@.\nLive id = %@", error, liveId];
        [weakSelf onErrorWithTitle:errorTitle message:errorMsg];
    }];
}

- (void)startStreamingWithStreamKey:(NSString *)streamKey {
    if ([streamKey length] == 0) {
        [self onErrorWithTitle:@"Error" message:@"The stream key should not be empty."];
        return;
    }
    __weak STSStreamingViewController * weakSelf = self;
    [self.streamingManager startStreamingWithStreamKey:streamKey success:^{
        NSLog(@"Did start streaming with given stream key.");
        [weakSelf didStartStreaming];
    } failure:^(NSError * error) {
        NSString * errorTitle = @"STSStreamingManager failed to start streaming with given stream key.";
        NSString * errorMsg = [NSString stringWithFormat: @"Error: %@", error];
        [weakSelf onErrorWithTitle:errorTitle message:errorMsg];
    }];
}

- (void)didStartStreaming {
    self.statusLabel.text = @"start";
    self.startButton.enabled = YES;
    [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self updateUIWithBitrate:0];
    [self updateUIWithFPS:0];
}

- (void)stopStreaming {
    __weak STSStreamingViewController * weakSelf = self;
    [self.streamingManager stopStreamingWithSuccess:^(NSString * liveId) {
        NSLog(@"Did stop streaming: liveId=%@", liveId);
        weakSelf.statusLabel.text = @"stop";
        [weakSelf enableAllInputs:YES];
        [weakSelf.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self updateUIWithBitrate:0];
        [self updateUIWithFPS:0];
    } failure:^(NSError * error, NSString * liveId) {
        NSString * errorMsg =
        [NSString stringWithFormat: @"Failed to stop streaming with error: %@, live id=%@", error, liveId];
        [weakSelf onErrorWithTitle:@"Error" message:errorMsg];
    }];
}

- (void)endLiveEvent:(NSString *)liveId success:(void(^)(void))success failure:(void(^)(NSError * error))failure {
    [self.streamingManager cleanLiveEvent:liveId success:^{
        NSLog(@"Live event did end: liveId=%@", liveId);
        if (success) {
            success();
        }
    } failure:^(NSError * error){
        NSLog(@"Failed to end live event: liveId=%@", liveId);
        if (failure) {
            failure(error);
        }
    }];
}

- (NSString *)memberJWT {
    #warning It is a placeholder, should be replaced with a member JWT.
    return kStraaSProdMemberJWT;
}

- (void)onErrorWithTitle:(NSString *)errorTitle message:(NSString *)errorMessage {
    [self showAlertWithTitle:errorTitle message:errorMessage];
    self.statusLabel.text = @"error";
    [self enableAllInputs:YES];
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (void)updateFilter:(STSStreamingFilterType)filterType {
    GPUImageFilter *filter;
    switch (filterType) {
        case STSStreamingFilterTypeGray:
            filter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case STSStreamingFilterTypeRed:
        {
            filter = [[GPUImageRGBFilter alloc] init];
            ((GPUImageRGBFilter *)filter).green = 0.5;
            ((GPUImageRGBFilter *)filter).blue = 0.5;
            break;
        }
        case STSStreamingFilterTypeNone:
        default:
            filter = nil;
            break;
    }

    if (!filter) {
        self.streamingManager.filterGroup = nil;
        return;
    }
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    [filterGroup addFilter:filter];
    [filterGroup setInitialFilters:@[filter]];
    [filterGroup setTerminalFilter:filter];
    self.streamingManager.filterGroup = filterGroup;
}

- (void)updateFlipOutputButtonVisibility {
    self.flipOutputButton.hidden = self.streamingManager.captureDevicePosition == AVCaptureDevicePositionBack;
}

- (void)updateUIWithBitrate:(NSUInteger)bitrate {
    self.bitrateLabel.text = [NSString stringWithFormat:@"%ld Kbps", (long)(bitrate/1000)];
}

- (void)updateUIWithFPS:(CGFloat)fps {
    self.fpsLabel.text = [NSString stringWithFormat:@"%.1f fps", fps];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:
     [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)enableAllInputs:(BOOL)enabled {
    self.startButton.enabled = enabled;
    self.streamKeyField.enabled = enabled;
    self.streamKeyScanButton.enabled = enabled;
    self.titleField.enabled = enabled;
    self.streamWayControl.enabled = enabled;
}

#pragma mark - UIViewController interface rotation methods

- (void)hideNavigationControllerIfNecessary {
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        return;
    }
    BOOL isLandscape =
    UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    self.navigationController.navigationBarHidden = isLandscape;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (self.isViewLoaded && self.view.window) {
            [self prepare];
        } else {
            self.shouldPrepareAgain = YES;
        }
        if (newCollection.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
            return;
        }
        [self hideNavigationControllerIfNecessary];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.titleField]) {
        [self.view endEditing:YES];
    }
    if ([textField isEqual:self.streamKeyField]) {
        [self.view endEditing:YES];
    }
    return NO;
}

#pragma mark - STSStreamingManagerDelegate

- (void)streamingManager:(STSStreamingManager *)streamingManager
                 onError:(NSError *)error
                  liveId:(NSString * _Nullable)liveId
{
    NSString * errorTitle = @"STSStreamingManager encounters an error.";
    NSString * errorMsg = [NSString stringWithFormat: @"Error: %@.\nLive id = %@", error, liveId];
    [self onErrorWithTitle:errorTitle message:errorMsg];
}

- (void)streamingManager:(STSStreamingManager *)streamingManager didUpdateStreamingStatsReport:(STSStreamingStatsReport *)statsReport {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUIWithBitrate:statsReport.currentBitrate];
        [self updateUIWithFPS:statsReport.currentFPS];
    });
}

#pragma mark - STSQRCodeScannerViewControllerDelegate

- (void)scanner:(STSQRCodeScannerViewController *)scanner didGetQRCode:(NSString *)qrCode {
    switch (scanner.streamWay) {
        case STSStreamWayLiveEvent:
            break;
        case STSStreamWayStreamKey:
            self.streamKeyField.text = qrCode;
            [[NSUserDefaults standardUserDefaults] setObject:qrCode forKey:kUserDefaultsKeyStreamKey];
            break;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
