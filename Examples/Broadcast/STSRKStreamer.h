//
//  STSRKStreamer.h
//  StraaSBroadcastUpload
//
//  Created by Harry Hsu on 19/12/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StraaSStreamingSDK/StraaSStreamingSDK.h>

@interface STSRKStreamer : NSObject

@property (nonatomic, readonly) NSURL * streamURL;
@property (nonatomic) STSVideoConfiguration * videoConfig;
@property (nonatomic) STSAudioConfiguration * audioConfig;

+ (instancetype)sharedInstance;
- (void)startStreamingWithURL:(NSURL *)url
                 retryEnabled:(BOOL)retryEnabled
                      success:(void (^)(void))success
                      failure:(void (^)(NSError * error))failure;
- (void)stopStreamingWithSuccess:(void (^)(NSURL * streamURL))success
                         failure:(void (^)(NSURL * streamURL, NSError * error))failure;
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)pushAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer ofAudioChannel:(NSString *)audioChannel;

@end
