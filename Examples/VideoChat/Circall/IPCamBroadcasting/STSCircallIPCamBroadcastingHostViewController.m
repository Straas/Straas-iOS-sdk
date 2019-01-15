//
//  STSCircallIPCamBroadcastingHostViewController.m
//  StraaSDemoApp
//
//  Created by Allen on 2018/9/10.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import "STSCircallIPCamBroadcastingHostViewController.h"
#import <StraaSCircallSDK/STSCircallPlayerView.h>
#import <StraaSCircallSDK/STSCircallManager.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <StraaSCircallSDK/STSCircallPublishWithUrlConfig.h>

typedef NS_ENUM(NSUInteger, STSCircallIPCamBroadcastingHostViewControllerState){
    STSCircallIPCamBroadcastingHostViewControllerStateIdle,
    STSCircallIPCamBroadcastingHostViewControllerStateConnecting,
    STSCircallIPCamBroadcastingHostViewControllerStateConnected,
    STSCircallIPCamBroadcastingHostViewControllerStatePublished,
    STSCircallIPCamBroadcastingHostViewControllerStateSubscribed
};

typedef NS_ENUM(NSUInteger, STSCircallIPCamBroadcastingHostViewControllerRecordingState){
    STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle,
    STSCircallIPCamBroadcastingHostViewControllerRecordingStateStarting,
    STSCircallIPCamBroadcastingHostViewControllerRecordingStateRecording
};

@interface STSCircallIPCamBroadcastingHostViewController () <STSCircallManagerDelegate>

@property (weak, nonatomic) IBOutlet STSCircallPlayerView *hostView;
@property (weak, nonatomic) IBOutlet UIImageView *recordingRedDot;
@property (weak, nonatomic) IBOutlet UIButton *recordingButton;

@property (strong, nonatomic) STSCircallManager *circallManager;
@property (assign, nonatomic) STSCircallIPCamBroadcastingHostViewControllerState viewControllerState;
@property (assign, nonatomic) STSCircallIPCamBroadcastingHostViewControllerRecordingState recordingState;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSTimer *recordingRedDotTimer;

@property (strong, nonatomic) NSString *recordingId;

@end

@implementation STSCircallIPCamBroadcastingHostViewController

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    STSCircallIPCamBroadcastingHostViewController * vc =
    [storyboard instantiateViewControllerWithIdentifier:@"STSCircallIPCamBroadcastingHostViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.recordingRedDot.layer.cornerRadius = 5.0;
    self.recordingRedDot.hidden = YES;

    // properties settings
    self.circallManager = [[STSCircallManager alloc] init];
    self.circallManager.delegate = self;

    if (self.circallToken == nil) {
        [self showAlertWithTitle:@"Error" message:@"Circall token is nil"];
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectUntilSubscribe) name:UIApplicationWillEnterForegroundNotification object:nil];

    self.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateIdle;
    self.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle;

    [self connectUntilSubscribe];

    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)dealloc {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)connectUntilSubscribe {

    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alerController = (UIAlertController *)self.presentedViewController;
        [alerController dismissViewControllerAnimated:NO completion:nil];
    }

    // actions
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;

    __weak STSCircallIPCamBroadcastingHostViewController * weakSelf = self;

    void (^subscribeStream)(STSCircallStream * _Nonnull stream) = ^(STSCircallStream * _Nonnull stream) {
        [weakSelf.circallManager subscribeStream:stream success:^(STSCircallStream * _Nonnull stream) {
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateSubscribed;
            weakSelf.hostView.stream = stream;
            [weakSelf.hud hideAnimated:YES];
        } failure:^(STSCircallStream * _Nonnull stream, NSError * _Nonnull error) {
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStatePublished;
            [weakSelf showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"subscribeStream failure, error:%@",error]];
            [weakSelf.hud hideAnimated:YES];
        }];
    };

    void (^publishRTSPUrl)(void) = ^() {
        STSCircallPublishWithUrlConfig *config = [[STSCircallPublishWithUrlConfig alloc] initWithUrl:weakSelf.url];
        [weakSelf.circallManager publishWithUrlConfig:config success:^(STSCircallStream * _Nonnull stream) {
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStatePublished;
            subscribeStream(stream);
        } failure:^(NSError * _Nonnull error) {
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateConnected;
            [weakSelf showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"publishWithConfig failure, error:%@",error]];
            [weakSelf.hud hideAnimated:YES];
        }];
    };

    void (^connect)(void) = ^() {
        [weakSelf.circallManager connectWithCircallToken:self.circallToken success:^{
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateConnected;
            weakSelf.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle;
            publishRTSPUrl();
        } failure:^(NSError * _Nonnull error) {
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateIdle;
            [weakSelf showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"connect room failed with error: %@",error]];
            [weakSelf.hud hideAnimated:YES];
        }];
    };

    [self.circallManager prepareForUrlWithSuccess:^{
        connect();
    } failure:^(NSError * _Nonnull error) {
        [weakSelf showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"prepareForUrlWithSuccess error:%@",error]];
        [weakSelf.hud hideAnimated:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addObserver:self forKeyPath:@"recordingState" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeObserver:self forKeyPath:@"recordingState"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self showAlertWithTitle:title message:message exitOnCompletion:NO];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message exitOnCompletion:(BOOL) exitOnCompletion {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:
     [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault
                            handler: exitOnCompletion ? ^(UIAlertAction *action) {
                                [self leaveOngoingVideoCall];
                            } : nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(recordingState))]) {
        STSCircallIPCamBroadcastingHostViewControllerRecordingState recordingState = [change[@"new"] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithRecordingState:recordingState];
        });
    }
}

