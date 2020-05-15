//
//  STSStreamingStatsReport+Internal.h
//  StraaS
//
//  Created by Harry Hsu on 13/10/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import "STSStreamingStatsReport.h"

@interface STSStreamingStatsReport()

@property (nonatomic, readwrite) NSUInteger currentBitrate;
@property (nonatomic, readwrite) CGFloat currentFPS;

@end
