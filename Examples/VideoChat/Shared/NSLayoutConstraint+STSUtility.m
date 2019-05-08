//
//  NSLayoutConstraint+LHUtility.m
//  LiveHouse
//
//  Created by Luke Jang on 12/8/15.
//  Copyright © 2019年 StraaS.io. All rights reserved.
//

#import "NSLayoutConstraint+STSUtility.h"

@implementation NSLayoutConstraint (STSUtility)

+ (NSArray<NSLayoutConstraint *> *)constraintsForViews:(NSDictionary *)views
                               horizaontalVisualFormat:(NSString *)horizontalVisualFormat
                                  verticalVisualFormat:(NSString *)verticalVisualFormat {
    return [[self class] constraintsForViews:views
                     horizaontalVisualFormat:horizontalVisualFormat
                        verticalVisualFormat:verticalVisualFormat
                          horizaontalOptions:0
                             verticalOptions:0
                                     metrics:nil];
}

+ (NSArray<NSLayoutConstraint *> *)constraintsForViews:(NSDictionary *)views
                               horizaontalVisualFormat:(NSString *)horizontalVisualFormat
                                  verticalVisualFormat:(NSString *)verticalVisualFormat
                                    horizaontalOptions:(NSLayoutFormatOptions)horizaontalOptions
                                       verticalOptions:(NSLayoutFormatOptions)verticalOptions
                                               metrics:(nullable NSDictionary<NSString *,id> *)metrics {
    NSString * formatString;
    NSMutableArray * constraints = [NSMutableArray array];
    formatString = [NSString stringWithFormat:@"H:%@", horizontalVisualFormat];
    [constraints addObjectsFromArray:[self constraintsWithVisualFormat:formatString
                                                               options:horizaontalOptions
                                                               metrics:metrics
                                                                 views:views]];
    formatString = [NSString stringWithFormat:@"V:%@", verticalVisualFormat];
    [constraints addObjectsFromArray:[self constraintsWithVisualFormat:formatString
                                                               options:verticalOptions
                                                               metrics:metrics
                                                                 views:views]];
    return [constraints copy];
}

+ (NSArray<NSLayoutConstraint *> *)centerConstraintsWithView:(UIView *)view
                                                 equalToView:(UIView *)referenceView {
    return @[[self horizontallyCenterConstraintWithView:view equalToView:referenceView],
             [self verticallyCenterConstraintWithView:view equalToView:referenceView]];
}

+ (NSArray<NSLayoutConstraint *> *)centerConstraintsWithView:(UIView *)view
                                                 equalToView:(UIView *)referenceView
                                                    ViewSize:(CGSize)size {
    return @[[NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1.0 constant:size.width],
             [NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1.0
                                           constant:size.height],
             [self horizontallyCenterConstraintWithView:view equalToView:referenceView],
             [self verticallyCenterConstraintWithView:view equalToView:referenceView]];
    
}

+ (NSLayoutConstraint *)horizontallyCenterConstraintWithView:(UIView *)view equalToView:(UIView *)referenceView {
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:referenceView
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1.
                                         constant:0.];
}

+ (NSLayoutConstraint *)verticallyCenterConstraintWithView:(UIView *)view equalToView:(UIView *)referenceView {
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:referenceView
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1.
                                         constant:0.];
}

@end
