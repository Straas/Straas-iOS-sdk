//
//  NSTimer+SafeTimer.m
//  VideoChat
//
//  Created by Lee on 18/03/2017.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import "NSTimer+SafeTimer.h"

@implementation NSTimer (SafeTimer)
+ (NSTimer*)safeScheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(safeBlockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)safeBlockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
