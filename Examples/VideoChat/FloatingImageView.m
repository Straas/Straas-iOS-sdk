//
//  FloatingImageView.m
//  VideoChat
//
//  Created by Lee on 25/05/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "FloatingImageView.h"

const NSTimeInterval floatingTime = 2.0;
const NSTimeInterval bloomingTime = 0.5;

@implementation FloatingImageView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        //Do nothig.
    }
    return self;
}

- (void)animateInView:(UIView *)view {
    [view addSubview:self];
    [self prepareForAnimation];
    [self performBloomAnimation];
    [self performSlightRotationAnimationWithDirection:[self getRandomDirection]];
    [self addPathAnimationInView:view path:self.travelPath];
}

- (void)prepareForAnimation {
    self.transform = CGAffineTransformMakeScale(0, 0);
    self.alpha = 0;
}

- (void)performBloomAnimation {
    [UIView animateWithDuration:bloomingTime delay:0 usingSpringWithDamping:0.6
          initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 0.9;
    } completion:nil];
}

- (void)performSlightRotationAnimationWithDirection:(NSInteger)direction {
    CGFloat randomFloat = arc4random_uniform(10);
    CGFloat angle = direction * M_PI / (16 + randomFloat * 0.2);
    [UIView animateWithDuration:bloomingTime animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
    }];
}

- (void)addPathAnimationInView:(UIView *)view path:(UIBezierPath *)path {
    CAKeyframeAnimation * keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = path.CGPath;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSTimeInterval durationAdjustment = 4 * (path.bounds.size.height / view.bounds.size.height);
    NSTimeInterval duration = floatingTime + durationAdjustment;
    keyFrameAnimation.duration = duration;
    [self.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIBezierPath *)travelPath {
    NSInteger endPointDirection = [self getRandomDirection];
    
    CGFloat centerX = self.center.x;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    //random end point.
    CGFloat endPointX = centerX + (endPointDirection * arc4random_uniform(2 * width));
    CGFloat endPointY = height/ 8.0 + arc4random_uniform(height/4.0);
    CGPoint endPoint = CGPointMake(endPointX, endPointY);
    
    //random control points.
    NSInteger travelDirection = [self getRandomDirection];
    CGFloat xDelta = (width / 2.0 + arc4random_uniform(2 * width)) * travelDirection;
    CGFloat yDelta = MAX(endPointY, MAX(arc4random_uniform(8 * width), width));
    CGPoint controlPoint1 = CGPointMake(centerX + xDelta, height - yDelta);
    CGPoint controlPoint2 = CGPointMake(centerX - 2 * xDelta, yDelta);
    UIBezierPath * path = [UIBezierPath new];
    [path moveToPoint:self.center];
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    return path;
}

- (NSInteger)getRandomDirection {
    NSInteger randomInt = arc4random_uniform(2);
    return 1 - 2 * randomInt;
}
@end
