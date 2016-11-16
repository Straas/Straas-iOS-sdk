//
//  StickersInputView.m
//  VideoChat
//
//  Created by Lee on 02/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import "StickersInputView.h"
#import "UIImage+sticker.h"
#import <SDWebImage/SDWebImage-umbrella.h>
#import "NSFileManager+Sticker.h"

NSString * const kStickersInputView = @"StickersInputView";

@interface StickersInputView ()<STSSegmentedControlDelegate, UIScrollViewDelegate>
@property (nonatomic, nullable) NSArray<STSChatSticker *> * stickers;
@property (nonatomic, nullable) NSMutableArray <UIScrollView *> * itemScrollView;
@property (nonatomic, nullable) NSMutableArray <NSLayoutConstraint *> * stickerItemScrollviewConstraints;
@property (nonatomic, nonnull) UILabel * noRecentlyStickerLabel;
@property (nonatomic) NSLayoutConstraint * segmentedWidthConstraint;
@property (nonatomic) BOOL shouldUpdateRecentlyScrollView;
@end

@implementation StickersInputView {
    __weak id _weakSelf;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    _weakSelf = self;
    [self.stickerGroupScrollView addSubview:self.segmentedControl];
    self.segmentedControl.delegate = self;
    self.itemScrollView = [NSMutableArray array];
    self.stickerItemScrollviewConstraints = [NSMutableArray array];
    NSArray * constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[segmentedControl(35)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"segmentedControl": self.segmentedControl}];
    [NSLayoutConstraint activateConstraints:constraints];
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.segmentedControl
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.stickerGroupScrollView
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1 constant:0]]];
    self.stickerItemScrollview.pagingEnabled = YES;
    self.stickerItemScrollview.showsHorizontalScrollIndicator = NO;
    self.stickerItemScrollview.bounces = NO;
    self.stickerItemScrollview.delegate = self;
    self.shouldUpdateRecentlyScrollView = NO;
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [_weakSelf updateItemScrollViewLayout];
}

- (STSSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [STSSegmentedControl new];
        _segmentedControl.itemWidth = kStickerSegmentWidth;
        _segmentedControl.itemHeight = kStickerSegmentHeight;
        _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _segmentedControl;
}

- (void)setStickers:(NSArray *)stickers {
    if (self.stickers.count > 0) {
        [self resetStickerInputView];
    }
    NSArray * items = [stickers valueForKey:@"mainImage"];
    _stickers = stickers;
    self.segmentedControl.items = items;
    //due to recently stickers, segment width would be items.count +1
    [self setSegmentedWidthWithItemsCount:items.count + 1];
    [self addStickerItemsScrollView];
}

- (void)setSegmentedWidthWithItemsCount:(NSInteger)itemsCount {
    if (self.segmentedWidthConstraint) {
        [NSLayoutConstraint deactivateConstraints:@[self.segmentedWidthConstraint]];
    }
    CGFloat width = kStickerSegmentWidth * itemsCount;
    self.segmentedWidthConstraint = [NSLayoutConstraint constraintWithItem:self.segmentedControl
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1 constant:width];
    [NSLayoutConstraint activateConstraints:@[self.segmentedWidthConstraint]];
}

- (void)addStickerItemsScrollView {
    [self addRecentylyUsedStickerScrollView];
    [self.stickers enumerateObjectsUsingBlock:^(STSChatSticker * _Nonnull sticker, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView * scrollView = [UIScrollView new];
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.stickerItemScrollview addSubview:scrollView];
        scrollView.pagingEnabled = NO;
        scrollView.scrollEnabled = YES;
        [sticker.stickers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            [self addButtonWithImageURL:value key:key toScrollView:scrollView];
        }];
        [self.itemScrollView addObject:scrollView];
    }];
    [self updateItemsScrollViewConstraint];
    [self.segmentedControl setSelectedSegmentIndex:0];
}

- (void)updateItemScrollViewLayout {
    if (!self.stickers) {
        return;
    }
    [self updateItemsScrollViewConstraint];
    self.noRecentlyStickerLabel.frame = self.stickerItemScrollview.frame;
    CGFloat offsetX = self.segmentedControl.selectedSegmentIndex * CGRectGetWidth(self.frame);
    CGPoint endPoint = CGPointMake(offsetX, 0.0);
    [self.stickerItemScrollview setContentOffset:endPoint animated:YES];
}

