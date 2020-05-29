//
//  STSStreamingViewController.h
//  StraaS
//
//  Created by shihwen.wang on 2016/10/28.
//  Copyright © 2020年 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, STSStreamWay) {
    STSStreamWayLiveEvent = 0,
    STSStreamWayStreamKey = 1,
    STSStreamWayStreamURL = 2,
};

@interface STSStreamingViewController : UIViewController

+ (instancetype)viewControllerFromStoryboard;

@end
