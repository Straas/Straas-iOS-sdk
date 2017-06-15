//
//  STSParentDraggableViewController.m
//  VideoChat
//
//  Created by Lee on 13/06/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "STSParentDraggableViewController.h"
#import "UIViewController+STSChildDraggable.h"
#import <UIView_draggable/UIView+draggable-umbrella.h>

CGFloat const defaultDraggableViewHeight = 160.0;
CGFloat const defaultDraggableViewWidth = 90.0;
CGFloat const dafaultDraggableViewPadding = 50.0;

void * STSChildDraggableObserveKey = &STSChildDraggableObserveKey;

@interface STSParentDraggableViewController () <UIGestureRecognizerDelegate>

@end

@implementation STSParentDraggableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.initialDraggableRect = CGRectMake(self.view.frame.size.width - defaultDraggableViewWidth,
                                           self.view.frame.size.height - defaultDraggableViewHeight - dafaultDraggableViewPadding,
                                           defaultDraggableViewWidth, defaultDraggableViewHeight);
}

- (void)dealloc {
    [self.draggableViewController removeObserver:self
                                      forKeyPath:NSStringFromSelector(@selector(sts_draggable))
                                         context:STSChildDraggableObserveKey];
}

#pragma mark - Accessors

- (void)setDraggableViewController:(UIViewController <STSParentDraggableViewControllerDelegate>*)draggableViewController {
    [self removeDraggableViewController:_draggableViewController];
    draggableViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    _draggableViewController = draggableViewController;
    [self addDraggableViewController:draggableViewController];
}

- (UIView *)draggableView {
    return self.draggableViewController.view;
}

- (NSArray *)nonDraggableViewLayoutConstraints {
    if (!_nonDraggableViewLayoutConstraints) {
        NSMutableArray * constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[draggableView]-0-|"
                                                                                 options:0 metrics:nil views:@{@"draggableView":self.draggableView}]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[draggableView]-0-|"
                                                                                 options:0 metrics:nil views:@{@"draggableView":self.draggableView}]];
        _nonDraggableViewLayoutConstraints = [constraints copy];
    }
    return _nonDraggableViewLayoutConstraints;
}

#pragma mark - Internal methods

- (void)addDraggableViewController:(UIViewController *)vc {
    if (!vc) {
        return;
    }
    [vc.view enableDragging];
    vc.view.cagingArea = self.view.frame;
    [self addTapGestureToView:vc.view];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc addObserver:self
         forKeyPath:NSStringFromSelector(@selector(sts_draggable))
            options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
            context:STSChildDraggableObserveKey];
    [self updateDraggableViewControllerConstraintsWithDraggable:NO animated:NO];
}

- (void)removeDraggableViewController:(UIViewController *)vc {
    if (!vc || ![self.childViewControllers containsObject:vc]) {
        return;
    }
    [vc removeFromParentViewController];
    [self.view removeFromSuperview];
}

- (void)updateDraggableViewControllerConstraintsWithDraggable:(BOOL)draggable animated:(BOOL)animated {
    if (draggable) {
        [NSLayoutConstraint deactivateConstraints:self.nonDraggableViewLayoutConstraints];
        self.draggableViewController.view.frame = self.initialDraggableRect;
        [self.draggableViewController willChangeChildViewToDraggable];
    } else {
        self.draggableViewController.view.frame = self.view.frame;
        [NSLayoutConstraint activateConstraints:self.nonDraggableViewLayoutConstraints];
        [self.draggableViewController willChangeChildViewToUndraggable];
    }
    self.draggableViewController.view.translatesAutoresizingMaskIntoConstraints = draggable;
    [self.draggableViewController.view setDraggable:draggable];
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
           [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - IBAction

- (void)addTapGestureToView:(UIView *)view {
    UITapGestureRecognizer * gesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDraggableView:)];
    [gesture setDelegate:self];
    [view addGestureRecognizer:gesture];
    self.draggableVCSingleTapGesture = gesture;
}

- (void)didTapDraggableView:(UITapGestureRecognizer *)sender {
    self.draggableViewController.sts_draggable = NO;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (context == STSChildDraggableObserveKey) {
        if ([newValue boolValue] == [oldValue boolValue]) {
            return;
        }
        [self updateDraggableViewControllerConstraintsWithDraggable:[newValue boolValue]
                                                           animated:YES];
    }
}

@end
