//
//  User.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-21.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "User.h"
#import "FIRDataSnapshot.h"

@implementation User

-(instancetype)initWithUid:(NSString *)uid username:(NSString *)username {
    self.uid = uid;
    self.username = username;
    return self;
}

-(id)initWithSnapshot:(FIRDataSnapshot *)snapshot {
    // data will be of type NSDictionary, NSArray, NSNumber, NSString
    id data = snapshot.value;
    NSString *username = nil;
    NSDictionary *dataDict = (NSDictionary *)data;
    if (dataDict) {
        username = [dataDict objectForKey:@"username"];
        if (!username) return nil;
    }
    else return nil;
    self.uid = snapshot.key;
    self.username = username;
    return self;
}

@end