- (void)updateUIWithRecordingState:(STSCircallIPCamBroadcastingHostViewControllerRecordingState)recordingState {
    if (recordingState == STSCircallIPCamBroadcastingHostViewControllerRecordingStateRecording) {
        [self.recordingButton setImage:[UIImage imageNamed:@"capture-video-on"] forState:UIControlStateNormal];
        [self.recordingRedDot setHidden:NO];
        [self startAnimatingRecordingRedDot];
    } else {
        [self.recordingButton setImage:[UIImage imageNamed:@"capture-video-off"] forState:UIControlStateNormal];
        [self.recordingRedDot setHidden:YES];
        [self stopAnimatingRecordingRedDot];
    }
}

- (IBAction)recordingButtonDidPressed:(id)sender {
    if (self.viewControllerState != STSCircallIPCamBroadcastingHostViewControllerStatePublished &&
        self.viewControllerState != STSCircallIPCamBroadcastingHostViewControllerStateSubscribed) {
        [self showAlertWithTitle:@"無法錄影" message:@"需等候 remote stream 加入, 才可開始進行錄影"];
        return;
    }

    __weak STSCircallIPCamBroadcastingHostViewController * weakSelf = self;
    switch (self.recordingState) {
        case STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle: {
            // start recording
            self.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateStarting;

            [self.circallManager startRecordingStream:self.hostView.stream success:^(NSString *recordingId){
                weakSelf.recordingId = recordingId;
                weakSelf.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateRecording;
            } failure:^(NSError * _Nonnull error) {
                weakSelf.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle;
                [weakSelf showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"start record failed with error:%@",error]];
            }];
            break;
        }
        case STSCircallIPCamBroadcastingHostViewControllerRecordingStateRecording: {
            // stop recording
            self.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle;

            [self.circallManager stopRecordingStream:self.hostView.stream recordingId:weakSelf.recordingId success:^{
                weakSelf.recordingId = nil;
                weakSelf.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle;
            } failure:^(NSError * _Nonnull error) {
                weakSelf.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateRecording;
                [weakSelf showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"stop record failed with error:%@",error]];
            }];
            break;
        }
        case STSCircallIPCamBroadcastingHostViewControllerRecordingStateStarting:
        default:
            break;
    }
}

- (void)startAnimatingRecordingRedDot {
    __weak STSCircallIPCamBroadcastingHostViewController * weakSelf = self;
    self.recordingRedDotTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.recordingRedDot.isHidden) {
            weakSelf.recordingRedDot.hidden = NO;
        } else {
            weakSelf.recordingRedDot.hidden = YES;
        }
    }];
}

- (void)stopAnimatingRecordingRedDot {
    [self.recordingRedDotTimer invalidate];
    self.recordingRedDotTimer = nil;
}

#pragma mark - IBAction

- (IBAction)closeButtonDidPressed:(id)sender {
    [self leaveOngoingVideoCall];
}

