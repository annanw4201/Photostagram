//
//  FollowService.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-31.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "FollowService.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "../Models/User.h"
#import "UserService.h"
#import "../Models/Post.h"

@implementation FollowService

+ (void)followUser:(User *)user forCurrentUserAndCallBack:(void (^)(BOOL success))callBack {
    NSString *currentUserUid = [User getUserUid];
    NSDictionary *followDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"true", [NSString stringWithFormat:@"followers/%@/%@", [user getUserUid], currentUserUid],
                                      @"true", [NSString stringWithFormat:@"following/%@/%@", currentUserUid, [user getUserUid]], nil];
    FIRDatabaseReference *ref = FIRDatabase.database.reference;
    
    // update followee and follower
    [ref updateChildValues:followDictionary withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@: Error update follower or following data: %@", NSStringFromClass([self class]), error.localizedDescription);
            callBack(NO);
        }
        else {
            // fetch all post for the followee
            [UserService retrievePostsForUser:user withCallBack:^(NSArray * _Nonnull posts) {
                NSMutableDictionary *followData = [NSMutableDictionary dictionaryWithCapacity:posts.count];
                NSDictionary *timelinePostDictionary = [NSDictionary dictionaryWithObject:[user getUserUid] forKey:@"poster_uid"];
                for (Post *post in posts) {
                    NSString *postKey = [post getKey];
                    [followData setObject:timelinePostDictionary forKey:[NSString stringWithFormat:@"timeline/%@/%@", currentUserUid, postKey]];
                }
                // update posts of followee to current user's timeline
                [ref updateChildValues:followData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error) {
                        NSLog(@"%@: Error update follow timeline data: %@", NSStringFromClass([self class]), error.localizedDescription);
                        callBack(NO);
                    }
                    else {
                        callBack(YES);
                    }
                }];
            }];
        }
    }];
}

+ (void)unfollowUser:(User *)user forCurrentUserAndCallBack:(void (^)(BOOL))callBack {
    NSString *currentUserUid = [User getUserUid];
    NSDictionary *followDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNull null], [NSString stringWithFormat:@"followers/%@/%@", [user getUserUid], currentUserUid],
                                      [NSNull null], [NSString stringWithFormat:@"following/%@/%@", currentUserUid, [user getUserUid]], nil];
    FIRDatabaseReference *ref = FIRDatabase.database.reference;
    // update followee and follower
    [ref updateChildValues:followDictionary withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@: Error removing follower or following data: %@", NSStringFromClass([self class]), error.localizedDescription);
            callBack(NO);
        }
        else {
            // fetch all post for the followee
            [UserService retrievePostsForUser:user withCallBack:^(NSArray * _Nonnull posts) {
                NSMutableDictionary *unfollowData = [NSMutableDictionary dictionaryWithCapacity:posts.count];
                for (Post *post in posts) {
                    NSString *postKey = [post getKey];
                    [unfollowData setObject:[NSNull null] forKey:[NSString stringWithFormat:@"timeline/%@/%@", currentUserUid, postKey]];
                }
                // update posts of followee to current user's timeline
                [ref updateChildValues:unfollowData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error) {
                        NSLog(@"%@: Error update unfollow timeline data: %@", NSStringFromClass([self class]), error.localizedDescription);
                        callBack(NO);
                    }
                    else {
                        callBack(YES);
                    }
                }];
            }];
        }
    }];
}

+ (void)setIsFollowing:(BOOL)isFollowing fromCurrentUserToFollowee:(User *)followee andCallBack:(void (^)(BOOL))callBack {
    if (isFollowing) {
        [self followUser:followee forCurrentUserAndCallBack:callBack];
    }
    else {
        [self unfollowUser:followee forCurrentUserAndCallBack:callBack];
    }
}

+ (void)checkIsUserFollowed:(User *)user forCurrentUserAndCallBack:(void (^)(BOOL))callBack {
    NSString *currentUserUid = [User getUserUid];
    FIRDatabaseReference *followingRef = [[FIRDatabase.database.reference child:@"following"] child:currentUserUid];
    [[followingRef queryEqualToValue:nil childKey:[user getUserUid]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *snapShotDictionary = snapshot.value;
        NSLog(@"snapshotDict: %@", snapShotDictionary);
        if (![snapShotDictionary isEqual:[NSNull null]]) {
            callBack(YES);
        }
        else {
            callBack(NO);
        }
    }];
}

@end
