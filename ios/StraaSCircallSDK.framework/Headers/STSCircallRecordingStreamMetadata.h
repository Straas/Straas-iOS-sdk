//
//  STSCircallRecordingStreamMetadata.h
//  StraaSCircallSDK
//
//  Created by Allen on 2018/8/3.
//  Copyright © 2018 StraaS.io. All rights reserved.
//

#import <StraaSCoreSDK/LHDataObject.h>

@interface STSCircallRecordingStreamMetadata : LHDataObject

@property (strong, nonatomic) NSString *streamId;
@property (strong, nonatomic) NSString *recordingId;

@end
