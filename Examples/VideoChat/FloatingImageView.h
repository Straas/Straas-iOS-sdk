//
//  FloatingImageView.h
//  VideoChat
//
//  This class is modified by referring https://github.com/saidmarouf/FloatingHearts
//
//  Created by Lee on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatingImageView : UIImageView

//This method will automatically add FloatingImageView to view and remove from view when animation finished.
- (void)animateInView:(UIView *)view;

@end
