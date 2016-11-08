//
//  StreamingViewController.h
//  VideoChat
//
//  Created by shihwen.wang on 2016/11/7.
//  Copyright © 2016年 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamingViewController : UIViewController

@property (nonatomic) UITextField * titleInput;
@property (nonatomic) UITextField * synopsisInput;
@property (nonatomic) UIButton * startButton;
@property (nonatomic) UIButton * cameraButton;
@property (nonatomic) UILabel * statusLabel;
@property (nonatomic) UIView * previewView;

@end
