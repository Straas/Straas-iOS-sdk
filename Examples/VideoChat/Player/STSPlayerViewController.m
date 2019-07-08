//
//  STSPlayerViewController.m
//  StraaS
//
//  Created by Lee on 6/21/16.
//
//

#import "STSPlayerViewController.h"
#import <StraaSPlayerSDK/StraaSPlayerSDK.h>
#import <StraaSPlayerLowLatencyExtensionSDK/STSLowLatencyPlayer.h>
#import <StraaSCoreSDK/StraaSCoreSDK.h>
#import "UIViewController+STSKeyboard.h"

@interface STSPlayerViewController ()<STSSDKPlayerViewDelegate, STSPlayerPlaybackEventDelegate, STSPlayerPlaylistEventDelegate, UITextFieldDelegate, STSPlayerLiveEventDelegate, STSLiveEventListenerDelegate>
@property (nonatomic, nonnull) IBOutlet STSSDKPlayerView * playerView;
@property (nonatomic, nonnull) NSArray<NSLayoutConstraint *> *constraintsForLandscape;
@property (weak, nonatomic) IBOutlet UITextField *videoTextfield;
@property (weak, nonatomic) IBOutlet UITextField *playlistTextfield;
@property (weak, nonatomic) IBOutlet UITextField *liveTextField;
@property (nonatomic, nonnull) NSArray<NSLayoutConstraint *> *constraintsForPortrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *playlistButton;
@property (weak, nonatomic) IBOutlet UIButton *liveButton;
@property (weak, nonatomic) IBOutlet UIButton *listenLiveButton;
@property (weak, nonatomic) IBOutlet UISwitch *backgroundPlayingButton;
@property (nonatomic, nonnull) IBOutlet UIScrollView * containerView;
@property (nonatomic) IBOutlet UISegmentedControl * videoScalingModeSegementedControl;
@property (weak, nonatomic) IBOutlet UISwitch *lowLatencySwitch;
@property (nonatomic, nullable) STSLiveEventListener * liveEventListener;
@end

@implementation STSPlayerViewController

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    STSPlayerViewController * vc =
    [storyboard instantiateViewControllerWithIdentifier:@"STSPlayerViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sts_registerForKeyboardNotifications];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden =
    UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    self.title = @"StraaS SDK Player";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPlayerView];
    [STSApplication configureApplication:^(BOOL success, NSError *error) {
        if (success) {
            self.videoButton.enabled = YES;
            self.playlistButton.enabled = YES;
            self.liveButton.enabled = YES;
            self.listenLiveButton.enabled = YES;
        } else {
            NSLog(@"configure application error: \n %@", error);
        }
    }];
}


- (void)sts_updateLayoutWithKeyboard:(BOOL)keyboard notification:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;
    CGFloat height = CGRectGetHeight([[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    self.scrollViewBottomConstraint.constant = keyboard ? height - 20 : 0;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [self sts_unregisterForKeyboardNotifications];
}

#pragma mark -

- (void)setupPlayerView {
    self.playerView.delegate = self;
    self.playerView.JWT = self.JWT;
    self.playerView.allowsPlayingInBackground = self.backgroundPlayingButton.on;
    self.playerView.remoteControlEnabled = YES;
    self.playerView.playlistEventDelegate = self;
    self.playerView.liveEventDelegate = self;
    self.playerView.videoScalingMode =
    [self videoScalingMode:self.videoScalingModeSegementedControl.selectedSegmentIndex];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self updateLayoutConstraints:UIInterfaceOrientationIsLandscape(orientation)];

//    // You can uncomment the below part to see the demo of using `mappingForDisplayingAvailableQualityNames`
//    self.playerView.mappingForDisplayingAvailableQualityNames = ^NSArray<NSString *> *(NSArray<NSString *> * _Nonnull qualityNames) {
//        NSMutableArray *newQualityNames = [[NSMutableArray alloc] init];
//        for (NSString *qualityName in qualityNames) {
//            if ([qualityName isEqualToString:@"auto"]) {
//                [newQualityNames addObject:NSLocalizedString(@"Auto", @"Auto")];
//            } else if ([qualityName isEqualToString:@"240p"]) {
//                [newQualityNames addObject:NSLocalizedString(@"Normal Quality", @"Normal Quality")];
//            } else if ([qualityName isEqualToString:@"360p"]) {
//                [newQualityNames addObject:NSLocalizedString(@"High Quality", @"High Quality")];
//            }
//        }
//
//        return [newQualityNames copy];
//    };
}

- (STSVideoScalingMode)videoScalingMode:(NSInteger)index {
    switch (index) {
        case 1:
            return STSVideoScalingModeAspectFill;
        case 2:
            return STSVideoScalingModeFill;
        case 0:
        default:
            return STSVideoScalingModeAspectFit;
    }
}

- (void)stopLiveEventListener {
    [self.liveEventListener stop];
    self.liveEventListener = nil;
    [self.listenLiveButton setTitle:@"Listen" forState:UIControlStateNormal];
}

#pragma mark - accessor

- (void)setJWT:(NSString *)JWT {
    self.playerView.JWT = JWT;
    _JWT = JWT;
}

- (NSArray<NSLayoutConstraint *> *)constraintsForPortrait {
    if (!self.playerView) {
        return nil;
    }
    if (!_constraintsForPortrait) {
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[playerView]-(0)-|"
                                                                                 options:0 metrics:nil views:@{@"playerView": self.playerView}]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[playerView]"
                                                                                 options:0 metrics:nil views:@{@"playerView": self.playerView}]];
        NSLayoutConstraint *constraint =[NSLayoutConstraint
                                         constraintWithItem:self.playerView
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.playerView
                                         attribute:NSLayoutAttributeHeight
                                         multiplier:16./9.
                                         constant:0.0f];
        [constraints addObject:constraint];
        _constraintsForPortrait = [constraints copy];
    }
    return _constraintsForPortrait;
}

