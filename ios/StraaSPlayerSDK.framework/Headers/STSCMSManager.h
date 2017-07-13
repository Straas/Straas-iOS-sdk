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
 *  @param JWT The member token got from StraaS server. `nil` if the current user is a guest.
 *  @param completion A block object to be executed when the task finishes. This block has no return value and takes one argument: a boolean value indicates whether or not the JWT is succesfully setted. You should successfully configure your app by calling STSApplication's configureApplication method before setting the JWT, otherwise, member JWT won't be setted.
 */
- (void)setJWT:(NSString * _Nullable)JWT completion:(void(^ _Nullable)(BOOL success))completion;

/**
 *  Request a video that matchs the request parameter.
 *
 *  @param videoId The id of the video you want to find.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the STSVideo object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 *  @return The ID of the new request. Returns `nil` if the application is unauthorized.
 */
- (NSString * _Nullable)getVideoWithVideoId:(NSString *)videoId
                                    success:(void (^)(STSVideo * video))success
                                    failure:(void (^)(NSError * error))failure;

/**
 *  Request a playlist that matches the request parameter.
 *
 *  @param playlistId The id of the playlist you want to find.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the STSPlaylist object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 *  @return The ID of the new request. Returns `nil` if the application is unauthorized.
 */
- (NSString * _Nullable)getPlaylistWithPlaylistId:(NSString *)playlistId
                                          success:(void(^)(STSPlaylist * playlist))success
                                          failure:(void(^)(NSError * error))failure;

/**
 *  Request the list of playlist items of the specified playlist.
 *
 *  @param playlistId The id of the playlist you want to to get playlist items.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: an array of STSPlaylistItem objects.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 *  @return The ID of the new request. Returns `nil` if the application is unauthorized.
 */
- (NSString * _Nullable)getPlaylistItemsWithPlaylistId:(NSString *)playlistId
                                               success:(void(^)(NSArray <STSPlaylistItem*> * playlistItems))success
                                               failure:(void(^)(NSError * error))failure;

/**
 *  Request the list of categories that match the request parameter.
 *
 *  @param page The page of results to fetch.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: an array of STSCategory objects, and the pagination object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 *  @return The ID of the new request. Returns `nil` if the application is unauthorized.
 */
- (NSString * _Nullable)getCategoryListWithPage:(NSUInteger)page
                                        success:(void (^)(NSArray <STSCategory*> * categories,
                                                          STSPagination * pagination))success
                                        failure:(void (^)(NSError * error))failure;

/**
 *  Request the list of tags that match the request parameter.
 *
 *  @param page The page of results to fetch.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: an array of STSTag objects, and the pagination object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 *  @return The ID of the new request. Returns `nil` if the application is unauthorized.
 */
- (NSString * _Nullable)getTagListWithPage:(NSUInteger)page
                                   success:(void (^)(NSArray <STSTag*> * tags,
                                                     STSPagination * pagination))success
                                   failure:(void (^)(NSError * error))failure;

/**
 *  Request the list of videos that match the request parameter.
 *
 *  @param page The page of results to fetch.
 *  @param sort Default value is `-created_at`. Data sorted with {+,-} by which column {created_at,start_time,started_at,ccu_statistic_summary.ccu}. Apply - to sort in descending order. For example, sort=-created_at. When you sort data by a column which belongs to its included resource, the resource is included automatically.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: an array of STSVideo objects, and the pagination object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 *  @return The ID of the new request. Returns `nil` if the application is unauthorized.
 */
- (NSString * _Nullable)getVideoListWithPage:(NSUInteger)page
                                        sort:(NSString *_Nullable)sort
                                     success:(void (^)(NSArray <STSVideo*> * videos,
                                                       STSPagination * pagination))success
                                     failure:(void (^)(NSError * error))failure;

/**
 *  Request the list of playlists that match the request parameter.
 *
 *  @param page The page of results to fetch.
 *  @param sort Default value is `-created_at`. Data sorted with {+,-} by which column {created_at}. Apply - to sort in descending order. For example, sort=-created_at. When you sort data by a column which belongs to its included resource, the resource is included automatically.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: an array of STSPlaylist objects, and the pagination object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 *  @return The ID of the new request. Returns `nil` if the application is unauthorized.
 */
- (NSString * _Nullable)getPlaylistsWithPage:(NSUInteger)page
                                        sort:(NSString * _Nullable)sort
                                     success:(void(^)(NSArray<STSPlaylist*> * playlists,
                                                      STSPagination * pagination))success
                                     failure:(void(^)(NSError * error))failure;


/**
 *  Request a live that match the request parameter.
 *
 *  @param liveId  The id of the live you want to find.
 *  @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: the live object.
 *  @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 *  @return The ID of the new request. Returns `nil` if the application is unauthorized.
 */
- (NSString * _Nullable)getLiveWithId:(NSString *)liveId
                              success:(void (^)(STSLive * live))success
                              failure:(void (^)(NSError * error))failure;

/**
 *  Request a list of available lives.
 *
 * @param page  The page of results to fetch.
 # @param sort  Default value is `-start_time`. Data sorted with {+,-} by which column {created_at,start_time,started_at,ccu_statistic_summary.ccu}. Apply - to sort in descending order. For example, sort=-created_at. When you sort data by a column which belongs to its included resource, the resource is included automatically.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the live object array, and the pagination object.
 * @param failure A block object to be executed when the task finishes unsuccessfully. This block has no return value and takes one argument: the error object describing the error that occurred.
 *  @return The ID of the new request. Returns `nil` if the application is unauthorized.
 */
- (NSString * _Nullable)getLiveListWithPage:(NSUInteger)page
                                       sort:(NSString * _Nullable)sort
                                    success:(void (^)(NSArray <STSLive *> * lives,
                                                      STSPagination * pagination))success
                                    failure:(void (^)(NSError * error))failure;

/**
 *  Cancel a request by ID.
 *
 *  @param requestID The ID of the request.
 */
- (void)cancelRequest:(NSString *)requestID;

@end
NS_ASSUME_NONNULL_END
