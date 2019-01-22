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
    NSDictionary *chatDictionary = [NSDictionary dictionaryWithObjects:@[[chat getTitle], [chat getMemberHash], membersDictionary, [chat getLastMessage], lastMessageSent] forKeys:@[@"title", @"memberHash", @"memberUids", @"lastMessage", @"lastMessageSent"]];
    
    // insert data into multiUpdate dictionary
    NSMutableDictionary *multiUpdate = [NSMutableDictionary dictionary];
    
    NSString *chatKey = [[[[FIRDatabase.database.reference child:@"chats"] child:[[User getCurrentUser] getUserUid]] childByAutoId] key];
    [chat setKey:chatKey];
    for (NSString *uid in membersUids) {
        NSString *path = [NSString stringWithFormat:@"chats/%@/%@", uid, chatKey];
        multiUpdate[path] = chatDictionary;
    }
    
    NSString *messageKey = [[[[FIRDatabase.database.reference child:@"messages"] child:chatKey] childByAutoId] key];
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

+ (void)retrieveExistingChatForUser:(User *)user andCallBack:(void (^)(Chat *))callBack {
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

+ (void)sendMessage:(Message *)message withChat:(Chat *)chat andCallBack:(void (^)(BOOL))callBack {
    NSString *chatKey = [chat getKey];
    if (!chatKey) {
        NSLog(@"%@: send message no chat key", self.class);
        callBack(nil);
    }
    else {
        NSMutableDictionary *multiUpdate = [NSMutableDictionary dictionary];
        for (NSString *uid in [chat getMemberUids]) {
            NSString *lastMessage = [NSString stringWithFormat:@"%@:%@", [[message getSender] getUsername], [message getContent]];
            NSString *lastMessagePath = [NSString stringWithFormat:@"chats/%@/%@/lastMessage", uid, chatKey];
            multiUpdate[lastMessagePath] = lastMessage;
            NSString *lastMessageSent = [NSString stringWithFormat:@"%f", [message getTimeStamp].timeIntervalSince1970];
            NSString *lastMessageSentPath = [NSString stringWithFormat:@"chats/%@/%@/lastMessageSent", uid, chatKey];
            multiUpdate[lastMessageSentPath] = lastMessageSent;
        }
        
        NSString *messageKey = [[[[FIRDatabase.database.reference child:@"message"] child:chatKey] childByAutoId] key];
        NSString *messagePath = [NSString stringWithFormat:@"messages/%@/%@", chatKey, messageKey];
        multiUpdate[messagePath] = [message getDictionaryValue];
        
        FIRDatabaseReference *rootRef = FIRDatabase.database.reference;
        [rootRef updateChildValues:multiUpdate withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error) {
                NSLog(@"%@: Error updating multiUpdate: %@", self.class, error.localizedDescription);
                callBack(NO);
            }
            else {
                callBack(YES);
            }
        }];
    }
}

// observe the message of the current user whenever a new message is added
+ (FIRDatabaseHandle)ObserveMessagesForChatKey:(NSString *)chatKey andCallBack:(void(^)(FIRDatabaseReference *ref, Message *message))callBack {
    FIRDatabaseReference *messageRef = [[FIRDatabase.database.reference child:@"messages"] child:chatKey];
    FIRDatabaseHandle handle = [messageRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        Message *message = [[Message alloc] initWithSnapshot:snapshot];
        if (!message) {
            return callBack(messageRef, nil);
        }
        else {
            callBack(messageRef, message);
        }
    }];
    return handle;
}

@end
