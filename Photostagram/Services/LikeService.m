//
//  LikeService.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-27.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "LikeService.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "../Models/Post.h"
#import "../Models/User.h"
#import "../Supporting/Constants.h"

@implementation LikeService

// push currentUserUid into path: root/databasePostLikes/postKey/, and
//  set value of currentUserUid to be TRUE. Then increment poster's like counts by 1
+ (void)createLikeForPost:(Post *)post andCallBack:(void (^)(BOOL))callBack {
    NSString *postKey = [post getKey];
    NSString *currentUserUid = [User getUserUid];
    if (postKey) {
        // create post like
        FIRDatabaseReference *postLikesRef = [[[FIRDatabase.database.reference child:databasePostLikes] child:postKey] child:currentUserUid];
        [postLikesRef setValue:@"TRUE" withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error) {
                NSLog(@"Error setValue for likeRef: %@", error.localizedDescription);
                callBack(NO);
            }
            else {
                // get post's like counts and increment by 1
                FIRDatabaseReference *likeCountsRef = [[[[FIRDatabase.database.reference child:databasePosts] child:[post getPosterUid]] child:postKey] child:@"like_counts"];
                [likeCountsRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * currentData) {
                    NSInteger likeCounts = currentData.value == [NSNull null] ? 0 : [[currentData value] integerValue];
                    likeCounts++;
                    currentData.value = [NSString stringWithFormat:@"%ld", (long)likeCounts];
                    return [FIRTransactionResult successWithValue:currentData];
                } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                    if (error) {
                        NSLog(@"%@: Error increment the like counts in transaction: %@", [self class], error.localizedDescription);
                        callBack(NO);
                    }
                    else {
                        callBack(YES);
                    }
                }];
            }
        }];
    }
    else {
        callBack(NO);
    }
}

// remove currentUserUid at path: root/databasePostLikes/postKey/ and then
//  decrement poster's like counts by 1
+ (void)unLikePost:(Post *)post andCallBack :(void (^)(BOOL))callBack {
    NSString *postKey = [post getKey];
    NSString *currentUserUid = [User getUserUid];
    if (postKey) {
        FIRDatabaseReference *postLikeRef = [[[FIRDatabase.database.reference child:databasePostLikes] child:postKey] child:currentUserUid];
        [postLikeRef removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error) {
                NSLog(@"Error unlike post: %@", error.localizedDescription);
                callBack(NO);
            }
            else {
                FIRDatabaseReference *postRef = [[[[FIRDatabase.database.reference child:databasePosts] child:currentUserUid] child:postKey] child:@"like_counts"];
                [postRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                    NSInteger likeCounts = currentData.value == [NSNull null] ? 0 : [[currentData value] integerValue];
                    likeCounts--;
                    likeCounts = likeCounts <= 0 ? 0 : likeCounts;
                    currentData.value = [NSString stringWithFormat:@"%ld", (long)likeCounts];
                    return [FIRTransactionResult successWithValue:currentData];
                } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                    if (error) {
                        NSLog(@"%@: Error decrement the like counts in transaction: %@", [self class], error.localizedDescription);
                        callBack(NO);
                    }
                    else {
                        callBack(YES);
                    }
                }];
            }
        }];
    }
    else {
        callBack(NO);
    }
}

+ (void)isPostLikedForPost:(Post *)post andCallBack:(void (^)(BOOL liked))callBack {
    NSString *postKey = [post getKey];
    NSString *currentUserUid = [User getUserUid];
    if (postKey) {
        FIRDatabaseReference *postLikeRef = [[[FIRDatabase.database.reference child:databasePostLikes] child:postKey] child:currentUserUid];
        [postLikeRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSString *currentUserLikedPost = snapshot.value;
            NSLog(@"%@: currentUserLikedPost:%@", NSStringFromClass([self class]), currentUserLikedPost);
            if (![currentUserLikedPost isEqual:[NSNull null]]) {
                callBack(YES);
            }
            else {
                callBack(NO);
            }
        }];
    }
    else {
        callBack(NO);
    }
}

@end
