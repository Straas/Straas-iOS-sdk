//
//  SampleHandler.m
//  Broadcast
//
//  Created by Harry Hsu on 05/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "SampleHandler.h"
#import "STSRKStreamer.h"

@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    CGFloat videoWidth = [(NSNumber*)setupInfo[@"videoWidth"] floatValue];
    CGFloat videoHeight = [(NSNumber*)setupInfo[@"videoHeight"] floatValue];
    NSURL * endpointURL = [NSURL URLWithString:(NSString *)setupInfo[@"endpointURL"]];
    
    CGSize videoSize = CGSizeMake(videoWidth, videoHeight);
    STSVideoConfiguration * videoConfig = [STSVideoConfiguration new];
    videoConfig.videoSize = videoSize;
    videoConfig.frameRate = 30;
    
    STSAudioConfiguration * audioConfig = [STSAudioConfiguration new];
    audioConfig.sampleRate = STSAudioSampleRate_44100Hz;
    audioConfig.numOfChannels = 1;
    audioConfig.replayKitAudioChannels = @[kSTSReplayKitAudioChannelMic, kSTSReplayKitAudioChannelApp];
    
    STSRKStreamer * streamer = [STSRKStreamer sharedInstance];
    streamer.videoConfig = videoConfig;
    streamer.audioConfig = audioConfig;
    [streamer startStreamingWithURL:endpointURL retryEnabled:YES success:^{
        NSLog(@"start streaming successfully : %@", endpointURL);
    } failure:^(NSError * error) {
        NSLog(@"fail to start streaming, %@", error);
        [self finishWithError:error];
    }];
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
    [[STSRKStreamer sharedInstance] stopStreamingWithSuccess:^(NSURL * streamURL) {
        NSLog(@"stop streaming successfully : %@", streamURL);
    } failure:^(NSURL * streamURL, NSError * error) {
        NSLog(@"fail to stop streaming : %@, %@", streamURL, error);
        [self finishWithError:error];
    }];
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
    STSRKStreamer * streamer = [STSRKStreamer sharedInstance];
    [streamer startStreamingWithURL:streamer.streamURL retryEnabled:YES success:^{
        NSLog(@"start streaming successfully");
    } failure:^(NSError * error) {
        NSLog(@"fail to start streaming, %@", error);
        [self finishWithError:error];
    }];
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    [[STSRKStreamer sharedInstance] stopStreamingWithSuccess:^(NSURL * streamURL) {
        NSLog(@"stop streaming successfully : %@", streamURL);
    } failure:^(NSURL * streamURL, NSError * error) {
        NSLog(@"fail to stop streaming : %@, %@", streamURL, error);
    }];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
            // Handle video sample buffer
            [[STSRKStreamer sharedInstance] pushVideoSampleBuffer:sampleBuffer];
            break;
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
            [[STSRKStreamer sharedInstance] pushAudioSampleBuffer:sampleBuffer ofAudioChannel:kSTSReplayKitAudioChannelApp];
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            [[STSRKStreamer sharedInstance] pushAudioSampleBuffer:sampleBuffer ofAudioChannel:kSTSReplayKitAudioChannelMic];
            break;

        default:
            break;
    }
}

#pragma mark - Private Methods

- (void)finishWithError:(NSError *)error {
    if ([self respondsToSelector:@selector(finishBroadcastWithError:)]) {
        [self finishBroadcastWithError:error];
    }
}

@end
