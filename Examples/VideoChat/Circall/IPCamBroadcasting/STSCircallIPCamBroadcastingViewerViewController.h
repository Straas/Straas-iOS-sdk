//
//  STSCircallIPCamBroadcastingViewerViewController.h
//  StraaSDemoApp
//
//  Created by Allen and Kim on 2018/9/7.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSCircallIPCamBroadcastingViewerViewController : UIViewController

@property (strong, nonatomic) NSString *circallToken;

+ (instancetype)viewControllerFromStoryboard;

@end

NS_ASSUME_NONNULL_END
