//
//  STSChatMessage+VideoChatUtility.m
//  VideoChat
//
//  Created by Luke Jang on 8/30/16.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

#import "STSChatMessage+VideoChatUtility.h"

@implementation STSChatMessage (VideoChatUtility)

- (NSString *)shortCreatedDate {
    NSDateFormatter * formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate * date = [formatter dateFromString:self.createdDate];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:date];
}

@end
