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
#import <CoreLocation/CoreLocation.h>


@interface STSPlayerViewController ()<STSSDKPlayerViewDelegate, STSPlayerPlaybackEventDelegate, STSPlayerPlaylistEventDelegate, UITextFieldDelegate, STSPlayerLiveEventDelegate, STSLiveEventListenerDelegate, CLLocationManagerDelegate>
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
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *ccuLabel;
@property (weak, nonatomic) IBOutlet UILabel *hitCountLabel;
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
    [self resetCCUAndHitCountLabelText];
    [self registerForKeyboardNotifications];
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
            self.title = [self.title stringByAppendingString:@" (failed configure app)"];
            NSLog(@"\n CONFIGURE APPLICATION ERROR: \n %@ \n", error);
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:
     [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateLayoutWithKeyboard:(BOOL)keyboard notification:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;
    CGFloat height = CGRectGetHeight([[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    self.scrollViewBottomConstraint.constant = keyboard ? height - 20 : 0;
}

- (void)resetCCUAndHitCountLabelText {
    self.ccuLabel.text = @"0";
    self.hitCountLabel.text = @"0";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [self unregisterForKeyboardNotifications];
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

//    // You can uncomment the below part to see the demo of using [mappingForDisplayingAvailableQualityNames](https://straas.github.io/StraaS-iOS-sdk/StraaSPlayerSDK/Classes/STSSDKPlayerView.html#/c:objc(cs)STSSDKPlayerView(py)mappingForDisplayingAvailableQualityNames)
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

//    // You can uncomment the below part to see the demo of using [location](https://straas.github.io/StraaS-iOS-sdk/StraaSPlayerSDK/Classes/STSSDKPlayerView.html#/c:objc(cs)STSSDKPlayerView(py)location)
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    [self.locationManager requestAlwaysAuthorization];
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
    [self resetCCUAndHitCountLabelText];
    NSString * videoId = self.videoTextfield.text;
    if (videoId.length == 0) {
        return;
    }
    [self.view endEditing:YES];
    [self.playerView loadVideoWithId:videoId];
}

- (IBAction)loadPlaylist:(id)sender {
    [self resetCCUAndHitCountLabelText];
    NSString * playlistId = self.playlistTextfield.text;
    if (playlistId.length == 0) {
        return;
    }
    [self.view endEditing:YES];
    [self.playerView loadPlaylistWithId:playlistId];
}

- (IBAction)loadLive:(id)sender {
    [self resetCCUAndHitCountLabelText];
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
    [self.liveEventListener startWithLiveId:liveId success:nil failure:^(NSError * error){
        NSLog(@"Failed to start listening live %@. Error: %@", liveId, error);
    }];
    [self.listenLiveButton setTitle:@"Stop" forState:UIControlStateNormal];
}

- (IBAction)videoScalingModeSegementedControlValueChanged:(UISegmentedControl *)segmentedControl {
    self.playerView.videoScalingMode = [self videoScalingMode:segmentedControl.selectedSegmentIndex];
}

- (IBAction)latencySwitchDidChangeValue:(UISwitch *)sender {
    NSString * liveId = self.liveTextField.text;
    BOOL isLowLatency = sender.isOn;
    [self setupLowLatencyPlayerIfNecessary:isLowLatency];
    [self.playerView loadLiveWithId:liveId lowLatency:isLowLatency];
}

- (void)setupLowLatencyPlayerIfNecessary:(BOOL)isLowLatency {
    if (isLowLatency && !self.playerView.lowLatencyPlayer) {
        STSLowLatencyPlayer * lowLatencyPlayer = [[STSLowLatencyPlayer alloc] init];
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
    NSLog(@"%s, error %@", __PRETTY_FUNCTION__, error);
    if (playerView.playlist) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [playerView playNextItem];
        });
    }
}

- (void)playerView:(STSSDKPlayerView *)playerView mediaDurationChanged:(Float64)duration {
    //DO NOTHING
    //NSLog(@"current media duration: %lf", duration);
}

- (void)playerView:(STSSDKPlayerView *)playerView mediaCurrentTimeChanged:(Float64)currentTime {
    //DO NOTHING
    //NSLog(@"media current time changed to %lf, %lf", currentTime, playerView.currentLiveDateTime);
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
    self.ccuLabel.text = [NSString stringWithFormat:@"%li",(long)ccu.integerValue];
}

- (void)playerView:(STSSDKPlayerView *)playerView liveHitCountChanged:(NSString *)liveId value:(NSNumber *)hitCount {
    NSLog(@"live hitCount updated: liveId=%@, hitCount=%@", liveId, hitCount);
    self.hitCountLabel.text = [NSString stringWithFormat:@"%li",(long)hitCount.integerValue];
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

- (void)liveEventListener:(STSLiveEventListener *)liveEventListener stateChanged:(STSLiveEventListenerState)state {
    NSLog(@"%s, state: %ld", __PRETTY_FUNCTION__, (long)state);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.playerView.location = locations.lastObject;
    self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f",self.playerView.location.coordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f",self.playerView.location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
#if TARGET_IPHONE
    NSString *errorMesssage = [NSString stringWithFormat:@"locationManager:didFailWithError: %@",error];
    NSAssert(false, errorMesssage);
#endif
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        default:
            [self resetLocationAndUpdateUI];
            break;
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    [self resetLocationAndUpdateUI];
}

- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(nullable NSError *)error {
    [self resetLocationAndUpdateUI];
}

- (void)resetLocationAndUpdateUI {
    self.latitudeLabel.text = @"0";
    self.longitudeLabel.text = @"0";

    self.playerView.location = nil;
}

@end
