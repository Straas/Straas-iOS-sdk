//
//  STSChatSticker.h
//  StraaS
//
//  Created by Lee on 26/10/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSChatSticker : LHDataObject

/**
 * The sticker name.
 */
@property (nonatomic, readonly) NSString * name;

/**
 * The main image of the sticker.
 */
@property (nonatomic, readonly) NSString * mainImage;

/**
 * The stickers dictionary whose key indicate sticker text and value indicate sticker url.
 */
@property (nonatomic, readonly) NSDictionary * stickers;

@end

NS_ASSUME_NONNULL_END
