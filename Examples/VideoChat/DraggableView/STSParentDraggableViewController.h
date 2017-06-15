//
//  STSParentDraggableViewController.h
//  VideoChat
//
//  Created by Lee on 13/06/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STSParentDraggableViewControllerDelegate.h"

/**
 STSParentDraggableViewController is designed to make child view controller draggable.
 Currently not support rotation.
 */
@interface STSParentDraggableViewController : UIViewController

@property (nonatomic) UIViewController<STSParentDraggableViewControllerDelegate> * draggableViewController;
@property (nonatomic) UITapGestureRecognizer * draggableVCSingleTapGesture;

@property (nonatomic) NSArray * nonDraggableViewLayoutConstraints;
@property (nonatomic) CGRect initialDraggableRect;

@end
