//
//  STSCircallTokenViewControllerㄩ.m
//  StraaSDemoApp
//
//  Created by Allen and Kim on 2018/5/2.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import "STSCircallTokenViewController.h"
#import "STSCircallSingleVideoCallViewController.h"
#import "STSQRCodeScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

NSString * const kUserDefaultsKeyCircallTokenForSingleVideoCall = @"kUserDefaultsKeyCircallTokenForSingleVideoCall";
NSString * const kUserDefaultsKeyCircallTokenForViewer = @"kUserDefaultsKeyCircallTokenForViewer";
NSString * const kUserDefaultsKeyCircallTokenForHost = @"kUserDefaultsKeyCircallTokenForHost";
NSString * const kUserDefaultsKeyRTSPUrl = @"kUserDefaultsKeyRTSPUrl";

@interface STSCircallTokenViewController () <UITextFieldDelegate, STSQRCodeScannerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *connectRoomButton;
@property (weak, nonatomic) IBOutlet UITextField *circallTokenTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@end

@implementation STSCircallTokenViewController

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    STSCircallTokenViewController * vc =
    [storyboard instantiateViewControllerWithIdentifier:@"STSCircallTokenViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.circallTokenTextField.delegate = self;
    self.urlTextField.delegate = self;

    [self makeBackgroundColorGradient];

    self.connectRoomButton.layer.cornerRadius = 5.0;

    self.circallTokenTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    UIColor *color = [UIColor colorWithRed:120./255. green:193./255. blue:196./255. alpha:1];
    self.circallTokenTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請貼上串流碼" attributes:@{NSForegroundColorAttributeName: color}];

    self.urlTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.urlTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請貼上 RTSP URL" attributes:@{NSForegroundColorAttributeName: color}];

    NSString *cachedCircallToken;
    switch (self.type) {
        case STSCircallTokenViewControllerTypeIPCamBroadcastingHost:
            [self.connectRoomButton setTitle:@"進入" forState:UIControlStateNormal];
            cachedCircallToken = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:kUserDefaultsKeyCircallTokenForHost];
            break;
        case STSCircallTokenViewControllerTypeIPCamBroadcastingViewer:
            [self.connectRoomButton setTitle:@"進入" forState:UIControlStateNormal];
            cachedCircallToken = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:kUserDefaultsKeyCircallTokenForViewer];
            self.urlView.hidden = YES;
            break;
        case STSCircallTokenViewControllerTypeSingleVideoCall:
            cachedCircallToken = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:kUserDefaultsKeyCircallTokenForSingleVideoCall];
            self.urlView.hidden = YES;
            break;
    }

    self.circallTokenTextField.text = cachedCircallToken;
    NSString *cachedUrl = [[NSUserDefaults standardUserDefaults]
                           stringForKey:kUserDefaultsKeyRTSPUrl];
    self.urlTextField.text = cachedUrl;
}

#pragma mark - Accessors

#pragma mark - IBAction

- (IBAction)connectRoomButtonDidPressed:(id)sender {
    self.errorMessageLabel.hidden = YES;

    if (![[self class] isCircallTokenValid:self.circallTokenTextField.text]) {
        self.errorMessageLabel.text = @"Circall token 錯誤";
        self.errorMessageLabel.hidden = NO;
        return;
    }

    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    if (!url) {
        self.errorMessageLabel.text = @"RTSP URL 錯誤";
        self.errorMessageLabel.hidden = NO;
        return;
    }

    switch (self.type) {
        case STSCircallTokenViewControllerTypeSingleVideoCall:
        default:
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.circallTokenTextField.text forKey:kUserDefaultsKeyCircallTokenForSingleVideoCall];
            [self requestCameraAndMicrophonePermissionsWithSuccessHandler:^{
                STSCircallSingleVideoCallViewController *vc = [STSCircallSingleVideoCallViewController viewControllerFromStoryboard];
                dispatch_async(dispatch_get_main_queue(), ^{
                    vc.circallToken = self.circallTokenTextField.text;
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }];
        }
            break;
        case STSCircallTokenViewControllerTypeIPCamBroadcastingViewer:
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.circallTokenTextField.text forKey:kUserDefaultsKeyCircallTokenForViewer];
            STSCircallIPCamBroadcastingViewerViewController *vc = [STSCircallIPCamBroadcastingViewerViewController viewControllerFromStoryboard];
            vc.circallToken = self.circallTokenTextField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case STSCircallTokenViewControllerTypeIPCamBroadcastingHost:
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.circallTokenTextField.text forKey:kUserDefaultsKeyCircallTokenForHost];
            STSCircallIPCamBroadcastingHostViewController *vc = [STSCircallIPCamBroadcastingHostViewController viewControllerFromStoryboard];
            vc.circallToken = self.circallTokenTextField.text;
            vc.url = url;
            [[NSUserDefaults standardUserDefaults] setObject:self.urlTextField.text forKey:kUserDefaultsKeyRTSPUrl];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

