//
//  ProfileHeaderCollectionReusableView.h
//  Photostagram
//
//  Created by Wong Tom on 2019-01-09.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileHeaderCollectionReusableView : UICollectionReusableView
- (void)setPostsCountLabelText:(NSString *)postsCount;
- (void)setFollowerCountLabelText:(NSString *)followerCount;
- (void)setFollowingCountLabelText:(NSString *)followingCount;
@end

NS_ASSUME_NONNULL_END
