//
//  UserService.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-22.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "UserService.h"
#import "FIRUser.h"
#import "FIRDatabase.h"
#import "../Models/User.h"
#import "../Models/Post.h"
#import "../Supporting/Constants.h"
#import "LikeService.h"
#import "../Services/FollowService.h"
#import "../Services/PostService.h"

@implementation UserService

// create a user model after authentication if this is a new user
//  and push this model into Firedatabase
+ (void)createUserWithName:(NSString *)username andCallBack:(void (^)(User *user))callBack {
    FIRUser *firUser = [FIRAuth.auth currentUser];
    FIRDatabaseReference *ref = [[FIRDatabase.database.reference child:databaseUsers] child:firUser.uid];
    NSDictionary *usernameAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   username, userusername,
                                   [NSString stringWithFormat:@"%d", 0], userFollowerCount,
                                   [NSString stringWithFormat:@"%d", 0], userFollowingCount,
                                   [NSString stringWithFormat:@"%d", 0], userPostsCount, nil];
    [ref setValue:usernameAttrs];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        User *user = [[User alloc] initWithSnapshot:snapshot];
        if (!user) return callBack(nil);
        callBack(user);
    }];
}

// retrieve existing user data from Firedatabase and create a user model
+ (void)retrieveExistingUserWithUid:(NSString *)uid andCallBack:(void (^)(User *))callBack {
    FIRDatabaseReference *ref = [[FIRDatabase.database.reference child:databaseUsers] child:uid];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        User *user = [[User alloc] initWithSnapshot:snapshot];
        if (!user) return callBack(nil);
        else callBack(user);
    }];
}

// retrieve the posts of the specified user and callBack return an array of the posts
+ (void)retrievePostsForUser:(User *)user withCallBack:(void (^)(NSArray *posts))callBack {
    NSString *userUid = [user getUserUid];
    FIRDatabaseReference *ref = [[FIRDatabase.database.reference child:databasePosts] child:userUid];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *snapshotArray = [snapshot.children allObjects];
        if (!snapshotArray) {
            callBack(nil);
        }
        else {
            dispatch_group_t dispatchGroup = dispatch_group_create();
            
            NSMutableArray *postArray = [NSMutableArray arrayWithCapacity:[snapshotArray count]];
            for (FIRDataSnapshot *s in [snapshotArray reverseObjectEnumerator]) {
                Post *post = [[Post alloc] initWithSnapshot:s];
                dispatch_group_enter(dispatchGroup);
                [LikeService isPostLikedForPost:post andCallBack:^(BOOL liked) {
                    [post setCurrentUserLikedThisPost:liked];
                    [postArray addObject:post];
                    dispatch_group_leave(dispatchGroup);
                }];
            }
            dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
                callBack(postArray);
            });
        }
    }];
}

// fetch all users on current device except the current logged in user
+ (void)fetchUsersExceptCurrentUser:(void (^)(NSArray * _Nonnull))callBack {
    User *currentUser = [User getCurrentUser];
    FIRDatabaseReference *ref = [FIRDatabase.database.reference child:databaseUsers];
    
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *snapShotArray = snapshot.children.allObjects;
        if (!snapShotArray) {
            callBack([NSArray array]);
        }
        
        dispatch_group_t dispatchGroup = dispatch_group_create();
        NSMutableArray *userArray = [NSMutableArray arrayWithCapacity:snapShotArray.count];
        for (FIRDataSnapshot *s in snapShotArray) {
            User *user = [[User alloc] initWithSnapshot:s];
            if (![[user getUserUid] isEqualToString:[currentUser getUserUid]]) {
                dispatch_group_enter(dispatchGroup);
                [FollowService checkIsUserFollowed:user forCurrentUserAndCallBack:^(BOOL isFollowed) {
                    [user setIsFollowed:isFollowed];
                    [userArray addObject:user];
                    dispatch_group_leave(dispatchGroup);
                }];
            }
        }
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
            callBack(userArray);
        });
    }];
}

