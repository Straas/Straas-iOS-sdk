//
//  TransparentMessageTableViewCell.m
//  VideoChat
//
//  Created by Harry on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "TransparentMessageTableViewCell.h"

@interface TransparentMessageTableViewCell()

@property(nonatomic, strong) UIView *containerView;
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
    _containerView = [UIView new];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.layer.cornerRadius = 7;
    [_containerView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    [self addSubview:_containerView];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[containerView(30)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"containerView":_containerView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[containerView]-3-|"
                                                                             options:0
                                                                             metrics:nil
                                                      views:@{@"containerView":_containerView}]];
    
    // Body Label
    _bodyLabel = [UILabel new];
    _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _bodyLabel.backgroundColor = [UIColor clearColor];
    _bodyLabel.textColor = [UIColor whiteColor];
    _bodyLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_bodyLabel];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_bodyLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_containerView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_bodyLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_containerView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setBodyAttributedText:(NSAttributedString*)text {
    
    [self.bodyLabel setAttributedText:text];
    [self.bodyLabel sizeToFit];
    
    CGRect frame = self.containerView.frame;
    CGFloat containerWidth = self.bodyLabel.frame.size.width + 22;
    frame.size.width = containerWidth;
    
    NSArray *constraints = self.containerView.constraints;
    for(NSLayoutConstraint *constraint in constraints) {
        if([constraint isMemberOfClass:[NSLayoutConstraint class]] &&
           constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = containerWidth;
            break;
        }
    }
}

@end
