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
#import "../Supporting/Constants.h"

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
            NSLog(@"%@: Error update follower or following data when follow: %@", NSStringFromClass([self class]), error.localizedDescription);
            callBack(NO);
        }
        else {
            dispatch_group_t dispatchGroup = dispatch_group_create();
            __block BOOL status = YES;
            
            // increment user's following count
            dispatch_group_enter(dispatchGroup);
            FIRDatabaseReference *followingCountRef = [[[FIRDatabase.database.reference child:databaseUsers] child:currentUserUid] child:userFollowingCount];
            [followingCountRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                NSInteger followingCount = currentData.value == [NSNull null] ? 0 : [currentData.value integerValue];
                NSInteger newFollowingCount = followingCount + 1;
                currentData.value = [NSString stringWithFormat:@"%ld", (long)newFollowingCount];
                return [FIRTransactionResult successWithValue:currentData];
            } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                if (error) {
                    NSLog(@"%@:Error update following count when follow:%@", self.class, error.localizedDescription);
                    status = NO;
                }
                dispatch_group_leave(dispatchGroup);
            }];
            
            // increment followee's follower count
            dispatch_group_enter(dispatchGroup);
            FIRDatabaseReference *followerCountRef = [[[FIRDatabase.database.reference child:databaseUsers] child:[user getUserUid]] child:userFollowerCount];
            [followerCountRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                NSInteger followerCount = currentData.value == [NSNull null] ? 0 : [currentData.value integerValue];
                NSInteger newFollowerCount = followerCount + 1;
                currentData.value = [NSString stringWithFormat:@"%ld", (long)newFollowerCount];
                return [FIRTransactionResult successWithValue:currentData];
            } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                if (error) {
                    NSLog(@"%@:Error to update follower count when follow:%@", self.class, error.localizedDescription);
                    status = NO;
                }
                dispatch_group_leave(dispatchGroup);
            }];
            
            // fetch all post for the followee
            dispatch_group_enter(dispatchGroup);
            [UserService retrievePostsForUser:user withCallBack:^(NSArray * _Nonnull posts) {
                NSMutableDictionary *followData = [NSMutableDictionary dictionaryWithCapacity:posts.count];
                NSDictionary *timelinePostDictionary = [NSDictionary dictionaryWithObject:[user getUserUid] forKey:@"poster_uid"];
                for (Post *post in posts) {
                    NSString *postKey = [post getKey];
                    [followData setObject:timelinePostDictionary forKey:[NSString stringWithFormat:@"timeline/%@/%@", currentUserUid, postKey]];
                }
                // add posts of followee to current user's timeline
                [ref updateChildValues:followData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error) {
                        NSLog(@"%@: Error update follow timeline data when follow: %@", NSStringFromClass([self class]), error.localizedDescription);
                        status = NO;
                    }
                    dispatch_group_leave(dispatchGroup);
                }];
            }];
            
            // notify we successfully update all the transactions
            dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
                callBack(status);
            });
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
            NSLog(@"%@: Error removing follower or following data when unfollow: %@", NSStringFromClass([self class]), error.localizedDescription);
            callBack(NO);
        }
        else {
            dispatch_group_t dispatchGroup = dispatch_group_create();
            __block BOOL status = YES;
            
            // decrement user's following count
            dispatch_group_enter(dispatchGroup);
            FIRDatabaseReference *followingCountRef = [[[FIRDatabase.database.reference child:databaseUsers] child:currentUserUid] child:userFollowingCount];
            [followingCountRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                NSInteger followingCount = currentData.value == [NSNull null] ? 0 : [currentData.value integerValue];
                NSInteger newFollwingCount = followingCount - 1;
                currentData.value = [NSString stringWithFormat:@"%ld", (long)newFollwingCount];
                return [FIRTransactionResult successWithValue:currentData];
            } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                if (error) {
                    status = NO;
                    NSLog(@"%@:Error update following count when unfollow: %@", self.class, error.localizedDescription);
                }
                dispatch_group_leave(dispatchGroup);
            }];
            
            // decrement followee's follower count
            dispatch_group_enter(dispatchGroup);
            FIRDatabaseReference *followerCountRef = [[[FIRDatabase.database.reference child:databaseUsers] child:[user getUserUid]] child:userFollowerCount];
            [followerCountRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                NSInteger followerCount = currentData.value == [NSNull null] ? 0 : [currentData.value integerValue];
                NSInteger newFollowerCount = followerCount - 1;
                currentData.value = [NSString stringWithFormat:@"%ld", (long)newFollowerCount];
                return [FIRTransactionResult successWithValue:currentData];
            } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                if (error) {
                    status = NO;
                    NSLog(@"%@:Error update follower count when unfollow:%@", self.class, error.localizedDescription);
                }
                dispatch_group_leave(dispatchGroup);
            }];
            
            // fetch all post for the followee
            dispatch_group_enter(dispatchGroup);
            [UserService retrievePostsForUser:user withCallBack:^(NSArray * _Nonnull posts) {
                NSMutableDictionary *unfollowData = [NSMutableDictionary dictionaryWithCapacity:posts.count];
                for (Post *post in posts) {
                    NSString *postKey = [post getKey];
                    [unfollowData setObject:[NSNull null] forKey:[NSString stringWithFormat:@"timeline/%@/%@", currentUserUid, postKey]];
                }
                // remove posts of followee to current user's timeline
                [ref updateChildValues:unfollowData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error) {
                        status = NO;
                        NSLog(@"%@: Error update unfollow timeline data: %@", NSStringFromClass([self class]), error.localizedDescription);
                    }
                    dispatch_group_leave(dispatchGroup);
                }];
            }];
            
            // notify we successfully update all the transactions
            dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
                callBack(status);
            });
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
