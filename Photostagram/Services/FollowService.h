//
//  FollowService.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-31.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class User;
@interface FollowService : NSObject
+ (void)followUser:(User *)user forCurrentUserAndCallBack:(void(^)(BOOL success))callBack;
+ (void)unfollowUser:(User *)user forCurrentUserAndCallBack:(void(^)(BOOL success))callBack;
+ (void)setIsFollowing:(BOOL)isFollowing fromCurrentUserToFollowee:(User *)followee andCallBack:(void(^)(BOOL success))callBack;
+ (void)checkIsUserFollowed:(User *)user forCurrentUserAndCallBack:(void(^)(BOOL success))callBack;
@end

NS_ASSUME_NONNULL_END
