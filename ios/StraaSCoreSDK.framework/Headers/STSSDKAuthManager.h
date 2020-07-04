//
//  STSSDKAuthManager.h
//  StraaS
//
//  Created by Lee on 8/11/16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  StraaS.io auth manager.
 */
@interface STSSDKAuthManager : NSObject

/**
 * The account id of current vendor.
 */
@property (nonatomic, readonly) NSString * accountId;

/**
 * The app token. If the app is authorized, then the token is not nil.
 */
@property (nonatomic, readonly) NSString * token;

/**
 *  Using new to create a STSSDKAuthManager instance is unavailable.
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 *  Using init to create a STSSDKAuthManager instance is unavailable.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns the STSSDKAuthManager instance, creating it if it doesn’t exist yet.
 *
 * @return    The shared instance of STSSDKAuthManager.
 */
+ (STSSDKAuthManager *)sharedManager;

/**
 * Refresh a member access token.
 *
 * @param refreshToken The token wants to be refresh
 * @param success      Handler for successful request. It takes refreshed token argument.
 * @param failure      Error handler.
 * @return The new session data task. Returns `nil` if the application is unauthorized.
 */
- (NSURLSessionDataTask *)refreshMemberToken:(NSString *)refreshToken
                                     success:(void(^)(NSString * token))success
                                     failure:(void(^)(NSError * error))failure;

@end
NS_ASSUME_NONNULL_END
