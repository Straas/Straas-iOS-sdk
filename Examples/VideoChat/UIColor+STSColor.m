//
//  UIColor+STSColor.m
//  StraaS
//
//  Created by Lee on 6/23/16.
//
//

#import "UIColor+STSColor.h"

@implementation UIColor(STSColor)

+ (UIColor *)STSBarTintColor {
    return [UIColor colorWithRed:45./255. green:135./255. blue:135./255. alpha:1];
}

+ (UIColor *)LHGrey {
    return [self colorWithWhite:153./255. alpha:1.0];
}

@end
