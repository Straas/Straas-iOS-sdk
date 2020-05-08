//
//  STSStreamingAPIClient.h
//  StraaS
//
//  Created by shihwen.wang on 2016/10/26.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STSStreamingInfo;
@class STSStreamingLiveEventConfig;

NS_ASSUME_NONNULL_BEGIN

@interface STSStreamingAPIClient : NSObject

- (void)setJWT:(NSString *)JWT;

- (void)createLiveWithConfguration:(STSStreamingLiveEventConfig *)configuration
                           success:(void (^)(STSStreamingInfo * streamingInfo))success
                           failure:(void (^)(NSError * error))failure
         liveCountOverLimitHandler:(void (^)(NSString * liveId))liveCountOverLimitHandler;

- (void)endLive:(NSString *)liveId success:(void (^)(void))success failure:(void (^)(NSError * error))failure;

- (void)getLive:(NSString *)liveId
        success:(void (^)(STSStreamingInfo * streamingInfo))success
        failure:(void (^)(NSError * error))failure;

- (void)cancelAllRequest;

@end

NS_ASSUME_NONNULL_END
