//
//  NSLayoutConstraint+LHUtility.h
//  LiveHouse
//
//  Created by Luke Jang on 12/8/15.
//  Copyright © 2019年 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (STSUtility)

+ (nonnull NSArray<NSLayoutConstraint *> *)constraintsForViews:(nonnull NSDictionary *)views
                                       horizaontalVisualFormat:(nonnull NSString *)horizontalVisualFormat
                                          verticalVisualFormat:(nonnull NSString *)verticalVisualFormat;

+ (nonnull NSArray<NSLayoutConstraint *> *)constraintsForViews:(nonnull NSDictionary *)views
                               horizaontalVisualFormat:(nonnull NSString *)horizontalVisualFormat
                                  verticalVisualFormat:(nonnull NSString *)verticalVisualFormat
                                    horizaontalOptions:(NSLayoutFormatOptions)horizaontalOptions
                                       verticalOptions:(NSLayoutFormatOptions)verticalOptions
                                               metrics:(nullable NSDictionary<NSString *,id> *)metrics;

+ (nonnull NSArray<NSLayoutConstraint *> *)centerConstraintsWithView:(nonnull UIView *)view
                                                         equalToView:(nonnull UIView *)referenceView;

+ (nonnull NSArray<NSLayoutConstraint *> *)centerConstraintsWithView:(nonnull UIView *)view
                                                         equalToView:(nonnull UIView *)referenceView
                                                            ViewSize:(CGSize)size;

+ (nonnull NSLayoutConstraint *)horizontallyCenterConstraintWithView:(nonnull UIView *)view
                                                         equalToView:(nonnull UIView *)referenceView;

+ (nonnull NSLayoutConstraint *)verticallyCenterConstraintWithView:(nonnull UIView *)view
                                                       equalToView:(nonnull UIView *)referenceView;

@end
