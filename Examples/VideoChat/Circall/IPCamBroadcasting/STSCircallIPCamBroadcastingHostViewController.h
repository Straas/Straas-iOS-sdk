//
//  STSCircallIPCamBroadcastingHostViewController.h
//  StraaSDemoApp
//
//  Created by Allen on 2018/9/10.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSCircallIPCamBroadcastingHostViewController : UIViewController

@property (strong, nonatomic) NSString *circallToken;
@property (strong, nonatomic) NSURL *url;

+ (instancetype)viewControllerFromStoryboard;

@end

NS_ASSUME_NONNULL_END