// fetch all the followers' uids for the specified user
+ (void)fetchFollowersUidForUser:(User *)user andCallBack:(void (^)(NSArray * _Nonnull))callBack {
    NSString *uid = [user getUserUid];
    FIRDatabaseReference *followersRef = [[FIRDatabase.database.reference child:databaseFollowers] child:uid];
    [followersRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *snapshotDictionary = snapshot.value;
        if ([snapshotDictionary isEqual:[NSNull null]]) {
            callBack([NSArray array]);
        }
        else {
            NSArray *followerUids = [snapshotDictionary allKeys];
            callBack(followerUids);
        }
    }];
}

// fetch all the available timelines of the current user
+ (void)fetchTimelineForCurrentUser:(NSInteger)pageSize withLastPostKey:(NSString *)lastPostKey AndCallBack:(void (^)(NSArray * _Nonnull))callBack {
    User *currentUser = [User getCurrentUser];
    FIRDatabaseReference *timelineRef = [[FIRDatabase.database.reference child:@"timeline"] child:[currentUser getUserUid]];
    FIRDatabaseQuery *query = [[timelineRef queryOrderedByKey] queryLimitedToLast:pageSize];
    if (lastPostKey) {
        NSLog(@"%@:fetch timeline last post key: %@", self.class, lastPostKey);
        query = [query queryEndingAtValue:lastPostKey];
    }
    
    [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *snapshotArray = [snapshot.children allObjects];
        NSLog(@"%@: snapshot array: %@", self.class, snapshotArray);
        NSMutableArray *posts = [[NSMutableArray alloc] initWithCapacity:snapshotArray.count];
        
        dispatch_group_t dispatchGroup = dispatch_group_create();
        for (FIRDataSnapshot *s in snapshotArray.reverseObjectEnumerator) {
            NSDictionary *timelinePostDictionary = s.value;
            if (!timelinePostDictionary) continue;
            NSString *posterUid = [timelinePostDictionary objectForKey:@"poster_uid"];
            if (!posterUid) continue;
            dispatch_group_enter(dispatchGroup); // wait for creating post
            NSString *postKey = s.key;
            [PostService createPostForPostKey:postKey withPosterUid:posterUid andCallBack:^(Post * post) {
                if (post) {
                    [LikeService isPostLikedForPost:post andCallBack:^(BOOL liked) {
                        [post setCurrentUserLikedThisPost:liked];
                        [posts addObject:post];
                        dispatch_group_leave(dispatchGroup);
                    }];
                }
            }];
        }
        // notify that successfully creating all posts
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
            callBack(posts);
        });
    }];
}

// fetch the profile data of the current user
+ (void)fetchProfileForUser:(User *)user andCallBack:(void (^)(User *, NSArray *))callBack {
    FIRDatabaseReference *userRef = [[FIRDatabase.database.reference child:databaseUsers] child:[user getUserUid]];
    [userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        User *user = [[User alloc] initWithSnapshot:snapshot];
        if (!user) {
            callBack(nil, [NSArray array]);
        }
        else {
            [self retrievePostsForUser:user withCallBack:^(NSArray * _Nonnull posts) {
                callBack(user, posts);
            }];
        }
    }];
}

// fetch all the following users for the specified user
+ (void)fetchFollowingUsersForUser:(User *)user andCallBack:(void (^)(NSArray * _Nonnull))callBack {
    NSString *uid = [user getUserUid];
    FIRDatabaseReference *followingRef = [[FIRDatabase.database.reference child:databaseFollowing] child:uid];
    [followingRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *snapshotDictionary = snapshot.value;
        if ([snapshotDictionary isEqual:[NSNull null]]) {
            callBack([NSArray array]);
        }
        else {
            NSArray *followingUids = [snapshotDictionary allKeys];
            NSMutableArray *followingUsers = [[NSMutableArray alloc] initWithCapacity:followingUids.count];
            
            // use dispatch group to fetch all the users in the block and then return the result to call back
            dispatch_group_t dispatchGroup = dispatch_group_create();
            for (NSString *followingUid in followingUids) {
                dispatch_group_enter(dispatchGroup);
                [UserService retrieveExistingUserWithUid:followingUid andCallBack:^(User * _Nonnull user) {
                    [followingUsers addObject:user];
                    dispatch_group_leave(dispatchGroup);
                }];
            }
            
            dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
                callBack(followingUsers);
            });
        }
    }];
}

@end
