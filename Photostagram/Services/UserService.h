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

@interface UserService : NSObject
+ (void)createUserWithName:(NSString *)Username andCallBack:(void(^)(User *user))callBack;
+ (void)retrieveExistingUserDataWithUid:(NSString *)uid andCallBack:(void(^)(User *user))callBack;
@end

NS_ASSUME_NONNULL_END
