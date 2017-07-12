//
//  IconLabel.h
//  StraaS
//
//  Created by shihwen.wang on 2017/2/16.
//  Copyright © 2017年 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconLabel : UILabel

- (void)setIconImage:(UIImage *)image;

//Note: This method will override the attributedText in IconLabel, it may cause Icon Image disappear.
//If you want to show IconImage with your custom attributedText, call setIconImage after calling this method.
- (void)setAttributedText:(NSAttributedString *)attributedText;

@end
