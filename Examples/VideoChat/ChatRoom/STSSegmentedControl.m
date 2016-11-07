//
//  STSSegmentedControl.m
//  VideoChat
//
//  Created by Lee on 07/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import "STSSegmentedControl.h"
#import "UIImage+sticker.h"

@interface STSSegmentedControl()
@property (nonatomic, nullable) NSMutableArray * buttons;
@end

@implementation STSSegmentedControl

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _buttons = [NSMutableArray array];
    _itemHeight = 35.0;
    _itemWidth = 55.0;
    _selectedSegmentIndex = 0;
}

- (void)setItems:(NSArray *)items {
    if (self.items) {
        [self resetSegmentedControl];
    }
    if (items.count == 0) {
        _items = nil;
        return;
    }
    _items = items;
    [items enumerateObjectsUsingBlock:^(NSString * mainImage, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [self buttonForSegment:idx];
        UIImage * image = [UIImage imageWithStickerMainImage:mainImage];
        [button setImage:[UIImage desaturatedImage:image] forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateSelected];
        [self.buttons addObject:button];
        [self addSubview:button];
    }];
    [self updateButotnsConstraint];
}

- (void)setItemHeight:(CGFloat)itemHeight {
    if (itemHeight == _itemHeight) {
        return;
    }
    _itemHeight = itemHeight;
    [self updateButotnsConstraint];
}

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth == _itemWidth) {
        return;
    }
    _itemWidth = itemWidth;
    [self updateButotnsConstraint];
}

- (void)updateButotnsConstraint {
    if (self.buttons.count == 0) {
        return;
    }
    NSMutableDictionary * metric = [@{@"offsetX": [NSNumber numberWithFloat:0],
                                      @"height": [NSNumber numberWithFloat:self.itemHeight],
                                      @"width": [NSNumber numberWithFloat:self.itemWidth]} mutableCopy];
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL * _Nonnull stop) {
        [NSLayoutConstraint deactivateConstraints:button.constraints];
        for (NSLayoutConstraint * constraint in button.constraints) {
            [button removeConstraint:constraint];
        }
        NSDictionary * view = @{@"button":button};
        NSArray * newConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offsetX)-[button(width)]" options:0 metrics:metric views:view];
        [NSLayoutConstraint activateConstraints:newConstraint];
        newConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button(height)]" options:0 metrics:metric views:view];
        [NSLayoutConstraint activateConstraints:newConstraint];
        [metric setValue:[NSNumber numberWithFloat:self.itemWidth*(idx+1)] forKey:@"offsetX"];
    }];
    [self setSelectedSegmentIndex:0];
}

- (UIButton *)buttonForSegment:(NSUInteger)segment
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(willSelectedButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragInside|UIControlEventTouchDragEnter|UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    button.backgroundColor = [UIColor clearColor];
    button.opaque = YES;
    button.clipsToBounds = YES;
    button.adjustsImageWhenHighlighted = NO;
    button.exclusiveTouch = YES;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = segment;
    return button;
}

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex{
    [self.buttons enumerateObjectsUsingBlock:^(UIButton  * button, NSUInteger index, BOOL * _Nonnull stop) {
        if (index == selectedSegmentIndex) {
            button.selected = YES;
            button.userInteractionEnabled = NO;
            [button setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
        } else {
            button.selected = NO;
            button.userInteractionEnabled = YES;
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }];
}

- (void)resetSegmentedControl {
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.items = nil;
}

#pragma mark - IBAction
- (void)willSelectedButton:(UIButton *)button {
    [self.delegate segmentedControl:self willSelectSegmentIndex:button.tag];
}

- (void)didSelectButton:(UIButton *)button {
    [self setSelectedSegmentIndex:button.tag];
    [self.delegate segmentedControl:self didSelectSegmentIndex:button.tag];
}

@end
