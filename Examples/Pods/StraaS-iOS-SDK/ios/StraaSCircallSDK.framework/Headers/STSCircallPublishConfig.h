//
//  STSCircallPublishConfig.h
//  StraaSCircallSDK
//
//  Created by Harry Hsu on 30/03/2018.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Configs for publishing the local stream.
 */
@interface STSCircallPublishConfig : NSObject

/**
 * Max audio bitrate in bits per second. We will make max, min audio bitrate the same (constant bit rate).  600000 is the default value.
 */
@property (nonatomic) NSNumber * maxAudioBitrate;

/**
 * Max video bitrate in bits per second. We will make max, min video bitrate the same (constant bit rate).  64000 is the default value.
 */
@property (nonatomic) NSNumber * maxVideoBitrate;

@end
