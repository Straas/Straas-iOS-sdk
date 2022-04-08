//
//  STSChatManagerConfig.h
//  StraaSMessagingSDK
//
//  Created by Allen and Kim on 2020/10/6.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Configuration for STSChatManager.
 */
@interface STSChatManagerConfig : NSObject

/**
 *  The host of the chatroom restful API server. Not to set this or sets this to nil to use the default value.
 */
@property (nonatomic, strong) NSString *restHost;

/**
 *  The host of the chatroom socket server. Not to set this or sets this to nil to use the default value.
 */
@property (nonatomic, strong) NSString *socketHost;

@end

NS_ASSUME_NONNULL_END
