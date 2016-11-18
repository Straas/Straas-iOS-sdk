//
//  STSSegmentedControl.h
//  VideoChat
//
//  Created by Lee on 07/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STSSegmentedControl;

@protocol STSSegmentedControlDelegate <NSObject>
- (void)segmentedControl:(STSSegmentedControl *)segmentedControl didSelectSegmentIndex:(NSUInteger)index;
@end

@interface STSSegmentedControl : UIControl

@property (weak ,nonatomic) id<STSSegmentedControlDelegate> delegate;
@property (nonatomic) NSArray * items;
@property (nonatomic) NSUInteger selectedSegmentIndex;
@property (nonatomic, readwrite) CGFloat itemHeight;
@property (nonatomic, readwrite) CGFloat itemWidth;

@end