- (void) leaveOngoingVideoCall {
    // show alert
    if (self.viewControllerState == STSCircallIPCamBroadcastingHostViewControllerStateIdle) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    __weak STSCircallIPCamBroadcastingHostViewController *weakSelf = self;
    void (^popViewController)(void) = ^() {
        weakSelf.circallManager = nil;
        weakSelf.hostView.stream = nil;
        [weakSelf.hud hideAnimated:YES];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };

    void (^disconnectCircall)(void) = ^() {
        [weakSelf.circallManager disconnectWithSuccess:^{
            popViewController();
        } failure:^(NSError * _Nonnull error) {
            NSString *errorMessage = [NSString stringWithFormat:@"error in disconnectWithSuccess: %@",error];
            NSAssert(false, errorMessage);
            popViewController();
        }];
    };

    void (^unpublish)(void) = ^() {
        if (!weakSelf.circallManager.isLocalStreamPublished) {
            disconnectCircall();
            return;
        }

        [weakSelf.circallManager unpublishWithSuccess:^{
            disconnectCircall();
        } failure:^(NSError * _Nonnull error) {
            NSString *errorMessage = [NSString stringWithFormat:@"error in unpublishWithSuccess: %@",error];
            NSAssert(false, errorMessage);
            disconnectCircall();
        }];
    };

    void (^stopRecording)(void) = ^() {
        if ((weakSelf.recordingState == STSCircallIPCamBroadcastingHostViewControllerRecordingStateRecording || weakSelf.recordingState == STSCircallIPCamBroadcastingHostViewControllerRecordingStateStarting) && self.hostView.stream != nil) {
            [weakSelf.circallManager stopRecordingStream:weakSelf.hostView.stream recordingId:weakSelf.recordingId success:^{
                weakSelf.recordingId = nil;
                weakSelf.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle;
                unpublish();
            } failure:^(NSError * _Nonnull error) {
                NSString *errorMessage = [NSString stringWithFormat:@"error in stopRecordingStream: %@",error];
                NSAssert(false, errorMessage);
                unpublish();
            }];
        } else {
            unpublish();
        }
    };

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"離開"
                                                                              message:@"你確定要離開嗎？"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAlertAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
        weakSelf.hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        weakSelf.hud.mode = MBProgressHUDModeIndeterminate;

        if (!self.hostView.stream) {
            disconnectCircall();
            return;
        }
        [weakSelf.circallManager unsubscribeStream:self.hostView.stream success:^{
            stopRecording();
        } failure:^(NSError * _Nonnull error) {
            NSString *errorMessage = [NSString stringWithFormat:@"error in unsubscribeStream: %@",error];
            NSAssert(false, errorMessage);
            stopRecording();
        }];

    }];
    [alertController addAction:exitAlertAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)takeScreenshotButtonDidPressed:(id)sender {
    if (self.hostView.stream == nil) {
        [self showAlertWithTitle:@"需等候 remote stream 加入, 才可開始截圖" message:nil];
    }

    UIImage *image = [self.hostView getVideoFrame];
    if (!image) {
        [self showAlertWithTitle:@"截圖失敗" message:nil];
        return;
    }

    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void) image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info {
    if (error) {
        NSString *errorMessage = @"截圖失敗";
        if (error.code == -3310) {
            errorMessage = @"無法儲存截圖，請先允許 StraaS 存取相片。";
        }
        [self showAlertWithTitle:errorMessage message:nil];
        return;
    }
    [self showAlertWithTitle:@"截圖成功，儲存至相簿" message:nil];
}

#pragma mark - STSCircallManagerDelegate Methods

- (void)circallManager:(STSCircallManager *)manager didAddStream:(STSCircallStream *)stream {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // don't need to subscribe for new streams for host
}

- (void)circallManager:(STSCircallManager *)manager didRemoveStream:(STSCircallStream *)stream {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateConnected;
    if ([self.hostView.stream.streamId isEqualToString:stream.streamId]) {
        self.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle;
        self.hostView.stream = nil;
    }
}

- (void)circallManager:(STSCircallManager *)manager onError:(NSError *)error {
    NSLog(@"%s - %@", __PRETTY_FUNCTION__, error);
    self.recordingState = STSCircallIPCamBroadcastingHostViewControllerRecordingStateIdle;
    self.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateIdle;
    self.hostView.stream = nil;

    [self.hud hideAnimated:YES];
    NSString * errorMessage = [NSString stringWithFormat:@"ERROR: %@, %ld, %@", error.domain, error.code, error.localizedDescription];
    [self showAlertWithTitle:@"Error" message:errorMessage exitOnCompletion:YES];
}

@end
