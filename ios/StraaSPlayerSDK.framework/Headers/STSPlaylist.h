//
//  STSPlaylist.h
//  StraaS
//
//  Created by Lee on 8/16/16.
//
//

#import <StraaSCoreSDK/LHDataObject.h>
#import "STSPlaylistItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Playlist model of StraaS player SDK
 */
@interface STSPlaylist : LHDataObject

/**
 *  The playlist id.
 */
@property (nonatomic, readonly) NSString * playlistId;

/**
 *  The id of the account which the resource belongs to.
 */
@property (nonatomic, readonly) NSString * accountId;

/**
 *  The playlist title.
 */
@property (nonatomic, readonly) NSString * title;

/**
 *  The playlist synposis.
 */
@property (nonatomic, readonly) NSString * synposis;

/**
 *  The number of videos that the playlist contains.
 */
@property (nonatomic, readonly) NSInteger videosCount;

/**
 *  The large size thumbnail of thumbnail_urls.
 */
@property (nonatomic, readonly) NSString * posterURL;

/**
 *  The playlist created time.
 */
@property (nonatomic, readonly) NSString * createdAt;

/**
 *  The array of playlistItems.
 */
@property (nonatomic, readonly, nullable) NSArray <STSPlaylistItem *> * playlistItems;

@end

NS_ASSUME_NONNULL_END