- (NSArray<NSLayoutConstraint *> *)constraintsForLandscape {
    if (!self.playerView) {
        return nil;
    }
    if (!_constraintsForLandscape) {
        NSMutableArray * constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[playerView]-(0)-|"
                                                                                 options:0 metrics:nil views:@{@"playerView": self.playerView}]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[playerView]-(0)-|"
                                                                                 options:0 metrics:nil views:@{@"playerView": self.playerView}]];
        _constraintsForLandscape = [constraints copy];
    }
    return _constraintsForLandscape;
}

#pragma mark - UIViewController interface rotation methods

- (void)updateLayoutConstraints:(BOOL)isLandscape {
    self.containerView.hidden = isLandscape;
    if(isLandscape) {
        [self.view endEditing:YES];
        [NSLayoutConstraint deactivateConstraints:self.constraintsForPortrait];
        [NSLayoutConstraint activateConstraints:self.constraintsForLandscape];
    } else{
        [NSLayoutConstraint deactivateConstraints:self.constraintsForLandscape];
        [NSLayoutConstraint activateConstraints:self.constraintsForPortrait];
    }
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (newCollection.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
            return;
        }
        BOOL isLandScape = (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact);
        self.navigationController.navigationBar.hidden = isLandScape;
        [self updateLayoutConstraints:isLandScape];
    } completion:nil];
}

- (IBAction)loadVideo:(id)sender {
    NSString * videoId = self.videoTextfield.text;
    [self.view endEditing:YES];
    if (videoId.length == 0) {
        return;
    }
    [self.playerView loadVideoWithId:videoId];
}

- (IBAction)loadPlaylist:(id)sender {
    NSString * playlistId = self.playlistTextfield.text;
    [self.view endEditing:YES];
    if (playlistId.length == 0) {
        return;
    }
    [self.playerView loadPlaylistWithId:playlistId];
}

- (IBAction)loadLive:(id)sender {
    NSString * liveId = self.liveTextField.text;
    [self.view endEditing:YES];
    if ([liveId length] == 0) {
        return;
    }
    BOOL isLowLatency = self.lowLatencySwitch.isOn;
    [self setupLowLatencyPlayerIfNecessary:isLowLatency];
    [self.playerView loadLiveWithId:liveId lowLatency:isLowLatency];
}

- (IBAction)listenLive:(id)sender {
    if (self.liveEventListener) {
        [self stopLiveEventListener];
        return;
    }
    NSString * liveId = self.liveTextField.text;
    [self.view endEditing:YES];
    if ([liveId length] == 0) {
        return;
    }
    self.liveEventListener = [[STSLiveEventListener alloc] initWithWithJWT:self.JWT delegate:self];
    [self.liveEventListener startWithLiveId:liveId success:^{
        NSLog(@"Did start listening to the live: %@", liveId);
    } failure:^(NSError * error){
        NSLog(@"Failed to listen to the live: %@", liveId);
    }];
    [self.listenLiveButton setTitle:@"Stop" forState:UIControlStateNormal];
}

- (IBAction)videoScalingModeSegementedControlValueChanged:(UISegmentedControl *)segmentedControl {
    self.playerView.videoScalingMode = [self videoScalingMode:segmentedControl.selectedSegmentIndex];
}

- (IBAction)latencySwitchDidChangeValue:(UISwitch *)sender {
    NSString * liveId = self.liveTextField.text;
    if (liveId.length == 0) {
        return;
    }
    BOOL isLowLatency = sender.isOn;
    [self setupLowLatencyPlayerIfNecessary:isLowLatency];
    [self.playerView loadLiveWithId:liveId lowLatency:isLowLatency];
}

