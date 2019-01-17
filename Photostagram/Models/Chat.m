//
//  Chat.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-12.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "Chat.h"
#import "FIRDataSnapshot.h"
#import "../Models/User.h"

@interface Chat()
@property(nonatomic)NSString *key;
@property(nonatomic)NSString *title;
@property(nonatomic)NSString *memberHash;
@property(nonatomic)NSArray *memberUids;
@property(nonatomic)NSString *lastMessage;
@property(nonatomic)NSDate *lastMessageSent;
@end

@implementation Chat
- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot {
    self = [super init];
    NSDictionary *snapshotDictionary = snapshot.value;
    NSString *key = snapshot.key;
    NSString *title = snapshotDictionary[@"title"];
    NSString *memberHash = snapshotDictionary[@"memberHash"];
    NSArray *memberUids = [snapshotDictionary[@"memberUids"] allKeys];
    NSString *lastMessage = snapshotDictionary[@"lastMessage"];
    NSDate *lastMessageSent = [NSDate dateWithTimeIntervalSince1970:[snapshotDictionary[@"lastMessageSent"] doubleValue]];
    if (!key || !title || !memberHash || !memberUids || !lastMessage || !lastMessageSent) return nil;
    if (self) {
        self.key = key;
        self.title = title;
        self.memberHash = memberHash;
        self.memberUids = memberUids;
        self.lastMessage = lastMessage;
        self.lastMessageSent = lastMessageSent;
    }
    return self;
}

- (instancetype)initWithMembers:(NSArray *)members {
    self = [super init];
    if (members.count != 2) {
        NSLog(@"%@: Chat is between two members", self.class);
        return nil;
    }
    if (self) {
        self.title = [NSString stringWithFormat:@"%@, %@", members[0], members[1]];
        self.memberHash = [Chat hashForMembers:members];
        NSMutableArray *membersUids = [[NSMutableArray alloc] initWithCapacity:members.count];
        for (User *user in members) {
            [membersUids addObject:[user getUserUid]];
        }
        self.memberUids = membersUids;
    }
    return self;
}

// get hash value for two members
+ (NSString *)hashForMembers:(NSArray *)members {
    if (members.count != 2) {
        NSLog(@"%@: hash for members is between two users", self.class);
        return nil;
    }
    User *user1 = members[0];
    User *user2 = members[1];
    
    // using XOR to get a unique hash value base on two users' uids hash value
    //  and thus prevent duplicate chats with the same user
    NSString *memberHash = [NSString stringWithFormat:@"%lu", [user1 getUserUid].hash ^ [user2 getUserUid].hash];
    return memberHash;
}

@end
