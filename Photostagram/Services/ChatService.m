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
#import "FIRDatabaseReference.h"

@implementation ChatService

+ (void)createChatFromMessage:(Message *)message withChat:(Chat *)chat andCallBack:(void (^)(Chat *))callBack {
    NSArray *membersUids = [chat getMemberUids];
    NSMutableDictionary *membersDictionary = [NSMutableDictionary dictionaryWithCapacity:membersUids.count];
    for (NSString *uid in membersUids) {
        membersDictionary[uid] = @"true";
    }
    User *sender = [message getSender];
    
    // setting the chat model properties
    [chat setLastMessage:[NSString stringWithFormat:@"%@:%@", [sender getUsername], [message getContent]]];
    [chat setLastMessageSent:[message getTimeStamp]];
    
    // create chat dictionary for updating data in database
    NSString *lastMessageSent = [NSString stringWithFormat:@"%f", [message getTimeStamp].timeIntervalSince1970];
    NSDictionary *chatDictionary = [NSDictionary dictionaryWithObjects:@[[chat getTitle], [chat getMemberHash], membersDictionary, [chat getLastMessage], lastMessageSent] forKeys:@[@"title", @"memberHash", @"members", @"lastMessage", @"lastMessageSent"]];
    
    // insert data into multiUpdate dictionary
    NSMutableDictionary *multiUpdate = [NSMutableDictionary dictionary];
    
    NSString *chatKey = [[[[FIRDatabase.database.reference child:@"chats"] child:[[User getCurrentUser] getUserUid]] childByAutoId] key];
    for (NSString *uid in membersUids) {
        NSString *path = [NSString stringWithFormat:@"chats/%@/%@", uid, chatKey];
        multiUpdate[path] = chatDictionary;
    }
    
    NSString *messageKey = [[[[FIRDatabase.database.reference child:@"message"] child:chatKey] childByAutoId] key];
    NSString *messagePath = [NSString stringWithFormat:@"messages/%@/%@", chatKey, messageKey];
    multiUpdate[messagePath] = [message getDictionaryValue];
    
    // perform the update to multiple location
    FIRDatabaseReference *rootRef = FIRDatabase.database.reference;
    [rootRef updateChildValues:multiUpdate withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@: Error update multiUpdate:%@", self.class, error.localizedDescription);
            callBack(nil);
        }
        else {
            callBack(chat);
        }
    }];
}

+ (void)retrieveExistingChatForUser:(User *)user andCallback:(void (^)(Chat *))callBack {
    NSString *hashValue = [Chat hashForMembers:@[user, [User getCurrentUser]]];
    FIRDatabaseReference *chatRef = [[FIRDatabase.database.reference child:@"chats"] child:[[User getCurrentUser] getUserUid]];
    FIRDatabaseQuery *query = [[chatRef queryOrderedByChild:@"memberHash"] queryEqualToValue:hashValue];
    [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        FIRDataSnapshot *chatSnapshot = snapshot.children.allObjects.firstObject;
        if (!chatSnapshot) {
            callBack(nil);
        }
        else {
            Chat *chat = [[Chat alloc] initWithSnapshot:chatSnapshot];
            callBack(chat);
        }
    }];
}

@end