- (IBAction)scanQRCodeButtonDidPress:(id)sender {
    self.scanQRCodeButtonSender = sender;
    [self requestCameraAndMicrophonePermissionsWithSuccessHandler:^{
        STSQRCodeScannerViewController *vc = [STSQRCodeScannerViewController new];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

#pragma mark - Private Methods

- (void)makeBackgroundColorGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);

    struct CGColor *circallLightGreenColor = [[UIColor colorWithRed:2./255. green:113./255. blue:117./255. alpha:1] CGColor];
    struct CGColor *circallDarkGreenColor = [[UIColor colorWithRed:81./255. green:192./255. blue:194./255. alpha:1] CGColor];
    gradient.colors = [NSArray arrayWithObjects:(__bridge id)circallDarkGreenColor, (__bridge id)circallLightGreenColor, nil];
    [self.backgroundView.layer addSublayer:gradient];
}

- (void)requestCameraAndMicrophonePermissionsWithSuccessHandler:(void (^)())successHandler {
    self.errorMessageLabel.text = @"";
    self.errorMessageLabel.hidden = YES;

    __weak STSCircallTokenViewController * weakSelf = self;

    void (^requestAccessFailureHandler)(NSString *errorMessage) = ^(NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.errorMessageLabel.text = errorMessage;
            weakSelf.errorMessageLabel.hidden = NO;
        });
    };

    void (^audioAccessHandler)(BOOL) = ^(BOOL granted) {
        if (!granted) {
            requestAccessFailureHandler(@"麥克風授權失敗，請至設定頁重新開啟。");
            return;
        }
        successHandler();
    };
    void (^videoAccessHandler)(BOOL) = ^(BOOL granted) {
        if (!granted) {
            requestAccessFailureHandler(@"攝影機授權失敗，請至設定頁重新開啟。");
            return;
        }
        [weakSelf requestAccessForAudioWithCompletionHandler:audioAccessHandler];
    };

    switch (self.type) {
        case STSCircallTokenViewControllerTypeIPCamBroadcastingViewer:
            if (successHandler) {
                successHandler();
            }
            break;
        case STSCircallTokenViewControllerTypeSingleVideoCall:
        case STSCircallTokenViewControllerTypeIPCamBroadcastingHost:
        default:
            [self requestAccessForVideoWithCompletionHandler:videoAccessHandler];
            break;
    }
}

- (void)requestAccessForVideoWithCompletionHandler:(void (^)(BOOL granted))handler {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:handler];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            handler(YES);
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        default:
            handler(NO);
            break;
    }
}

- (void)requestAccessForAudioWithCompletionHandler:(void (^)(BOOL granted))handler {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:handler];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            handler(YES);
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        default:
            handler(NO);
            break;
    }
}

+ (BOOL)isCircallTokenValid:(NSString *)circallToken {
    if (circallToken == nil || circallToken.length == 0) {
        return false;
    }

    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:circallToken options:0];

    if (decodedData == nil) {
        return NO;
    }

    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:decodedData options:0 error:&error];
    if (error != nil) {
        return NO;
    } else if (jsonObject == nil || jsonObject[@"host"] == nil) {
        return NO;
    }

    return YES;
}

#pragma mark - UITextfieldDelegate Methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - STSQRCodeScannerViewControllerDelegate

- (void)scanner:(STSQRCodeScannerViewController *)scanner didGetQRCode:(NSString *)qrCode {
    if (self.scanQRCodeButtonSender == self.scanQRCodeButton) {
        self.circallTokenTextField.text = qrCode;
    } else if (self.scanQRCodeButtonSender == self.scanUrlButton) {
        self.urlTextField.text = qrCode;
    }
    self.scanQRCodeButtonSender = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
