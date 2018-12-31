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

@implementation UserService

// create a user model after authentication if this is a new user
//  and push this model into Firedatabase
+ (void)createUserWithName:(NSString *)username andCallBack:(void (^)(User *user))callBack {
    FIRUser *firUser = [FIRAuth.auth currentUser];
    FIRDatabaseReference *ref = [[FIRDatabase.database.reference child:databaseUsers] child:firUser.uid];
    NSDictionary *usernameAttrs = [NSDictionary dictionaryWithObject:username forKey:@"username"];
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
    NSString *userUid = user.uid;
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

@end
