//
//  STSSegmentedControl.m
//  VideoChat
//
//  Created by Lee on 07/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import "STSSegmentedControl.h"
#import "UIImage+sticker.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface STSSegmentedControl()
@property (nonatomic, nullable) NSMutableArray * buttons;
@end

@interface UIButton (SegmentedButton)
- (void)selectSegmentedButton;
- (void)unselectSegmentedButton;
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
    [self addRecentlyUsedButton];
    [items enumerateObjectsUsingBlock:^(NSString * mainImage, NSUInteger idx, BOOL * _Nonnull stop) {
        // +1 since the index 0 is recently used sticker button.
        UIButton * button = [self buttonForSegment:(idx+1)];
        __weak UIButton * weakButton = button;
        UIImage * placeholderImage = [UIImage imageNamed:@"img_sticker_default"];
        NSURL * mainImageURL = [NSURL URLWithString:mainImage];
        [button sd_setImageWithURL:mainImageURL forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImage * mainImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(30.0, 30.0)];
            [weakButton setImage:mainImage forState:UIControlStateSelected];
            [weakButton setImage:[UIImage desaturatedImage:mainImage] forState:UIControlStateNormal];
        }];
        [button unselectSegmentedButton];
        [self.buttons addObject:button];
        [self addSubview:button];
    }];
    [self updateButtonsConstraint];
    [self.buttons[0] selectSegmentedButton];
}

- (void)addRecentlyUsedButton {
    UIButton * button = [self buttonForSegment:0];
    [button setImage:[UIImage imageNamed:@"btn-ic-history_g"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn-ic-history_w"] forState:UIControlStateSelected];
    [self.buttons addObject:button];
    [self addSubview:button];
}

- (void)setItemHeight:(CGFloat)itemHeight {
    if (itemHeight == _itemHeight) {
        return;
    }
    _itemHeight = itemHeight;
    [self updateButtonsConstraint];
}

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth == _itemWidth) {
        return;
    }
    _itemWidth = itemWidth;
    [self updateButtonsConstraint];
}

- (void)updateButtonsConstraint {
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
}

- (UIButton *)buttonForSegment:(NSUInteger)segment
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
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
    if(_selectedSegmentIndex == selectedSegmentIndex) {
        return;
    }
    UIButton * unselectedButton = [self.buttons objectAtIndex:self.selectedSegmentIndex];
    UIButton * selectedButton = [self.buttons objectAtIndex:selectedSegmentIndex];
    
    [unselectedButton unselectSegmentedButton];
    [selectedButton selectSegmentedButton];
    _selectedSegmentIndex = selectedSegmentIndex;
}

- (void)resetSegmentedControl {
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    _items = nil;
}

#pragma mark - IBAction

- (void)didSelectButton:(UIButton *)button {
    [self setSelectedSegmentIndex:button.tag];
    [self.delegate segmentedControl:self didSelectSegmentIndex:button.tag];
}

@end


@implementation UIButton (SegmentedButton)
- (void)selectSegmentedButton {
    self.selected = YES;
    self.userInteractionEnabled = NO;
    [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
};

- (void)unselectSegmentedButton {
    self.selected = NO;
    self.userInteractionEnabled = YES;
    [self setBackgroundColor:[UIColor whiteColor]];
}

@end
