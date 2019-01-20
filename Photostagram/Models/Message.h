//
//  Message.h
//  Photostagram
//
//  Created by Wong Tom on 2019-01-12.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class User;
@class FIRDataSnapshot;

@interface Message : NSObject
- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot;
- (User *)getSender;
- (NSDate *)getTimeStamp;
- (NSString *)getContent;
- (NSString *)getKey;
- (void)setSender:(User *)sender;
- (void)setContent:(NSString *)content;
- (void)setTimestamp:(NSDate *)timestamp;
- (NSDictionary *)getDictionaryValue;
@end

NS_ASSUME_NONNULL_END
