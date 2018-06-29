//
//  STSScreenshotPhoto.m
//  StraaSDemoApp
//
//  Created by Harry Hsu on 10/01/2018.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import "STSScreenshotPhoto.h"

@interface STSScreenshotPhoto ()
@property (nonatomic, nullable) UIImage * image;
@property (nonatomic, nullable) NSData *imageData;
@property (nonatomic, nullable) UIImage *placeholderImage;
@property (nonatomic, nullable) NSAttributedString *attributedCaptionTitle;
@property (nonatomic, nullable) NSAttributedString *attributedCaptionSummary;
@property (nonatomic, nullable) NSAttributedString *attributedCaptionCredit;
@end

@implementation STSScreenshotPhoto

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

@end
