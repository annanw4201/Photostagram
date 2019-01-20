//
//  Chat.h
//  Photostagram
//
//  Created by Wong Tom on 2019-01-12.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FIRDataSnapshot;

@interface Chat : NSObject
- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot;

- (instancetype)initWithMembers:(NSArray *)members;

- (void)setTitle:(NSString *)title;

- (void)setMemberHash:(NSString *)memberHash;

- (void)setMemberUids:(NSArray *)memberUids;

- (void)setLastMessage:(NSString *)lastMessage;

- (void)setLastMessageSent:(NSDate *)lastMessageSent;

- (NSString *)getKey;

- (NSString *)getTitle;

- (NSString *)getMemberHash;

- (NSArray *)getMemberUids;

- (NSString *)getLastMessage;

- (NSDate *)getLastMessageSent;

+ (NSString *)hashForMembers:(NSArray *)members;
@end

NS_ASSUME_NONNULL_END
