//
//  STSCircallPublishWithUrlConfig.h
//  StraaSCircallSDK
//
//  Created by Allen on 2018/9/10.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Configs for publishing the stream from url(RTSP).
 */
@interface STSCircallPublishWithUrlConfig : NSObject

/**
 * url The RTSP url.
 */
@property (nonatomic, readonly) NSURL * url;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