- (void)updateItemsScrollViewConstraint {
    self.stickerItemScrollview.frame = CGRectMake(0, 0, self.viewWidth, kStickerItemScrollViewHeight);
    self.stickerItemScrollview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    __block CGFloat offsetX = 0.0;
    __block CGSize contentSize = CGSizeZero;
    CGFloat paddingBetweenStickerItems = self.paddingBetweenStickerItems;
    if (self.stickerItemScrollviewConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.stickerItemScrollviewConstraints];
        [self.stickerItemScrollviewConstraints removeAllObjects];
    }
    [self.itemScrollView enumerateObjectsUsingBlock:^(UIScrollView * scrollView, NSUInteger idx, BOOL * _Nonnull stop) {
        __block CGRect frame = CGRectMake(offsetX, 0, self.viewWidth, 0);
        __block CGFloat stickerItemOffsetX = viewStickerPadding;
        __block CGFloat stickerItemOffsetY = viewStickerPadding;
        scrollView.frame = CGRectMake(offsetX, 0, self.viewWidth, CGRectGetHeight(self.stickerItemScrollview.frame));
        [self.stickerItemScrollviewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollView(height)]"
                                                                                                           options:0
                                                                                                           metrics:@{@"height": [NSNumber numberWithFloat:CGRectGetHeight(self.stickerItemScrollview.frame)]}
                                                                                                             views:@{@"scrollView":scrollView}]];
        [self.stickerItemScrollviewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offsetX)-[scrollView(width)]"
                                                                                                           options:0
                                                                                                           metrics:@{@"offsetX":[NSNumber numberWithFloat:offsetX],
                                                                                                                     @"width":[NSNumber numberWithFloat:CGRectGetWidth(frame)]}
                                                                                                             views:@{@"scrollView":scrollView}]];
        NSArray * buttons = [self buttonsInItemsScrollView:scrollView];
        [buttons enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect buttonFrame = CGRectMake(stickerItemOffsetX, stickerItemOffsetY,
                                            stickerItemSideLength, stickerItemSideLength);
            [button setFrame:buttonFrame];
            if ((idx+1) % self.stickerItemsInOneRaw == 0) {
                stickerItemOffsetY += paddingBetweenStickerItems + stickerItemSideLength;
                stickerItemOffsetX = viewStickerPadding;
            } else {
                stickerItemOffsetX += stickerItemSideLength + paddingBetweenStickerItems;
            }
        }];
        frame.size.height = (paddingBetweenStickerItems + stickerItemSideLength) * ((buttons.count-1) / self.stickerItemsInOneRaw + 1);
        scrollView.contentSize = frame.size;
        offsetX += self.viewWidth;
    }];
    [NSLayoutConstraint activateConstraints:self.stickerItemScrollviewConstraints];
    contentSize = CGSizeMake(offsetX, self.stickerItemScrollview.frame.size.height);
    self.stickerItemScrollview.contentSize = contentSize;
}

- (void)addButtonWithImageURL:(NSString *)imageURL key:(NSString *)key toScrollView:(UIScrollView *)scrollView {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal
              placeholderImage:[UIImage imageNamed:@"img_sticker_default"] options:SDWebImageRefreshCached];
    [button setTitle:key forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickStickerItemButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
}

- (void)resetStickerInputView {
    _stickers = @[];
    [self.segmentedControl.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.stickerItemScrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemScrollView removeAllObjects];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"bounds"];
}

#pragma mark - recentlyUsedSticker
- (void)addRecentylyUsedStickerScrollView {
    UIScrollView * scrollView = [UIScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.pagingEnabled = NO;
    scrollView.scrollEnabled = YES;
    [scrollView addSubview:self.noRecentlyStickerLabel];
    [self setupRecentlyUsedStickerScrollViewSubviews:scrollView];
    [self.itemScrollView addObject:scrollView];
    [self.stickerItemScrollview addSubview:scrollView];
}

- (void)setupRecentlyUsedStickerScrollViewSubviews:(UIScrollView *)scrollView {
    NSArray <NSDictionary *>* recentlyUsedSticker = [NSFileManager getRecentlyUsedStickerItems];
    if (recentlyUsedSticker.count > 0) {
        self.noRecentlyStickerLabel.hidden = YES;
        [recentlyUsedSticker enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addButtonWithImageURL:obj.allValues[0] key:obj.allKeys[0] toScrollView:scrollView];
        }];
    } else {
        self.noRecentlyStickerLabel.hidden = NO;
    }
}

