//
//  STSPlaylistItem.h
//  StraaS
//
//  Created by Lee on 8/10/16.
//
//

#import <StraaSCoreSDK/LHDataObject.h>
#import "STSVideo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Playlist item model of StraaS player SDK
 */
@interface STSPlaylistItem : LHDataObject

/**
 *  The playlist item id.
 */
@property (nonatomic, readonly) NSString * playlistItemId;

/**
 *  The playlist id which the playlist item belongs to.
 */
@property (nonatomic, readonly) NSString * playlistId;

/**
 *  The id of the account which the playlist item belongs to.
 */
@property (nonatomic, readonly) NSString * accountId;

/**
 *  The video id of the playlist item.
 */
@property (nonatomic, readonly) NSString * videoId;

/**
 *  The STSVideo object.
 */
@property (nonatomic, readonly) STSVideo * video;

@end
NS_ASSUME_NONNULL_END
