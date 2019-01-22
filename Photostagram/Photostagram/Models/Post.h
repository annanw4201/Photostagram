//
//  Post.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-25.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FIRDataSnapshot;

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject
- (instancetype)initWithImageUrl:(NSString *)imageUrl andImageHeight:(CGFloat)imageHeight;
- (NSDictionary *)getPostDictionary;
- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot;
- (CGFloat)getImageHeight;
- (NSString *)getImageUrl;
- (NSDate *)getCreationDate;
- (NSString *)getKey;
- (NSString *)getPosterUid;
- (NSString *)getPosterUsername;
- (NSString *)getLikeCounts;
- (BOOL)getCurrentUserLikedThisPost;
- (void)setCurrentUserLikedThisPost:(BOOL)currentUserLikedThisPost;
- (void)setLikeCounts:(NSString *)likeCounts;
@end

NS_ASSUME_NONNULL_END
