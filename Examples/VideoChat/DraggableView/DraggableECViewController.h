//
//  DraggableECViewController.h
//  VideoChat
//
//  Created by Lee on 15/06/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "ECommerceChatViewController.h"
#import "UIViewController+STSChildDraggable.h"
#import "STSParentDraggableViewControllerDelegate.h"

@interface DraggableECViewController : ECommerceChatViewController <STSParentDraggableViewControllerDelegate>

@end
