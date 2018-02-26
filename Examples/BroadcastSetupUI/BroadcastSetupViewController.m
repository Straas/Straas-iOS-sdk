//
//  BroadcastSetupViewController.m
//  BroadcastSetupUI
//
//  Created by Harry Hsu on 05/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <StraaSStreamingSDK/StraaSStreamingSDK.h>
#import <StraaSCoreSDK/StraaSCoreSDK.h>
#import "BroadcastSetupViewController.h"

@interface BroadcastSetupViewController()

@property (weak, nonatomic) IBOutlet UITextField * titleLabel;
@property (weak, nonatomic) IBOutlet UIButton * startButton;

@end

@implementation BroadcastSetupViewController

// Call this method when the user has finished interacting with the view controller and a broadcast stream can start
- (void)userDidFinishSetup:(STSStreamingInfo *)streamingInfo {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat aspectRatio = screenSize.width / screenSize.height;
    CGSize videoSize = [self get720pResolutionWithAspectRatio:aspectRatio];
    NSString * endpointURL = [NSString stringWithFormat:@"%@/%@", streamingInfo.streamServerURL, streamingInfo.streamKey];

    // Dictionary with setup information that will be provided to broadcast extension when broadcast is started
    NSDictionary * setupInfo = @{ @"endpointURL": endpointURL,
                                  @"videoWidth": @(videoSize.width),
                                  @"videoHeight": @(videoSize.height)};

    // URL of the resource where broadcast can be viewed that will be returned to the application
    NSURL * broadcastURL = [NSURL URLWithString:endpointURL];

    // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
    RPBroadcastConfiguration * broadcastConfig = [[RPBroadcastConfiguration alloc] init];
    [self.extensionContext completeRequestWithBroadcastURL:broadcastURL broadcastConfiguration:broadcastConfig setupInfo:setupInfo];
}

- (void)userDidCancelSetup {
    // Tell ReplayKit that the extension was cancelled by the user
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"YourAppDomain" code:-1 userInfo:nil]];
}

#pragma mark - Button Events

- (IBAction)onCancelButtonClick:(UIButton *)sender {
    [self userDidCancelSetup];
}

- (IBAction)onFinishButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    [self.titleLabel resignFirstResponder];
    
    [STSApplication configureApplication:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"configure application error: \n %@", error);
            [self userDidCancelSetup];
            return;
        }
        
        [self createLiveWithTitle:self.titleLabel.text success:^(STSStreamingInfo *streamingInfo) {
            [self userDidFinishSetup:streamingInfo];
        } failure:^(NSError *error) {
            [self userDidCancelSetup];
        }];
    }];
}

#pragma mark - UITextField Events

- (IBAction)onTitleTextChanged:(id)sender {
    self.startButton.enabled = (self.titleLabel.text.length > 0);
}

#pragma mark - Private Methods

- (NSString *)JWT {
    return <#PUT_YOUR_MEMEBER_JWT_HERE#>;
}

- (void)createLiveWithTitle:(NSString *)title
                    success:(void(^)(STSStreamingInfo * streamingInfo))success
                    failure:(void(^)(NSError * error))failure {

    STSStreamingManager * streamingManager = [STSStreamingManager streamingManagerWithJWT:[self JWT]];

    void (^createLiveSuccessHandler)(NSString *) = ^(NSString * liveId) {
        [streamingManager getStreamingInfoWithLiveId:liveId success:^(STSStreamingInfo * _Nonnull streamingInfo) {
            success(streamingInfo);
        } failure:^(NSError * _Nonnull error) {
            failure(error);
        }];
    };
    
    void (^failureHandler)(NSError *, NSString *) = ^(NSError * error, NSString * liveId) {
        if ([error.domain isEqualToString:STSStreamingErrorDomain]) {
            if (error.code == STSStreamingErrorCodeLiveCountLimit) {
                [streamingManager endLiveEvent:liveId success:^{
                    STSStreamingLiveEventConfig * config =
                    [STSStreamingLiveEventConfig liveEventConfigWithTitle:self.titleLabel.text listed:YES];
                    [streamingManager createLiveEventConfguration:config success:createLiveSuccessHandler failure:^(NSError * _Nonnull error, NSString * _Nullable liveId) {
                        failure(error);
                    }];
                } failure:^(NSError * _Nonnull error) {
                    failure(error);
                }];
                return;
            }
        }
        failure(error);
    };
    
    STSStreamingLiveEventConfig * config =
    [STSStreamingLiveEventConfig liveEventConfigWithTitle:self.titleLabel.text listed:YES];
    [streamingManager createLiveEventConfguration:config
                                          success:createLiveSuccessHandler
                                          failure:failureHandler];
}

- (CGSize)get720pResolutionWithAspectRatio:(CGFloat)aspectRatio {
    int width = 0;
    int height = 0;

    if (aspectRatio <= 1) {
        width = 720;
        height = width/aspectRatio;
    } else {
        height = 720;
        width = height * aspectRatio;
    }
    return CGSizeMake(width, height);
}

@end
