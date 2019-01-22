//
//  STSCircallIPCamBroadcastingViewerViewController.m
//  StraaSDemoApp
//
//  Created by Allen and Kim on 2018/9/7.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import "STSCircallIPCamBroadcastingViewerViewController.h"
#import <StraaSCircallSDK/STSCircallPlayerView.h>
#import <StraaSCircallSDK/STSCircallManager.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSUInteger, STSCircallIPCamBroadcastingViewerViewControllerState){
    STSCircallIPCamBroadcastingViewerViewControllerStateIdle,
    STSCircallIPCamBroadcastingViewerViewControllerStateConnecting,
    STSCircallIPCamBroadcastingViewerViewControllerStateConnected,
    STSCircallIPCamBroadcastingViewerViewControllerStateSubscribed
};

@interface STSCircallIPCamBroadcastingViewerViewController () <STSCircallManagerDelegate>

@property (weak, nonatomic) IBOutlet STSCircallPlayerView *viewerView;

@property (strong, nonatomic) STSCircallManager *circallManager;
@property (assign, nonatomic) STSCircallIPCamBroadcastingViewerViewControllerState viewControllerState;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation STSCircallIPCamBroadcastingViewerViewController

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    STSCircallIPCamBroadcastingViewerViewController * vc =
    [storyboard instantiateViewControllerWithIdentifier:@"STSCircallIPCamBroadcastingViewerViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // properties settings
    self.circallManager = [[STSCircallManager alloc] init];
    self.circallManager.delegate = self;

    if (self.circallToken == nil) {
        [self showAlertWithTitle:@"Error" message:@"Circall token is nil"];
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectUntilSubscribe) name:UIApplicationWillEnterForegroundNotification object:nil];

    self.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateIdle;

    [self connectUntilSubscribe];
}

- (void)connectUntilSubscribe {
    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alerController = (UIAlertController *)self.presentedViewController;
        [alerController dismissViewControllerAnimated:NO completion:nil];
    }

    // actions
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;

    __weak STSCircallIPCamBroadcastingViewerViewController * weakSelf = self;

    void (^connect)(void) = ^() {
        [weakSelf.circallManager connectWithCircallToken:self.circallToken success:^{
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateConnected;

            [weakSelf.hud hideAnimated:YES];
        } failure:^(NSError * _Nonnull error) {
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateIdle;
            NSString * errorMessage = [NSString stringWithFormat:@"ERROR: %@, %ld, %@", error.domain, error.code, error.localizedDescription];
            [weakSelf showAlertWithTitle:@"Error" message:errorMessage exitOnCompletion:YES];
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

#pragma mark - IBAction

- (IBAction)closeButtonDidPressed:(id)sender {
    [self leaveOngoingVideoCall];
}

- (void)leaveOngoingVideoCall {
    // show alert
    if (self.viewControllerState == STSCircallIPCamBroadcastingViewerViewControllerStateIdle) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    __block MBProgressHUD * hud = nil;

    __weak STSCircallIPCamBroadcastingViewerViewController *weakSelf = self;
    void (^disconnectAndPopViewController)(void) = ^() {
        [weakSelf.circallManager disconnectWithSuccess:^{
            weakSelf.circallManager = nil;
            [hud hideAnimated:YES];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError * _Nonnull error) {
            NSString *errorMessage = [NSString stringWithFormat:@"error in disconnectWithSuccess: %@",error];
            NSAssert(false, errorMessage);
            weakSelf.circallManager = nil;
            [hud hideAnimated:YES];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    };

    void (^unsubscribe)(void) = ^() {
        if (!self.viewerView.stream) {
            disconnectAndPopViewController();
            return;
        }
        [weakSelf.circallManager unsubscribeStream:weakSelf.viewerView.stream success:^{
            disconnectAndPopViewController();
        } failure:^(NSError * _Nonnull error) {
            NSString *errorMessage = [NSString stringWithFormat:@"error in unsubscribeStream: %@",error];
            NSAssert(false, errorMessage);
            disconnectAndPopViewController();
        }];
    };

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"離開"
                                                                              message:@"你確定要離開嗎？"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAlertAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
        hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        unsubscribe();
    }];
    [alertController addAction:exitAlertAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)takeScreenshotButtonDidPressed:(id)sender {
    if (self.viewerView.stream == nil) {
        [self showAlertWithTitle:@"需等候 remote stream 加入, 才可開始截圖" message:nil];
    }

    UIImage *image = [self.viewerView getVideoFrame];
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
    __weak STSCircallIPCamBroadcastingViewerViewController *weakSelf = self;
    [manager subscribeStream:stream success:^(STSCircallStream * _Nonnull stream) {
        weakSelf.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateSubscribed;
        weakSelf.viewerView.stream = stream;
    } failure:^(STSCircallStream * _Nonnull stream, NSError * _Nonnull error) {
        weakSelf.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateConnected;
        weakSelf.viewerView.stream = nil;
        [self showAlertWithTitle:@"Failed" message:[NSString stringWithFormat:@"Failed didAddStream"]];
    }];
}

- (void)circallManager:(STSCircallManager *)manager didRemoveStream:(STSCircallStream *)stream {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateConnected;
    if ([self.viewerView.stream.streamId isEqualToString:stream.streamId]) {
        self.viewerView.stream = nil;
    }
}

- (void)circallManager:(STSCircallManager *)manager onError:(NSError *)error {
    NSLog(@"%s - %@", __PRETTY_FUNCTION__, error);
    self.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateIdle;
    self.viewerView.stream = nil;

    [self.hud hideAnimated:YES];
    NSString * errorMessage = [NSString stringWithFormat:@"ERROR: %@, %ld, %@", error.domain, error.code, error.localizedDescription];
    [self showAlertWithTitle:@"Error" message:errorMessage exitOnCompletion:YES];
}

@end
