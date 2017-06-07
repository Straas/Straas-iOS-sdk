//
//  TransparentMessageTableViewCell.m
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "TransparentMessageTableViewCell.h"

static const CGFloat kTransparentCellPaddingLeft = 24;
static const CGFloat kTransparentCellPaddingRight = 16;
static const CGFloat kTransparentCellPaddingTop = 7;
static const CGFloat kTransparentCellPaddingBottom = 7;

@interface TransparentMessageTableViewCell()

@property(nonatomic, strong) UILabel *bodyLabel;

@end

@implementation TransparentMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    NSMutableArray *constraints = [NSMutableArray array];
    
    // Content View
    UIView *backgroundMaskView = [UIView new];
    backgroundMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundMaskView.layer.cornerRadius = 7;
    [backgroundMaskView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    [self addSubview:backgroundMaskView];
    
    // Body Label
    _bodyLabel = [UILabel new];
    _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _bodyLabel.backgroundColor = [UIColor clearColor];
    _bodyLabel.textColor = [UIColor whiteColor];
    _bodyLabel.font = [UIFont systemFontOfSize:16];
    _bodyLabel.numberOfLines = 0;
    _bodyLabel.adjustsFontSizeToFitWidth = NO;
    _bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_bodyLabel];
    
    // Setup auto layout
    NSDictionary *metrics = @{@"left": @(kTransparentCellPaddingLeft),
                              @"right": @(kTransparentCellPaddingRight),
                              @"top": @(kTransparentCellPaddingTop),
                              @"bottom": @(kTransparentCellPaddingBottom)
                              };
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[bodyLabel]-(>=right)-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:@{@"bodyLabel":_bodyLabel}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[bodyLabel]-bottom-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:@{@"bodyLabel":_bodyLabel}]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:backgroundMaskView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_bodyLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:backgroundMaskView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_bodyLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:backgroundMaskView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_bodyLabel
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:16]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:backgroundMaskView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_bodyLabel
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:10]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Class Methods

+ (CGFloat)estimateCellHeightWithMessage:(STSChatMessage *)message widthToFit:(CGFloat)width {
    CGFloat bodyLabelWidth = width - kTransparentCellPaddingLeft - kTransparentCellPaddingRight;
    CGSize size = CGSizeMake(bodyLabelWidth, CGFLOAT_MAX);
    NSAttributedString *displayString = [self getDisplayString:message];
    CGRect estimateRect = [displayString boundingRectWithSize:size
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil];
    
    return ceil(estimateRect.size.height) + kTransparentCellPaddingTop + kTransparentCellPaddingBottom;
}

+ (NSAttributedString *)getDisplayString:(STSChatMessage *)message {
    NSString *nameString = [NSString stringWithFormat:@"%@: ", message.creator.name];
    NSString *text = [NSString stringWithFormat:@"%@%@", nameString, message.text];
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:text];
    [displayString addAttribute:NSForegroundColorAttributeName
                          value:[UIColor orangeColor]
                          range:NSMakeRange(0, nameString.length)];
    [displayString addAttribute:NSForegroundColorAttributeName
                          value:[UIColor whiteColor]
                          range:NSMakeRange(nameString.length, message.text.length)];
    [displayString addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:16]
                          range:NSMakeRange(0, text.length)];
    
    return displayString;
}

#pragma mark - Public Methods

- (void)setMessage:(STSChatMessage *)message {
    [self.bodyLabel setAttributedText:[TransparentMessageTableViewCell getDisplayString:message]];
}

@end
