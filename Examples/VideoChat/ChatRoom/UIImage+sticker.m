//
//  UIImage+sticker.m
//  VideoChat
//
//  Created by Lee on 03/11/2016.
//  Copyright © 2016 StraaS.io. All rights reserved.
//

#import "UIImage+sticker.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation UIImage (sticker)
+ (instancetype)imageWithStickerMainImage:(NSString *)mainImage {
    SDWebImageManager * sharedManager = [SDWebImageManager sharedManager];
    UIImage * cacheImage = [sharedManager.imageCache imageFromDiskCacheForKey:mainImage];
    if (!cacheImage) {
        NSURL * url = [NSURL URLWithString:mainImage];
        NSData * data = [NSData dataWithContentsOfURL:url];
        UIImage * image = [UIImage imageWithImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(stickerMainImageSideLength, stickerMainImageSideLength)];
        [sharedManager saveImageToCache:image forURL:url];
        return image;
    }
    if (cacheImage.size.height != stickerMainImageSideLength || cacheImage.size.width != stickerMainImageSideLength) {
        cacheImage = [UIImage imageWithImage:cacheImage scaledToSize:CGSizeMake(stickerMainImageSideLength, stickerMainImageSideLength)];
    }
    return cacheImage;
}

+ (instancetype)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (instancetype)desaturatedImage:(UIImage *)image {
    CIImage * inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter * filter = [CIFilter filterWithName:@"CIColorControls"
                             withInputParameters:@{@"inputImage": inputImage,
                                                   @"inputSaturation": @0}];
    CIImage * outputImage = [filter valueForKey:@"outputImage"];
    return [UIImage imageWithCIImage:outputImage scale:image.scale orientation:image.imageOrientation];
}


@end
