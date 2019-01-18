//
//  Chat.h
//  Photostagram
//
//  Created by Wong Tom on 2019-01-12.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Chat : NSObject
- (void)setTitle:(NSString *)title;

- (void)setMemberHash:(NSString *)memberHash;

- (void)setMemberUids:(NSArray *)memberUids;

- (void)setLastMessage:(NSString *)lastMessage;

- (void)setLastMessageSent:(NSDate *)lastMessageSent;

- (NSString *)getTitle;

- (NSString *)getMemberHash;

- (NSArray *)getMemberUids;

- (NSString *)getLastMessage;

- (NSDate *)getLastMessageSent;
@end

NS_ASSUME_NONNULL_END
