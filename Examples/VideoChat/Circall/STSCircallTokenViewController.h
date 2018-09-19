//
//  STSCircallTokenViewController.h
//  StraaSDemoApp
//
//  Created by Allen on 2018/5/2.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, STSCircallTokenViewControllerType){
    STSCircallTokenViewControllerTypeSingleVideoCall,
    STSCircallTokenViewControllerTypeIPCamBroadcastingViewer,
    STSCircallTokenViewControllerTypeIPCamBroadcastingHost
};

@interface STSCircallTokenViewController : UIViewController

@property (nonatomic, assign) STSCircallTokenViewControllerType type;

+ (instancetype)viewControllerFromStoryboard;

@end
