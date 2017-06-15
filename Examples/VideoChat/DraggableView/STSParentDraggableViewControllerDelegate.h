//
//  STSParentDraggableViewControllerDelegate.h
//  VideoChat
//
//  Created by Lee on 15/06/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 STSParentDraggableViewControllerDelegate is designed to let STSParentDraggableViewController's draggableViewController to conform.
 */
@protocol STSParentDraggableViewControllerDelegate <NSObject>

- (void)willChangeChildViewToDraggable;
- (void)willChangeChildViewToUndraggable;

@end
