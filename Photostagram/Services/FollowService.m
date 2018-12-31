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

@implementation FollowService

+ (void)followUser:(User *)user forCurrentUserAndCallBack:(void (^)(BOOL success))callBack {
    NSString *currentUserUid = [User getUserUid];
    NSDictionary *followDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"true", [NSString stringWithFormat:@"followers/%@/%@", [user getUserUid], currentUserUid],
                                      @"true", [NSString stringWithFormat:@"following/%@/%@", currentUserUid, [user getUserUid]], nil];
    FIRDatabaseReference *ref = FIRDatabase.database.reference;
    [ref updateChildValues:followDictionary withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@: Error update follower or following data: %@", NSStringFromClass([self class]), error.localizedDescription);
            callBack(NO);
        }
        else {
            callBack(YES);
        }
    }];
}

+ (void)unfollowUser:(User *)user forCurrentUserAndCallBack:(void (^)(BOOL))callBack {
    NSString *currentUserUid = [User getUserUid];
    NSDictionary *followDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNull null], [NSString stringWithFormat:@"followers/%@/%@", [user getUserUid], currentUserUid],
                                      [NSNull null], [NSString stringWithFormat:@"following/%@/%@", currentUserUid, [user getUserUid]], nil];
    FIRDatabaseReference *ref = FIRDatabase.database.reference;
    [ref updateChildValues:followDictionary withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@: Error removing follower or following data: %@", NSStringFromClass([self class]), error.localizedDescription);
            callBack(NO);
        }
        else {
            callBack(YES);
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
        if (snapShotDictionary) {
            callBack(YES);
        }
        else {
            callBack(NO);
        }
    }];
}

@end
