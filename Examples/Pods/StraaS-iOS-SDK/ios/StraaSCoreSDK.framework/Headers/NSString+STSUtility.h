//
//  NSString+STSUtility.h
//  StraaS
//
//  Created by Harry Hsu on 26/09/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A helper category on NSString.
 */
@interface NSString(STSUtility)

/**
 Get the payload of a JSON Web Token.

 @return The payload of a JSON Web Token. Nil if self is not a valid JWT.
 */
- (nullable NSDictionary *)jwtPayload;

@end

NS_ASSUME_NONNULL_END
