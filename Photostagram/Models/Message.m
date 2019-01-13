//
//  Message.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-12.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "Message.h"
#import "../Models/User.h"
#import "FIRDataSnapshot.h"

@interface Message()
@property(nonatomic)NSString *key;
@property(nonatomic)NSString *content;
@property(nonatomic)NSDate *timestamp;
@property(nonatomic)User *sender;
@end

@implementation Message

- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot {
    self = [super init];
    NSDictionary *snapshotDictionary = snapshot.value;
    NSString *key = snapshotDictionary[@"key"];
    NSString *content = snapshotDictionary[@"content"];
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:[snapshotDictionary[@"timestamp"] doubleValue]];
    NSDictionary *senderDictionary = snapshotDictionary[@"sender"];
    if (!key || !content || !timestamp || !senderDictionary) return nil;
    if (self) {
        self.key = key;
        self.content = content;
        self.timestamp = timestamp;
        NSString *senderUid = senderDictionary[@"uid"];
        NSString *senderUsername = senderDictionary[@"username"];
        self.sender = [[User alloc] initWithUid:senderUid username:senderUsername];
    }
    return self;
}

- (instancetype)initWithContent:(NSString *)content {
    self = [super init];
    if (self) {
        self.content = content;
        self.timestamp = [NSDate date];
        self.sender = [User getCurrentUser];
    }
    return self;
}

@end
