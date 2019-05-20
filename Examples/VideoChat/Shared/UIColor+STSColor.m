//
//  UIColor+STSColor.m
//  StraaS
//
//  Created by Lee on 6/23/16.
//  Copyright © 2019年 StraaS.io. All rights reserved.
//

#import "UIColor+STSColor.h"

@implementation UIColor(STSColor)

+ (UIColor *)STSBarTintColor {
    return [UIColor colorWithRed:45./255. green:135./255. blue:135./255. alpha:1];
}

+ (UIColor *)LHGrey {
    return [self colorWithWhite:153./255. alpha:1.0];
}

+ (UIColor *)STSBlueButtonColor {
    return [UIColor colorWithRed:0.0 green:100./255. blue:255./255. alpha:1];
}

@end
