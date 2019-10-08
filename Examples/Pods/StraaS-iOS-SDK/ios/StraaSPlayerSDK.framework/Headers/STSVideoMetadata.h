//
//  STSVideoMetadata.h
//  StraaS
//
//  Created by Lee on 6/27/16.
//
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Video metadata model of StraaS player SDK
 */
@interface STSVideoMetadata : LHDataObject

/**
 *  The metadata id.
 */
@property (nonatomic, readonly) NSNumber * metadataId;

/**
 *  The author of the video.
 */
@property (nonatomic, readonly, nullable) NSString * author;

/**
 *  The location of the video.
 */
@property (nonatomic, readonly, nullable) NSString * location;

/**
 *  The language of the video.
 */
@property (nonatomic, readonly, nullable) NSString * language;

/**
 *  The video id.
 */
@property (nonatomic, readonly) NSString * videoId;

@end
NS_ASSUME_NONNULL_END
