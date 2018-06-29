//
//  STSCircallMultipleVideoConferenceViewController.h
//  StraaSDemoApp
//
//  Created by Allen and Kim on 2018/5/3.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSCircallSingleVideoCallViewController : UIViewController

@property (strong, nonatomic) NSString *streamKey;

+ (instancetype)viewControllerFromStoryboard;

@end