- (UILabel *)noRecentlyStickerLabel {
    if (!_noRecentlyStickerLabel) {
        UILabel * label = [UILabel new];
        label.text = NSLocalizedString(@"Recent Stickers", nil);
        label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentCenter;
        _noRecentlyStickerLabel = label;
    }
    return _noRecentlyStickerLabel;
}

- (void)reloadRecentlyUsedStickerScrollView {
    if ((self.segmentedControl.selectedSegmentIndex == 0) && self.shouldUpdateRecentlyScrollView) {
        return;
    }
    UIScrollView * recentlyUsedScrollView= self.itemScrollView[0];
    NSArray * buttons = [self buttonsInItemsScrollView:recentlyUsedScrollView];
    [buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setupRecentlyUsedStickerScrollViewSubviews:recentlyUsedScrollView];
    buttons = [self buttonsInItemsScrollView:recentlyUsedScrollView];
    __block CGFloat stickerItemOffsetX = viewStickerPadding;
    __block CGFloat stickerItemOffsetY = viewStickerPadding;
    CGFloat paddingBetweenStickerItems = self.paddingBetweenStickerItems;
    [buttons enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect buttonFrame = CGRectMake(stickerItemOffsetX, stickerItemOffsetY,
                                        stickerItemSideLength, stickerItemSideLength);
        [button setFrame:buttonFrame];
        if ((idx+1) % self.stickerItemsInOneRaw == 0) {
            stickerItemOffsetY += paddingBetweenStickerItems + stickerItemSideLength;
            stickerItemOffsetX = viewStickerPadding;
        } else {
            stickerItemOffsetX += stickerItemSideLength + paddingBetweenStickerItems;
        }
    }];
    self.shouldUpdateRecentlyScrollView = NO;
}

- (NSString *)imageURLWithStickerText:(NSString *)text {
    for (STSChatSticker * sticker in self.stickers) {
        if ([sticker.stickers valueForKey:text]) {
            return [sticker.stickers valueForKey:text];
        }
    }
    return nil;
}

#pragma mark - Accessor
- (CGFloat)viewWidth {
    return CGRectGetWidth(self.frame);
}

- (NSUInteger)stickerItemsInOneRaw {
    return (self.viewWidth - 2 * viewStickerPadding + minPaddingBetweenStickerItems)/(stickerItemSideLength + minPaddingBetweenStickerItems);
}

- (CGFloat)paddingBetweenStickerItems {
    NSUInteger stickerItemsInOneRaw = self.stickerItemsInOneRaw;
    NSUInteger paddingBetweenStickerItemCount = stickerItemsInOneRaw - 1;
    return ((self.viewWidth - 2 * viewStickerPadding - stickerItemSideLength * stickerItemsInOneRaw) / paddingBetweenStickerItemCount);
}

- (NSArray <UIButton *>*)buttonsInItemsScrollView:(UIScrollView *)scrollView {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@",[UIButton class]];
    return [scrollView.subviews filteredArrayUsingPredicate:predicate];
}

#pragma mark - IBAction
- (IBAction)didClickStickerItemButton:(UIButton *)button {
    self.shouldUpdateRecentlyScrollView = YES;
    NSString * stickerText = button.currentTitle;
    NSString * imageURL = [self imageURLWithStickerText:stickerText];
    [NSFileManager addRecentlyUsedStickerItem:@{stickerText: imageURL}];
    [self reloadRecentlyUsedStickerScrollView];
    if ([self.delegate respondsToSelector:@selector(didSelectStickerKey:imageURL:)]) {
        [self.delegate didSelectStickerKey:stickerText imageURL:imageURL];
    }
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger page = offsetX / CGRectGetWidth(scrollView.frame);
    [self.segmentedControl setSelectedSegmentIndex:page];
}

#pragma mark - STSSegmentedControlDelegate methods

- (void)segmentedControl:(STSSegmentedControl *)segmentedControl didSelectSegmentIndex:(NSUInteger)index {
    CGFloat offsetX = index * CGRectGetWidth(self.frame);
    CGPoint endPoint = CGPointMake(offsetX, 0.0);
    [self reloadRecentlyUsedStickerScrollView];
    [self.stickerItemScrollview setContentOffset:endPoint animated:YES];
}

@end
