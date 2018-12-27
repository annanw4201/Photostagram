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
//  set value of currentUserUid to be TRUE
+ (void)createLikeForPost:(Post *)post andCallBack:(void (^)(BOOL))callBack {
    NSString *postKey = [post getKey];
    NSString *currentUserUid = [User getUserUid];
    if (postKey) {
        FIRDatabaseReference *likesRef = [[[FIRDatabase.database.reference child:databasePostLikes] child:postKey] child:currentUserUid];
        [likesRef setValue:@"TRUE" withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error) {
                NSLog(@"Error setValue for likeRef: %@", error.localizedDescription);
                callBack(NO);
            }
            else {
                callBack(YES);
            }
        }];
    }
    else {
        callBack(NO);
    }
}

// remove currentUserUid at path: root/databasePostLikes/postKey/
+ (void)unLikePost:(Post *)post andCallBack :(void (^)(BOOL))callBack {
    NSString *postKey = [post getKey];
    NSString *currentUserUid = [User getUserUid];
    if (postKey) {
        FIRDatabaseReference *likeRef = [[[FIRDatabase.database.reference child:databasePostLikes] child:postKey] child:currentUserUid];
        [likeRef removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error) {
                NSLog(@"Error unlike post: %@", error.localizedDescription);
                callBack(NO);
            }
            else {
                callBack(YES);
            }
        }];
    }
    else {
        callBack(NO);
    }
}

@end
