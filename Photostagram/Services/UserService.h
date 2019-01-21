//
//  UserService.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-22.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class User;
@class FIRDatabaseReference;
@class Message;
typedef NSUInteger FIRDatabaseHandle;

@interface UserService : NSObject
+ (void)createUserWithName:(NSString *)Username andCallBack:(void(^)(User *user))callBack;
+ (void)retrieveExistingUserWithUid:(NSString *)uid andCallBack:(void(^)(User *user))callBack;
+ (void)retrievePostsForUser:(User *)user withCallBack:(void(^)(NSArray *posts))callBack;
+ (void)fetchUsersExceptCurrentUser:(void(^)(NSArray *users))callBack;
+ (void)fetchFollowersUidForUser:(User *)user andCallBack:(void(^)(NSArray *followersUid))callBack;
+ (void)fetchTimelineForCurrentUser:(NSInteger)pageSize withLastPostKey:(NSString *)lastPostKey AndCallBack:(void (^)(NSArray * _Nonnull))callBack;
+ (void)fetchProfileForUser:(User *)user andCallBack:(void(^)(User *user, NSArray *posts))callBack;
+ (void)fetchFollowingUsersForUser:(User *)user andCallBack:(void (^)(NSArray *users))callBack;
+ (FIRDatabaseHandle)ObserveChatsForUser:(User *)user andCallBack:(void(^)(FIRDatabaseReference *ref, NSArray *chats))callBack;
+ (FIRDatabaseHandle)ObserveMessagesForChatKey:(NSString *)chatKey andCallBack:(void(^)(FIRDatabaseReference *ref, Message *message))callBack;
@end

NS_ASSUME_NONNULL_END
