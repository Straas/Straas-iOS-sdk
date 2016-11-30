//
//  STSCMSManager.h
//  StraaS
//
//  Created by Lee on 7/28/16.
//
//

@class STSVideo;
@class STSCategory;
@class STSTag;
@class STSPlaylistItem;
@class STSPagination;
@class STSPlaylist;
@class STSLive;

NS_ASSUME_NONNULL_BEGIN
/**
 *  STSCMSManager provides convenient method to access CMS member resources.
 */
@interface STSCMSManager : NSObject

/**
 *  Returns the STSCMSManager instance, creating it if it doesn’t exist yet.
 *
 *  @return The shared STSCMSManager object.
 */
+ (STSCMSManager *)sharedManager;

/**
 *  Set the member JWT, the JWT will be used when sending request to CMS API.
 *  We strongly suggest calling this method as soon as you get your member JWT.
 *  If you don't call this method, other STSCMSManager methods would return the resources that a guest can reach only.
 *  If you want your member could get their purchased goods, set their member JWT before call other STSCMSManager methods.
 *
 *  @param JWT The member token got from StraaS server.
 *  @param completion A block object to be executed when the task finishes. This block has no return value and takes one argument: a boolean value indicates whether or not the JWT is succesfully setted. You should successfully configure your app by calling STSApplication's configureApplication method before setting the JWT, otherwise, member JWT won't be setted.
 */
- (void)setJWT:(NSString *)JWT completion:(void(^ _Nullable)(BOOL success))completion;

/**
 *  Request a video that matchs the request parameter.
 *
 *  @param videoId The id of the video you want to find.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the STSVideo object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getVideoWithVideoId:(NSString *)videoId
                    success:(void (^)(STSVideo *))success
                    failure:(void (^)(NSError *))failure;
/**
 *  Request a playlist that matches the request parameter.
 *
 *  @param playlistId The id of the playlist you want to find.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the STSPlaylist object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getPlaylistWithPlaylistId:(NSString *)playlistId
                          success:(void(^)(STSPlaylist *))success
                          failure:(void(^)(NSError *))failure;
/**
 *  Request the list of playlist items of the specified playlist.
 *
 *  @param playlistId The id of the playlist you want to to get playlist items.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: an array of STSPlaylistItem objects.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getPlaylistItemsWithPlaylistId:(NSString *)playlistId
                               success:(void(^)(NSArray <STSPlaylistItem*> *))success
                               failure:(void(^)(NSError *))failure;
/**
 *  Request the list of categories that match the request parameter.
 *
 *  @param page The page of results to fetch.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: an array of STSCategory objects, and the pagination object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getCategoryListWithPage:(NSUInteger)page
                        success:(void (^)(NSArray <STSCategory*> *,
                                          STSPagination *))success
                        failure:(void (^)(NSError *))failure;
/**
 *  Request the list of tags that match the request parameter.
 *
 *  @param page The page of results to fetch.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: an array of STSTag objects, and the pagination object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getTagListWithPage:(NSUInteger)page
                   success:(void (^)(NSArray <STSTag*> *,
                                               STSPagination *))success
                   failure:(void (^)(NSError *))failure;
/**
 *  Request the list of videos that match the request parameter.
 *
 *  @param page The page of results to fetch.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: an array of STSVideo objects, and the pagination object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getVideoListWithPage:(NSUInteger)page
                        success:(void (^)(NSArray <STSVideo*> *,
                                                    STSPagination *))success
                        failure:(void (^)(NSError *))failure;
/**
 *  Request the list of playlists that match the request parameter.
 *
 *  @param page The page of results to fetch.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: an array of STSPlaylist objects, and the pagination object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getPlaylistsWithPage:(NSUInteger)page
                     success:(void(^)(NSArray<STSPlaylist*>*,
                                      STSPagination *))success
                     failure:(void(^)(NSError *))failure;


/**
 *  Request a live that match the request parameter.
 *
 *  @param liveId  The id of the live you want to find.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the live object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getLiveWithId:(NSString *)liveId
              success:(void (^)(STSLive *))success
              failure:(void (^)(NSError *))failure;

/**
 *  Request a list of available lives.
 *
 * @param page  The page of results to fetch.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the live object array, and the pagination object.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 */
- (void)getLiveListWithPage:(NSUInteger)page
                     success:(void (^)(NSArray <STSLive *> *, STSPagination *))success
                     failure:(void (^)(NSError *))failure;

@end
NS_ASSUME_NONNULL_END
