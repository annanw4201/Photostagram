//
//  LikeService.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-27.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Post;

NS_ASSUME_NONNULL_BEGIN

@interface LikeService : NSObject
+ (void)createLikeForPost:(Post *)post andCallBack:(void(^)(BOOL success))callBack;
+ (void)unLikePost:(Post *)post andCallBack:(void(^)(BOOL success))callBack;
+ (void)setIsLiked:(BOOL)isLiked forPost:(Post *)post andCallBack:(void(^)(BOOL success))callBack;
+ (void)isPostLikedForPost:(Post *)post andCallBack:(void(^)(BOOL liked))callBack;
@end

NS_ASSUME_NONNULL_END
