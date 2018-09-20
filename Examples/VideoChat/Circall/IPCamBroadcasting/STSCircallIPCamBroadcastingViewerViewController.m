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
#import <NYTPhotoViewer/NYTPhotoViewer.h>
#import "STSScreenshotPhoto.h"

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

    self.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateIdle;

    // actions
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;

    __weak STSCircallIPCamBroadcastingViewerViewController * weakSelf = self;

    void (^connect)() = ^() {
        [weakSelf.circallManager connectWithCircallToken:self.circallToken success:^{
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateConnected;

            [weakSelf.hud hideAnimated:YES];
        } failure:^(NSError * _Nonnull error) {
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingViewerViewControllerStateIdle;
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
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:
     [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - IBAction

- (IBAction)closeButtonDidPressed:(id)sender {
    if (self.viewControllerState == STSCircallIPCamBroadcastingViewerViewControllerStateIdle) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    __block MBProgressHUD * hud = nil;

    __weak STSCircallIPCamBroadcastingViewerViewController *weakSelf = self;
    void (^disconnectAndPopViewController)() = ^() {
        [weakSelf.circallManager disconnectWithSuccess:^{
            weakSelf.circallManager = nil;
            [hud hideAnimated:YES];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"failed to disconnect error:%@",error);
            weakSelf.circallManager = nil;
            [hud hideAnimated:YES];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    };

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"離開"
                                                                              message:@"你確定要離開嗎？"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAlertAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
        hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        disconnectAndPopViewController();
    }];
    [alertController addAction:exitAlertAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)takeScreenshotButtonDidPressed:(id)sender {
    if (self.viewerView.stream == nil) {
        [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"remote stream is not added."]];
    }

    UIImage *image = [self.viewerView getVideoFrame];
    if (!image) {
        [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"Failed to create screenshot"]];
        return;
    }

    STSScreenshotPhoto *photo = [[STSScreenshotPhoto alloc] initWithImage:image];
    NYTPhotosViewController *vc = [[NYTPhotosViewController alloc] initWithPhotos:@[photo]];
    [self presentViewController:vc animated:YES completion:nil];
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
        weakSelf.viewerView.stream = stream;
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
    [self showAlertWithTitle:@"Error" message:errorMessage];
}

@end
