//
//  StickerInputViewDelegate.h
//  VideoChat
//
//  Created by Lee on 04/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The delegate of a NSObject must adopt the StickerInputViewDelegate protocol.
 */
@protocol StickerInputViewDelegate <NSObject>

/**
 Tells the delegate that a sticker key did be selected.

 @param key The sticker key name.
 @param imageURL The sticker image URL.
 */
- (void)didSelectStickerKey:(NSString *)key
                   imageURL:(NSString *)imageURL;

@end
