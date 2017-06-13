//
//  STSPlayerViewController.h
//  StraaS
//
//  Created by Lee on 6/21/16.
//
//

#import <UIKit/UIKit.h>

@interface STSPlayerViewController : UIViewController

+ (instancetype)viewControllerFromStoryboard;
@property (nonatomic) NSString * JWT;

@end
