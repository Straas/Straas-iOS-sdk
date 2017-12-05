//
//  SampleHandler.m
//  Broadcast
//
//  Created by Harry Hsu on 05/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <StraaSStreamingSDK/StraaSStreamingSDK.h>
#import "SampleHandler.h"

@interface SampleHandler() <STSLiveStreamerDelegate>

@property (nonatomic) NSURL * endpointURL;
@property (nonatomic) STSLiveStreamer * liveStreamer;

@end

@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    CGFloat videoWidth = [(NSNumber*)setupInfo[@"videoWidth"] floatValue];
    CGFloat videoHeight = [(NSNumber*)setupInfo[@"videoHeight"] floatValue];
    self.endpointURL = [NSURL URLWithString:(NSString *)setupInfo[@"endpointURL"]];
    
    CGSize videoSize = CGSizeMake(videoWidth, videoHeight);
    STSVideoConfiguration * videoConfig = [STSVideoConfiguration new];
    videoConfig.videoSize = videoSize;
    videoConfig.frameRate = 30;
    
    STSAudioConfiguration * audioConfig = [STSAudioConfiguration new];
    audioConfig.sampleRate = STSAudioSampleRate_44100Hz;
    audioConfig.numOfChannels = 1;
    audioConfig.replayKitAudioChannels = @[kSTSReplayKitAudioChannelMic, kSTSReplayKitAudioChannelApp];
    
    self.liveStreamer =
    [[STSLiveStreamer alloc] initWithVideoConfiguration:videoConfig
                                     audioConfiguration:audioConfig];
    self.liveStreamer.delegate = self;
    [self.liveStreamer startStreamingWithURL:self.endpointURL
                                     success:^{
                                         NSLog(@"start streaming successfully : %@", self.endpointURL);
                                     }
                                     failure:^(NSError * _Nonnull error) {
                                         NSLog(@"fail to start streaming, %@", error);
                                     }];
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
    [self.liveStreamer stopStreamingWithSuccess:^(NSURL * _Nonnull streamingURL) {
        NSLog(@"stop streaming successfully : %@", streamingURL);
    }
                                        failure:^(NSError * _Nonnull error, NSURL * _Nonnull streamingURL) {
                                            NSLog(@"fail to stop streaming : %@, %@", streamingURL, error);
                                        }];
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
    [self.liveStreamer startStreamingWithURL:self.endpointURL
                                     success:^{
                                         NSLog(@"start streaming successfully : %@", self.endpointURL);
                                     }
                                     failure:^(NSError * _Nonnull error) {
                                         NSLog(@"fail to start streaming, %@", error);
                                     }];
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    [self.liveStreamer stopStreamingWithSuccess:^(NSURL * _Nonnull streamingURL){
        NSLog(@"stop streaming successfully : %@", streamingURL);
    }
                                        failure:^(NSError * _Nonnull error, NSURL * _Nonnull streamingURL) {
                                            NSLog(@"fail to stop streaming : %@, %@", streamingURL, error);
                                        }];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
            // Handle video sample buffer
            [self.liveStreamer pushVideoSampleBuffer:sampleBuffer];
            break;
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
            [self.liveStreamer pushAudioSampleBuffer:sampleBuffer ofAudioChannel:kSTSReplayKitAudioChannelApp];
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            [self.liveStreamer pushAudioSampleBuffer:sampleBuffer ofAudioChannel:kSTSReplayKitAudioChannelMic];
            break;

        default:
            break;
    }
}

#pragma mark - STSLiveStreamerDelegate Methods

- (void)liveStreamer:(STSLiveStreamer *)liveStreamer onError:(NSError *)error streamingURL:(nullable NSURL *)streamingURL{
    NSLog(@"%s, %@, %@", __PRETTY_FUNCTION__, error, streamingURL);
}

@end
