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
@end


@implementation User
static User *currentUser = nil;

- (instancetype)initWithUid:(NSString *)uid username:(NSString *)username {
    self.uid = uid;
    self.username = username;
    return self;
}

- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot {
    // data will be of type NSDictionary, NSArray, NSNumber, NSString
    id data = snapshot.value;
    NSString *username = nil;
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDict = (NSDictionary *)data;
        username = [dataDict objectForKey:@"username"];
        if (!username) return nil;
    }
    else return nil;
    self.uid = snapshot.key;
    self.username = username;
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.uid = [aDecoder decodeObjectOfClass:[User class] forKey:@"uid"];
        self.username = [aDecoder decodeObjectOfClass:[User class] forKey:@"username"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.username forKey:@"username"];
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

+ (User *)getCurrentUser {
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
}

@end
