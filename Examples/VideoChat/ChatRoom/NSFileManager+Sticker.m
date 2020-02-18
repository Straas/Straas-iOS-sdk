//
//  NSFileManager+Sticker.m
//  VideoChat
//
//  Created by Lee on 09/11/2016.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import "NSFileManager+Sticker.h"

NSString * const recentlyUsedStickerPathKey = @"recentlyUsedSticker.txt";
NSUInteger const maxRecentlyUsedStickerCount = 20;

@implementation NSFileManager (Sticker)
+ (NSArray <NSDictionary *> *)getRecentlyUsedStickerItems {
    NSString * path = [self pathWithPathkey:recentlyUsedStickerPathKey];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSArray * recentlyUsedSticker = [NSArray arrayWithContentsOfFile:path];
        return recentlyUsedSticker;
    }
    return nil;
}

+ (void)addRecentlyUsedStickerItem:(NSDictionary *)stickerItem {
    NSString * path = [self pathWithPathkey:recentlyUsedStickerPathKey];
    NSMutableArray * usedStickerItems = [NSMutableArray arrayWithContentsOfFile:path];
    if (!usedStickerItems) {
        [@[stickerItem] writeToFile:path atomically:YES];
        return;
    }
    if ([usedStickerItems containsObject:stickerItem]) {
        [usedStickerItems removeObject:stickerItem];
    }
    [usedStickerItems insertObject:stickerItem atIndex:0];
    if (usedStickerItems.count > maxRecentlyUsedStickerCount) {
        [usedStickerItems removeLastObject];
    }
    [usedStickerItems writeToFile:path atomically:YES];
}

+ (void)clearRecentlyUsedStickerItems {
    NSString * path = [self pathWithPathkey:recentlyUsedStickerPathKey];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

+ (NSString *)pathWithPathkey:(NSString *)pathKey {
    NSString * path;
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:pathKey];
    return path;
}
@end
