//
//  Chat.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-12.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "Chat.h"
#import "FIRDataSnapshot.h"

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
@end
