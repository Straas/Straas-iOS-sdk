//
//  UIViewController+STSChildDraggable.h
//  VideoChat
//
//  Created by Lee on 14/06/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This category is paired with STSParentDraggableViewController.
 */
@interface UIViewController (STSChildDraggable)

/**
 sts_draggable property is designed to be STSParentDraggableViewController observed.
 Set this property to YES will trigger STSParentDraggableViewController change the childView/childViewController's position and enable/disable draggable.
 Do not use custom setter & getter to set/get `sts_draggable` when use this property.
 */
@property (nonatomic) BOOL sts_draggable;

@end
