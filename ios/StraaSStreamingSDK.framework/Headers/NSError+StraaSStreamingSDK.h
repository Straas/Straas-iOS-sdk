//
//  NSError+StraaSStreamingSDK.h
//  StraaS
//
//  Created by shihwen.wang on 2016/10/26.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError(StraaSStreamingSDK)

+ (instancetype)STSStreamingCameraAccessDeniedError;
+ (instancetype)STSStreamingMicrophoneAccessDeniedError;
+ (instancetype)STSStreamingResolutionNotSupportError;
+ (instancetype)STSStreamingInternalError;
+ (instancetype)STSStreamingInternalError:(NSString * _Nullable)additionalMessage;
+ (instancetype)STSStreamingOperationDeniedError:(NSString *)additionalMessage;
+ (instancetype)STSStreamingServerError;
+ (instancetype)STSStreamingServerErrorWithUserInfo:(NSDictionary * _Nullable)userInfo;
+ (instancetype)STSStreamingUnauthorizedError;
+ (instancetype)STSStreamingParameterNotSupportError:(NSString * _Nullable)additionalMessage;
+ (instancetype)STSStreamingLiveCountLimitError;
+ (instancetype)STSStreamingDataMissingError;
+ (instancetype)STSStreamingNetworkError;
+ (instancetype)STSStreamingEventExpiredError;
+ (instancetype)STSStreamingEventNotFoundError;

- (instancetype)convertToSTSStreamingError;
- (instancetype)convertToStreamingHTTPError;
- (BOOL)isStreamingHTTPUnauthorizeError;
- (BOOL)isStreamingHTTPLiveCountOverLimitError;

@end

NS_ASSUME_NONNULL_END
