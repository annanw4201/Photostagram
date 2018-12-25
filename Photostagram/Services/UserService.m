//
//  UserService.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-22.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "UserService.h"
#import "FIRUser.h"
#import "FIRDatabase.h"
#import "../Models/User.h"

@implementation UserService
+ (void)createUserWithName:(NSString *)username andCallBack:(void (^)(User *user))callBack {
    FIRUser *firUser = [FIRAuth.auth currentUser];
    FIRDatabaseReference *ref = [[FIRDatabase.database.reference child:@"users"] child:firUser.uid];
    NSDictionary *usernameAttrs = [NSDictionary dictionaryWithObject:username forKey:@"username"];
    [ref setValue:usernameAttrs];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        User *user = [[User alloc] initWithSnapshot:snapshot];
        if (!user) return callBack(nil);
        callBack(user);
    }];
}

+ (void)retrieveExistingUserModelWithUid:(NSString *)uid andCallBack:(void (^)(User *))callBack {
    FIRDatabaseReference *ref = [[FIRDatabase.database.reference child:@"users"] child:uid];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        User *user = [[User alloc] initWithSnapshot:snapshot];
        if (!user) return callBack(nil);
        else callBack(user);
    }];
}
@end
