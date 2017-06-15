//
//  DraggableECViewController.m
//  VideoChat
//
//  Created by Lee on 15/06/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "DraggableECViewController.h"

@interface DraggableECViewController ()

@end

@implementation DraggableECViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //For demo usage, tap 3 times on chatVC will trigger to make this view draggable and make it small.
    UITapGestureRecognizer * tripleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTripleView:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.chatVC.view addGestureRecognizer:tripleTap];
}

- (void)didTapTripleView:(UITapGestureRecognizer *)gesture {
    if (!self.sts_draggable) {
        self.sts_draggable = YES;
    }
}

- (void)showPlayerViewOnly {
    self.chatVC.view.hidden = YES;
    self.toolbarView.hidden = YES;
    self.showKeyboardButton.hidden = YES;
    self.likeButton.hidden = YES;
}

- (void)showAllSubviews {
    self.chatVC.view.hidden = NO;
    self.toolbarView.hidden = NO;
    self.showKeyboardButton.hidden = NO;
    self.likeButton.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma STSParentDraggableViewControllerDelegate
- (void)willChangeChildViewToDraggable {
    [self showPlayerViewOnly];
}

- (void)willChangeChildViewToUndraggable {
    [self showAllSubviews];
}

@end
