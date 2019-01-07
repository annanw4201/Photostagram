//
//  User.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-21.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "User.h"
#import "FIRDataSnapshot.h"
#import "../Supporting/Constants.h"

// This User class supports NSSecureCoding
@interface User() <NSCoding, NSSecureCoding>
@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, assign) BOOL isFollowed;
@property(nonatomic) NSInteger followerCount;
@property(nonatomic) NSInteger followingCount;
@property(nonatomic) NSInteger postsCount;
@end


@implementation User
static User *currentUser = nil;

- (instancetype)initWithUid:(NSString *)uid username:(NSString *)username {
    self.uid = uid;
    self.username = username;
    self.isFollowed = NO;
    return self;
}

- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot {
    // data will be of type NSDictionary, NSArray, NSNumber, NSString
    id data = snapshot.value;
    NSString *username = nil;
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDict = (NSDictionary *)data;
        username = [dataDict objectForKey:userusername];
        self.uid = snapshot.key;
        self.username = username;
        self.isFollowed = NO;
        self.followerCount = [[dataDict objectForKey:userFollowerCount] integerValue];
        self.followingCount = [[dataDict objectForKey:userFollowingCount] integerValue];
        self.postsCount = [[dataDict objectForKey:userPostsCount] integerValue];
        if (!username || !snapshot.key) return nil;
    }
    else return nil;
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.uid = [aDecoder decodeObjectOfClass:[User class] forKey:useruid];
        self.username = [aDecoder decodeObjectOfClass:[User class] forKey:userusername];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uid forKey:useruid];
    [aCoder encodeObject:self.username forKey:userusername];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)writeUser:(User *)user toUserDefaults:(BOOL)write {
    if (write) {
        NSError *error = nil;
        NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:YES error:&error];
        if (error) NSLog(@"Error encoding: %@", error.localizedDescription);
        [[NSUserDefaults standardUserDefaults] setObject:objectData forKey:currentLoggedInUser];
    }
}

- (NSString *)getUserUid {
    return self.uid;
}

- (NSString *)getUsername {
    return self.username;
}

- (void)setIsFollowed:(BOOL)isFollowed {
    _isFollowed = isFollowed;
}

- (BOOL)getIsFollowed {
    return self.isFollowed;
}

- (NSInteger)getFollowerCount {
    return self.followerCount;
}

- (NSInteger)getFollowingCount {
    return self.followingCount;
}

- (NSInteger)getPostsCount {
    return self.postsCount;
}

- (void)setFollowingCount:(NSInteger)followingCount {
    _followingCount = followingCount;
}

- (void)setFollowerCount:(NSInteger)followerCount {
    _followerCount = followerCount;
}

- (void)setPostsCount:(NSInteger)postsCount {
    _postsCount = postsCount;
}

+ (User *)getCurrentUser {
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
}

+ (NSString *)getUsername {
    return currentUser.username;
}

+ (NSString *)getUserUid {
    return currentUser.uid;
}

@end
