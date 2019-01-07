//
//  Constants.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-23.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define createUsernameSegue @"createUsernameSegue"
#define currentLoggedInUser @"currentLoggedInUser"

// main tab bar view controller
typedef NS_ENUM(NSInteger, tabBarViewControllerTag) {
    homeTabBarItemTag = 0,
    photoPickerTabBarItemTag = 1,
    friendsTabBarItemTag = 2
};

// cell views
typedef NS_ENUM(NSInteger, postCellView) {
    postHeaderTableViewCellRow = 0,
    postImageTableViewCellRow = 1,
    postActionTableViewCellRow = 2
};

typedef NS_ENUM(NSInteger, postCellViewHeight) {
    postHeaderTableViewCellHeight = 56,
    postActionTableViewCellHeight = 46
};

// data base
#define databasePosts @"posts"
#define databaseUsers @"users"
#define databasePostLikes @"postLikes"
#define databaseFollowers @"followers"
#define databaseFollowing @"following"

#define postsImageUrl @"image_url"
#define postsImageHeight @"image_height"
#define postsCreationDate @"creation_date"
#define postsLikeCounts @"like_counts"
#define postsCurrentUserLikeThisPost @"current_user_like_this_post"

// users
#define useruid @"uid"
#define userusername @"username"

// home view controller cell identifier
#define homePostHeaderCell @"homePostHeaderCell"
#define homePostImageCell @"homePostImageCell"
#define homePostActionCell @"homePostActionCell"

#endif /* Constants_h */
