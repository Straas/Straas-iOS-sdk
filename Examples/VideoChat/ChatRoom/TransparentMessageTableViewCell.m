//
//  TransparentMessageTableViewCell.m
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import "TransparentMessageTableViewCell.h"
#import "IconLabel.h"

CGFloat const kTransparentCellLabelPaddingLeft = 20;
CGFloat const kTransparentCellLabelPaddingRight = 16;
CGFloat const kTransparentCellLabelPaddingTop = 7;
CGFloat const kTransparentCellLabelPaddingBottom = 7;

CGFloat const kTransparentCellBackgroundMaskHorizontalPadding = 8;
CGFloat const kTransparentCellBackgroundMaskVerticalPadding = 5;

@interface TransparentMessageTableViewCell()

@property(nonatomic, strong) IconLabel *bodyLabel;

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
    _bodyLabel = [IconLabel new];
    _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _bodyLabel.backgroundColor = [UIColor clearColor];
    _bodyLabel.textColor = [UIColor whiteColor];
    _bodyLabel.font = [UIFont systemFontOfSize:16];
    _bodyLabel.numberOfLines = 0;
    _bodyLabel.adjustsFontSizeToFitWidth = NO;
    _bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_bodyLabel];
    
    // Setup auto layout
    NSDictionary *metrics = @{@"left": @(kTransparentCellLabelPaddingLeft),
                              @"right": @(kTransparentCellLabelPaddingRight),
                              @"top": @(kTransparentCellLabelPaddingTop),
                              @"bottom": @(kTransparentCellLabelPaddingBottom)
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
                                                         constant:2 * kTransparentCellBackgroundMaskHorizontalPadding]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:backgroundMaskView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_bodyLabel
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:2 * kTransparentCellBackgroundMaskVerticalPadding]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Class Methods
+ (CGFloat)estimateCellHeightWithMessage:(STSChatMessage *)message widthToFit:(CGFloat)width {
    CGFloat bodyLabelWidth = width - kTransparentCellLabelPaddingLeft - kTransparentCellLabelPaddingRight;
    CGSize size = CGSizeMake(bodyLabelWidth, CGFLOAT_MAX);
    NSAttributedString *displayString = [self getDisplayString:message];
    CGRect estimateRect = [displayString boundingRectWithSize:size
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil];
    
    return ceil(estimateRect.size.height) + kTransparentCellLabelPaddingTop + kTransparentCellLabelPaddingBottom;
}

+ (NSAttributedString *)getDisplayString:(STSChatMessage *)message {
    NSString *nameString = [NSString stringWithFormat:@"%@: ", message.creator.name];
    NSString *text = [NSString stringWithFormat:@"%@%@", nameString, message.text];
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [displayString addAttribute:NSForegroundColorAttributeName
                          value:[self textColorForRole:message.creator.role]
                          range:NSMakeRange(0, nameString.length)];
    [displayString addAttribute:NSForegroundColorAttributeName
                          value:[UIColor whiteColor]
                          range:NSMakeRange(nameString.length, message.text.length)];
    [displayString addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:16]
                          range:NSMakeRange(0, text.length)];
    
    return displayString;
}
#pragma mark - Private Methods

+ (UIImage *)iconImageForRole:(NSString *)userRole {
    if ([userRole isEqualToString:kSTSUserRoleNormal] ||
        [userRole isEqualToString:kSTSUserRoleBlocked]) {
        return nil;
    } else if ([userRole isEqualToString:kSTSUserRoleMaster]) {
        return [UIImage imageNamed:@"ic_host_chatroom"];
    } else {
        return [UIImage imageNamed:@"ic_moderator_chatroom"];
    }
}

+ (UIColor *)textColorForRole:(NSString *)userRole {
    if ([userRole isEqualToString:kSTSUserRoleNormal] ||
        [userRole isEqualToString:kSTSUserRoleBlocked]) {
        return [UIColor colorWithRed:81./255. green:192./255. blue:194./255. alpha:1];
    } else if ([userRole isEqualToString:kSTSUserRoleMaster]) {
        return [UIColor colorWithRed:242.0/255.0 green:154.0/255.0 blue:11.0/255.0 alpha:1];
    } else {
        return [UIColor colorWithRed:123.0/255.0 green:75.0/255.0 blue:163.0/255.0 alpha:1];
    }
}


#pragma mark - Public Methods

- (void)setMessage:(STSChatMessage *)message {
    NSString * creatorRole = message.creator.role;
    [self.bodyLabel setAttributedText:[TransparentMessageTableViewCell getDisplayString:message]];
    [self.bodyLabel setIconImage:[TransparentMessageTableViewCell iconImageForRole:creatorRole]];
}

@end
