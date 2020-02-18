//
//  ChatStickerDelegate.h
//  VideoChat
//
//  Created by Lee on 04/11/2016.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatStickerDelegate <NSObject>

- (void)chatStickerDidLoad:(NSArray *)stickers;
- (void)showStickerView:(BOOL)animated;
- (void)dismissStickerView:(BOOL)animated;
- (BOOL)isStickerViewShowing;

@end