- (void)setupLowLatencyPlayerIfNecessary:(BOOL)islowLatency {
    if (islowLatency && !self.playerView.lowLatencyPlayer) {
        STSLowLatencyPlayer * lowLatencyPlayer = [STSLowLatencyPlayer new];
        self.playerView.lowLatencyPlayer = (id<STSPlayerPlayback>)lowLatencyPlayer;
    }
}

- (IBAction)enableBackgroundPlaying:(UISwitch *)sender {
    self.playerView.remoteControlEnabled = sender.on;
    self.playerView.allowsPlayingInBackground = sender.on;
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - STSPlayerPlaybackEventDelegate

- (void)playerViewStartPlaying:(STSSDKPlayerView *)playerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)playerView:(STSSDKPlayerView *)playerView onBuffering:(BOOL)buffering {
    NSLog(@"%s, buffering %d", __PRETTY_FUNCTION__, buffering);
}

- (void)playerViewDidPlayToEnd:(STSSDKPlayerView *)playerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)playerViewPaused:(STSSDKPlayerView *)playerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)playerView:(STSSDKPlayerView *)playerView error:(NSError * _Nonnull)error{
    NSLog(@"%s with Error %@", __PRETTY_FUNCTION__, error);
}

- (void)playerView:(STSSDKPlayerView *)playerView mediaDurationChanged:(Float64)duration {
    //DO NOTHING
    //NSLog(@"current media duration: %lf", duration);
}

- (void)playerView:(STSSDKPlayerView *)playerView mediaCurrentTimeChanged:(Float64)currentTime {
    //DO NOTHING
    //NSLog(@"media current time changed to %lf", currentTime);
}

- (void)playerView:(STSSDKPlayerView *)playerView loadedTimeRangesChanged:(NSArray *)loadedTimeRanges {
    //DO NOTHING
}

#pragma mark - PlayerViewDelegate

- (UIViewController *)webOpenerPresentingViewController {
    return self;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent {
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

#pragma mark - STSPlayerPlaylistEventDelegate

- (void)playerView:(STSSDKPlayerView *)playerView didLoadPlaylist:(STSPlaylist *)playlist {

}

- (BOOL)playerView:(STSSDKPlayerView *)playerView willPlayItemAtIndex:(NSInteger)index {

    return YES;
}

- (void)playerView:(STSSDKPlayerView *)playerView didPlayItemAtIndex:(NSInteger)index {

}

- (void)playerView:(STSSDKPlayerView *)playerView playListDidPlayToEnd:(STSPlaylist *)playlist {

}

#pragma mark - STSPlayerLiveEventDelegate

- (void)playerView:(STSSDKPlayerView *)playerView startLoadingLive:(NSString *)liveId {
    NSLog(@"start loading live: %@", liveId);
}

- (void)playerView:(STSSDKPlayerView *)playerView didLoadLive:(NSString *)liveId {
    NSLog(@"did load live: %@", liveId);
}

- (void)playerView:(STSSDKPlayerView *)playerView live:(NSString *)liveId broadcastStateChanged:(STSLiveBroadcastState)broadcastState {
    NSLog(@"live id:%@, broadcast state changed: %ld", liveId, (long)broadcastState);
}

- (void)playerView:(STSSDKPlayerView *)playerView liveCCUChanged:(NSString *)liveId value:(NSNumber *)ccu {
    NSLog(@"live CCU updated: liveId=%@, ccu=%@", liveId, ccu);
}

- (void)playerView:(STSSDKPlayerView *)playerView liveHitCountChanged:(NSString *)liveId value:(NSNumber *)hitCount {
    NSLog(@"live hitCount updated: liveId=%@, hitCount=%@", liveId, hitCount);
}

- (void)playerView:(STSSDKPlayerView *)playerView
broadcastStartTimeChanged:(NSString *)liveId
             value:(NSNumber *)broadcastStartTimeInMS {
    NSLog(@"live broadcast time changed: liveId=%@, time=%@", liveId, broadcastStartTimeInMS);
}

#pragma mark - STSLiveEventListenerDelegate

- (void)liveEventListener:(STSLiveEventListener *)liveEventListener onError:(NSError *)error {
    NSLog(@"%s, error: %@", __PRETTY_FUNCTION__ , error);
}

- (void)liveEventListener:(STSLiveEventListener *)liveEventListener
    broadcastStateChanged:(STSLiveBroadcastState)broadcastState {
    NSLog(@"%s, broadcastState=%ld", __PRETTY_FUNCTION__, (long)broadcastState);
}

- (void)liveEventListener:(STSLiveEventListener *)liveEventListener CCUUpdated:(NSNumber *)ccu {
    NSLog(@"%s, ccu: %@", __PRETTY_FUNCTION__, ccu);
}

- (void)liveEventListener:(STSLiveEventListener *)liveEventListener hitCountUpdated:(NSNumber *)hitCount {
    NSLog(@"%s, hit count: %@", __PRETTY_FUNCTION__, hitCount);
}

@end
