//
//  ChatService.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-16.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "ChatService.h"
#import "../Models/Chat.h"
#import "../Models/Message.h"
#import "../Models/User.h"

@implementation ChatService

+ (void)createChatFromMessage:(Message *)message withChat:(Chat *)chat andCallBack:(void (^)(Chat * _Nonnull))callBack {
    NSArray *membersUids = [chat getMemberUids];
    NSMutableDictionary *membersDictionary = [NSMutableDictionary dictionaryWithCapacity:membersUids.count];
    for (NSString *uid in membersUids) {
        membersDictionary[uid] = @"true";
    }
    User *sender = [message getSender];
    
    // setting the chat model properties
    [chat setLastMessage:[NSString stringWithFormat:@"%@:%@", [sender getUsername], [message getContent]]];
    [chat setLastMessageSent:[message getTimeStamp]];
    
    //
    float lastMessageSent = [message getTimeStamp].timeIntervalSince1970;
    
}

@end
