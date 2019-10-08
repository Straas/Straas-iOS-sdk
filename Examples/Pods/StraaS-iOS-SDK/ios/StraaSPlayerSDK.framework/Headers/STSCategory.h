//
//  STSCategory.h
//  StraaS
//
//  Created by Lee on 7/28/16.
//
//

#import <StraaSCoreSDK/LHDataObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Category model of StraaS player SDK
 */
@interface STSCategory : LHDataObject

/**
 *  The category id.
 */
@property (nonatomic, readonly) NSNumber * categoryId;

/**
 *  The category name.
 */
@property (nonatomic, readonly) NSString * name;

/**
 *  The category description.
 */
@property (nonatomic, readonly) NSString * categoryDescription;

/**
 *  The number of videos which are contained in the category.
 */
@property (nonatomic, readonly) NSInteger videosCount;

/**
 *  The id of the category which contains this category. If this category has no parentCategoryId, then it is not a subcategory.
 */
@property (nonatomic, readonly, nullable) NSNumber * parentCategoryId;

@end
NS_ASSUME_NONNULL_END
