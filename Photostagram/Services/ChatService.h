//
//  ChatService.h
//  Photostagram
//
//  Created by Wong Tom on 2019-01-16.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Message;
@class Chat;
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface ChatService : NSObject
+ (void)createChatFromMessage:(Message *)message withChat:(Chat *)chat andCallBack:(void(^)(Chat *chat))callBack;
+ (void)retrieveExistingChatForUser:(User *)user andCallBack:(void(^)(Chat *chat))callBack;
+ (void)sendMessage:(Message *)message withChat:(Chat *)chat andCallBack:(void(^)(BOOL success))callBack;
@end

NS_ASSUME_NONNULL_END
