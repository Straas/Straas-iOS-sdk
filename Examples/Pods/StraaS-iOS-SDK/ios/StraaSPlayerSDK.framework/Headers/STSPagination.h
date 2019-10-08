//
//  STSPagination.h
//  StraaS
//
//  Created by Lee on 8/10/16.
//
//

#import <Foundation/Foundation.h>

/**
 *  Pagination model of StraaS player SDK
 *  STSPagination is an object wrapping pagination header in api request.
 *  reference: https://developer.github.com/guides/traversing-with-pagination/
 */
@interface STSPagination : NSObject

/**
 *  The number of the last page.
 *  Usually, last page is a constant, unless CMS update resource.
 *  Nil if at the last page.
 */
@property (nonatomic) NSNumber * last;

/**
 *  The number of the first page.
 *  Usually, first page will equal 1. Nil if at the first page.
 */
@property (nonatomic) NSNumber * first;

/**
 *  The number of the previous page. Nil if have no previous page.
 */
@property (nonatomic) NSNumber * prev;

/**
 *  The number of the next page. Nil if have no next page.
 */
@property (nonatomic) NSNumber * next;

@end
