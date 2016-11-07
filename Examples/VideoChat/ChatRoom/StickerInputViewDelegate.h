//
//  StickerInputViewDelegate.h
//  VideoChat
//
//  Created by Lee on 04/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StickerInputViewDelegate <NSObject>
- (void)didSelectStickerKey:(NSString *)key;
@end
