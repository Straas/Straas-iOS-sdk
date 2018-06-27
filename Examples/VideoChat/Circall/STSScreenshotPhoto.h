//
//  STSScreenshotPhoto.h
//  StraaSDemoApp
//
//  Created by Harry Hsu on 10/01/2018.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NYTPhotoViewer/NYTPhoto.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSScreenshotPhoto : NSObject <NYTPhoto>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
