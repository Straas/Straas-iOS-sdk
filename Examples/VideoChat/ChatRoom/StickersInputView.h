//
//  StickersInputView.h
//  VideoChat
//
//  Created by Lee on 02/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STSSegmentedControl.h"
#import <StraaSMessagingSDK/STSChatSticker.h>
#import "StickerInputViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kStickersInputView;
static CGFloat const kStickerSegmentWidth = 55.0;
static CGFloat const kStickerSegmentHeight = 35.0;
static CGFloat const kStickerItemScrollViewHeight = 180.0;

static CGFloat const stickerItemSideLength = 62.0;
static CGFloat const viewStickerPadding = 10.0;
static CGFloat const minPaddingBetweenStickerItems = 10;


@interface StickersInputView : UIView
@property (weak, nonatomic) id<StickerInputViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *stickerGroupScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *stickerItemScrollview;
@property (nonatomic) CGFloat stickerInputViewHeight;
@property (nonatomic) STSSegmentedControl * segmentedControl;
- (void)setStickers:(NSArray <STSChatSticker *>*)stickers;

@end

NS_ASSUME_NONNULL_END
