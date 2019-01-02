//
//  FIRStorageReference+Post.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-25.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "FIRStorageReference+Post.h"
#import "../Models/User.h"

@implementation FIRStorageReference (newPostImageReference)

+ (FIRStorageReference *)newPostImageReference {
    NSString *timestamp = [NSISO8601DateFormatter stringFromDate:[NSDate date] timeZone:[NSTimeZone systemTimeZone] formatOptions:NSISO8601DateFormatWithFullTime];
    User *currentUser = [User getCurrentUser];
    NSString *uid = [currentUser getUserUid];
    return [FIRStorage.storage.reference child:[NSString stringWithFormat:@"images/posts/%@/%@.jpg", uid, timestamp]];
}

@end
