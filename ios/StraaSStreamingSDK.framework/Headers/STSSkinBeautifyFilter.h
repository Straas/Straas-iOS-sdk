//
//  STSSkinBeautifyFilter.h
//  StraaSStreamingSDK
//
//  Created by Allen on 2019/1/17.
//  Copyright © 2019 StraaS.io. All rights reserved.
//

#import <DSGPUImage/GPUImageFramework.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSSkinBeautifyFilter : GPUImageFilter

/**
 *  The class method to create a STSSkinBeautifyFilter instance with default skin smoothness level 0.5, brightness level 0.5.
 */
+ (STSSkinBeautifyFilter *)filter;

/**
 *   The class method to create a STSSkinBeautifyFilter.
 *   @param skinSmoothnessLevel The skin smoothness level.
 *   @param brightnessLevel The brightness level.
 *   @return The instance of the STSSkinBeautifyFilter.
 */
+ (STSSkinBeautifyFilter *)filterWithSkinSmoothnessLevel:(CGFloat)skinSmoothnessLevel brightnessLevel:(CGFloat)brightnessLevel;

/**
 *  The skin smoothness level. The default value is 0.5. Suggested value is between 0 to 2.
 */
@property (nonatomic, assign) CGFloat skinSmoothnessLevel;

/**
 *  The brightness level. The default value is 0.5. Suggested value is between 0 to 1.
 */
@property (nonatomic, assign) CGFloat brightnessLevel;

/**
 *  Using init to create a STSSkinBeautifyFilter instance is unavailable.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Using new to create a STSSkinBeautifyFilter instance is unavailable.
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 *  Using initWithFragmentShaderFromFile to create a STSSkinBeautifyFilter instance is unavailable.
 */
- (instancetype)initWithFragmentShaderFromFile:(NSString *)fragmentShaderFilename NS_UNAVAILABLE;

/**
 *  Using initWithFragmentShaderFromString to create a STSSkinBeautifyFilter instance is unavailable.
 */
- (instancetype)initWithFragmentShaderFromString:(NSString *)fragmentShaderString NS_UNAVAILABLE;

/**
 *  Using initWithVertexShaderFromString to create a STSSkinBeautifyFilter instance is unavailable.
 */
-(id)initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
