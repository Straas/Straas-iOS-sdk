//
//  STSRKStreamer.m
//  StraaSBroadcastUpload
//
//  Created by Harry Hsu on 19/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "STSRKStreamer.h"

static const CGFloat kStartStreamingRetryInterval = 2.0;
static const NSUInteger kStartStreamingRetryAttemptLimit = 5;

@interface STSRKStreamer() <STSLiveStreamerDelegate>

@property (nonatomic) STSLiveStreamer * liveStreamer;
@property (nonatomic, readwrite) NSURL * streamURL;
@property (nonatomic) NSTimer * startStreamingRetryTimer;
@property (nonatomic) NSUInteger startStreamingRetryCount;
@property (nonatomic) BOOL isStreamStopped;

@end

@implementation STSRKStreamer

+ (instancetype)sharedInstance {
    static STSRKStreamer * streamer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamer = [STSRKStreamer new];
    });
    return streamer;
}

- (void)dealloc {
    [self resetRetryTimerIfNeeded];
}

#pragma mark - Accessors

- (STSLiveStreamer *)liveStreamer {
    if (!_liveStreamer) {
        NSAssert(self.videoConfig != nil, @"videoConfig is not set.");
        NSAssert(self.audioConfig != nil, @"audioConfig is not set.");
        _liveStreamer = [[STSLiveStreamer alloc] initWithVideoConfiguration:self.videoConfig
                                                        audioConfiguration:self.audioConfig];
        _liveStreamer.delegate = self;
    }
    return _liveStreamer;
}

#pragma mark - Private Methods

- (void)resetRetryTimerIfNeeded {
    if (self.startStreamingRetryTimer) {
        [self.startStreamingRetryTimer invalidate];
        self.startStreamingRetryTimer = nil;
    }
}

- (void)startStreamingWithRetryEnabled:(BOOL)retryEnabled
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *))failure {
    if (!self.streamURL) {
        return;
    }
    
    __weak STSRKStreamer * weakSelf = self;
    [self.liveStreamer startStreamingWithURL:self.streamURL success:^{
        [weakSelf resetRetryTimerIfNeeded];
        success();
    } failure:^(NSError * _Nonnull error) {
        [weakSelf resetRetryTimerIfNeeded];
        
        if (!retryEnabled) {
            failure(error);
            return;
        }
        
        weakSelf.startStreamingRetryCount++;
        if (weakSelf.startStreamingRetryCount > kStartStreamingRetryAttemptLimit
            || weakSelf.isStreamStopped) {
            failure(error);
            return;
        }
        
        weakSelf.startStreamingRetryTimer =
        [NSTimer scheduledTimerWithTimeInterval:kStartStreamingRetryInterval repeats:NO block:^(NSTimer * _Nonnull timer) {
            [weakSelf startStreamingWithRetryEnabled:retryEnabled success:success failure:failure];
        }];
    }];
}

#pragma mark - Public Methods

- (void)startStreamingWithURL:(NSURL *)url
                 retryEnabled:(BOOL)retryEnabled
                      success:(void (^)(void))success
                      failure:(void (^)(NSError *))failure {
    self.isStreamStopped = NO;
    self.streamURL = url;
    self.startStreamingRetryCount = 0;
    [self startStreamingWithRetryEnabled:retryEnabled success:success failure:failure];
}

- (void)stopStreamingWithSuccess:(void (^)(NSURL *))success
                         failure:(void (^)(NSURL *, NSError *))failure {
    self.isStreamStopped = YES;
    [self.liveStreamer stopStreamingWithSuccess:^(NSURL * _Nonnull streamingURL) {
        success(streamingURL);
    } failure:^(NSError * _Nonnull error, NSURL * _Nonnull streamingURL) {
        failure(streamingURL, error);
    }];
}

- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [self.liveStreamer pushVideoSampleBuffer:sampleBuffer];
}

- (void)pushAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer ofAudioChannel:(NSString *)audioChannel {
    [self.liveStreamer pushAudioSampleBuffer:sampleBuffer ofAudioChannel:audioChannel];
}

#pragma mark - STSLiveStreamerDelegate Methods

- (void)liveStreamer:(STSLiveStreamer *)liveStreamer onError:(NSError *)error streamingURL:(nullable NSURL *)streamingURL{
    NSLog(@"%s, %@, %@", __PRETTY_FUNCTION__, error, streamingURL);
}

@end
