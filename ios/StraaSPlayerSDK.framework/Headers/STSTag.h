//
//  STSTag.h
//  StraaS
//
//  Created by Lee on 6/28/16.
//
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  Tag model for StraaS player SDK
 */
@interface STSTag : LHDataObject

/**
 *  The tag id, which is uniquo.
 */
@property (nonatomic, readonly) NSNumber * tagId;

/**
 *  The tag name.
 */
@property (nonatomic, readonly) NSString * name;

/**
 *  The tag description.
 */
@property (nonatomic, readonly) NSString * tagDescription;

/**
 *  The number of objects which are tagged with this tag.
 */
@property (nonatomic, readonly) NSNumber * taggingsCount;

@end
NS_ASSUME_NONNULL_END
