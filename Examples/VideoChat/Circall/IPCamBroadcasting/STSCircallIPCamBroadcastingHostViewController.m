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
#import <NYTPhotoViewer/NYTPhotoViewer.h>
#import "STSScreenshotPhoto.h"
#import <StraaSCircallSDK/STSCircallPublishWithUrlConfig.h>

typedef NS_ENUM(NSUInteger, STSCircallIPCamBroadcastingHostViewControllerState){
    STSCircallIPCamBroadcastingHostViewControllerStateIdle,
    STSCircallIPCamBroadcastingHostViewControllerStateConnecting,
    STSCircallIPCamBroadcastingHostViewControllerStateConnected,
    STSCircallIPCamBroadcastingHostViewControllerStatePublished,
    STSCircallIPCamBroadcastingHostViewControllerStateSubscribed
};

@interface STSCircallIPCamBroadcastingHostViewController () <STSCircallManagerDelegate>

@property (weak, nonatomic) IBOutlet STSCircallPlayerView *hostView;

@property (strong, nonatomic) STSCircallManager *circallManager;
@property (assign, nonatomic) STSCircallIPCamBroadcastingHostViewControllerState viewControllerState;

@property (strong, nonatomic) MBProgressHUD *hud;

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

    // properties settings
    self.circallManager = [[STSCircallManager alloc] init];
    self.circallManager.delegate = self;

    if (self.circallToken == nil) {
        [self showAlertWithTitle:@"Error" message:@"Circall token is nil"];
        return;
    }

    self.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateIdle;

    // actions
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;

    __weak STSCircallIPCamBroadcastingHostViewController * weakSelf = self;

    void (^subscribeStream)() = ^(STSCircallStream * _Nonnull stream) {
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

    void (^publishRTSPUrl)() = ^() {
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

    void (^connect)() = ^() {
        [weakSelf.circallManager connectWithCircallToken:self.circallToken success:^{
            weakSelf.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateConnected;
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
    if (self.viewControllerState == STSCircallIPCamBroadcastingHostViewControllerStateIdle) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    __block MBProgressHUD * hud = nil;

    __weak STSCircallIPCamBroadcastingHostViewController *weakSelf = self;
    void (^popViewController)() = ^() {
        weakSelf.circallManager = nil;
        weakSelf.hostView.stream = nil;
        [hud hideAnimated:YES];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };

    void (^disconnectCircall)() = ^() {
        [weakSelf.circallManager disconnectWithSuccess:^{
            popViewController();
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"failed to disconnect error:%@",error);
            popViewController();
        }];
    };

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"離開"
                                                                              message:@"你確定要離開嗎？"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAlertAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
        hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [weakSelf.circallManager unpublishWithSuccess:^{
            disconnectCircall();
        } failure:^(NSError * _Nonnull error) {
            disconnectCircall();
        }];
    }];
    [alertController addAction:exitAlertAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)takeScreenshotButtonDidPressed:(id)sender {
    if (self.hostView.stream == nil) {
        [self showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"remote stream is not added."]];
    }

    UIImage *image = [self.hostView getVideoFrame];
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
    __weak STSCircallIPCamBroadcastingHostViewController *weakSelf = self;
    [manager subscribeStream:stream success:^(STSCircallStream * _Nonnull stream) {
        weakSelf.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateSubscribed;
        weakSelf.hostView.stream = stream;
    } failure:^(STSCircallStream * _Nonnull stream, NSError * _Nonnull error) {
        weakSelf.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateConnected;
        weakSelf.hostView.stream = stream;
    }];
}

- (void)circallManager:(STSCircallManager *)manager didRemoveStream:(STSCircallStream *)stream {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateConnected;
    if ([self.hostView.stream.streamId isEqualToString:stream.streamId]) {
        self.hostView.stream = nil;
    }
}

- (void)circallManager:(STSCircallManager *)manager onError:(NSError *)error {
    NSLog(@"%s - %@", __PRETTY_FUNCTION__, error);
    self.viewControllerState = STSCircallIPCamBroadcastingHostViewControllerStateIdle;
    self.hostView.stream = nil;

    [self.hud hideAnimated:YES];
    NSString * errorMessage = [NSString stringWithFormat:@"ERROR: %@, %ld, %@", error.domain, error.code, error.localizedDescription];
    [self showAlertWithTitle:@"Error" message:errorMessage];
}

@end
