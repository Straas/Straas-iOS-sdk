//
//  UIViewController+STSChildDraggable.m
//  VideoChat
//
//  Created by Lee on 14/06/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "UIViewController+STSChildDraggable.h"
#import <objc/runtime.h>

@implementation UIViewController (STSChildDraggable)

- (void)setSts_draggable:(BOOL)sts_draggable {
    SEL selector = @selector(sts_draggable);
    [self willChangeValueForKey:NSStringFromSelector(selector)];
    objc_setAssociatedObject(self, selector, @(sts_draggable), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:NSStringFromSelector(selector)];
}

- (BOOL)sts_draggable {
    NSNumber * draggable = objc_getAssociatedObject(self, @selector(sts_draggable));
    return draggable.boolValue;
}

@end
