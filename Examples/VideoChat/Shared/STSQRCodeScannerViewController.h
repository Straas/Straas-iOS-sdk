//
//  QRCodeScannerViewController.h
//  LFLiveKitSample
//
//  Created by shihwen.wang on 2017/8/18.
//  Copyright © 2020年 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, STSStreamWay);

@class STSQRCodeScannerViewController;

@protocol STSQRCodeScannerViewControllerDelegate <NSObject>
- (void)scanner:(STSQRCodeScannerViewController *)scanner didGetQRCode:(NSString *)qrCode;
@end

@interface STSQRCodeScannerViewController : UIViewController

@property (nonatomic, weak) id<STSQRCodeScannerViewControllerDelegate> delegate;

@property (nonatomic, assign) STSStreamWay streamWay;

@end
