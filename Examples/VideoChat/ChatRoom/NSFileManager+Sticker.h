//
//  NSFileManager+Sticker.h
//  VideoChat
//
//  Created by Lee on 09/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Sticker)

+ (NSArray <NSDictionary *>*)getRecentlyUsedStickerItems;
+ (void)addRecentlyUsedStickerItem:(NSDictionary *)stickerItem;
+ (void)clearRecentlyUsedStickerItems;

@end
