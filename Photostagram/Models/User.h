//
//  User.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-21.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FIRDataSnapshot;

@interface User : NSObject
- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot;
- (instancetype)initWithUid:(NSString *)uid username:(NSString *)username;
- (void)writeUser:(User *)user toUserDefaults:(BOOL)write;
- (NSString *)getUserUid;
- (NSString *)getUsername;
- (BOOL)getIsFollowed;
- (void)setIsFollowed:(BOOL)isFollowed;

+ (User *)getCurrentUser;
+ (void)setCurrentUser:(User *)user;
+ (NSString *)getUsername;
+ (NSString *)getUserUid;
@end

NS_ASSUME_NONNULL_END
