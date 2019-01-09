//
//  PostService.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-25.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "PostService.h"
#import "FirebaseStorage.h"
#import "FirebaseDatabase.h"
#import "StorageService.h"
#import "../Models/User.h"
#import "../Models/Post.h"
#import "../Extensions/UIImage+size.h"
#import "../Extensions/FIRStorageReference+Post.h"
#import "../Supporting/Constants.h"
#import "UserService.h"

@implementation PostService

// upload image to Firestorage and retrieve url for the uploaded image and
//  then create post model for this image
+ (void)createPostForImage:(UIImage *)image {
    FIRStorageReference *imageRef = [FIRStorageReference newPostImageReference];
    [StorageService uploadImage:image atReference:imageRef withCallBack:^(NSURL * _Nonnull url) {
        if (!url) return;
        NSString *urlString = url.absoluteString;
        [self createPostForUrlString:urlString withAspectHeight:image.aspectHeight];
    }];
}

// create post model and convert it into dictionary and push this dictionary into Firedatabase
+ (void)createPostForUrlString:(NSString *)urlString withAspectHeight:(CGFloat)aspectHeight {
    User *currentUser = [User getCurrentUser];
    NSString *currentUserUid = [currentUser getUserUid];
    Post *post = [[Post alloc] initWithImageUrl:urlString andImageHeight:aspectHeight];
    
    FIRDatabaseReference *rootRef = FIRDatabase.database.reference;
    FIRDatabaseReference *newPostRef = [[[rootRef child:databasePosts] child:currentUserUid] childByAutoId];
    NSString *newPostKey = newPostRef.key;
    
    [UserService fetchFollowersForUser:currentUser andCallBack:^(NSArray * _Nonnull followersUid) {
        // update new post to current user timeline
        NSDictionary *timelinePostDictionary = [NSDictionary dictionaryWithObjectsAndKeys:currentUserUid, @"poster_uid", nil];
        NSMutableDictionary *updateData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   timelinePostDictionary, [NSString stringWithFormat:@"timeline/%@/%@", currentUserUid, newPostKey], nil];
        
        // update new post to followers timeline
        for (NSString *uid in followersUid) {
            [updateData setObject:timelinePostDictionary forKey:[NSString stringWithFormat:@"timeline/%@/%@", uid, newPostKey]];
        }
        
        // update new post to posts database
        NSDictionary *postDictionary = [post getPostDictionary];
        [updateData setObject:postDictionary forKey:[NSString stringWithFormat:@"%@/%@/%@", databasePosts, currentUserUid, newPostKey]];
        [rootRef updateChildValues:updateData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            FIRDatabaseReference *postCountRef = [[[FIRDatabase.database.reference child:databaseUsers] child:currentUserUid] child:userPostsCount];
            [postCountRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                NSInteger postsCount = currentData.value == [NSNull null] ? 0 : [currentData.value integerValue];
                NSInteger newPostsCount = postsCount + 1;
                currentData.value = [NSString stringWithFormat:@"%ld", (long)newPostsCount];
                return [FIRTransactionResult successWithValue:currentData];
            } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                if (error) {
                    NSLog(@"%@:Error increment postsCount by 1: %@", self.class, error.localizedDescription);
                }
            }];
        }];
    }];
}

+ (void)createPostForPostKey:(NSString *)postKey withPosterUid:(NSString *)posterUid andCallBack:(void (^)(Post *))callBack {
    FIRDatabaseReference *postRef = [[[FIRDatabase.database.reference child:databasePosts] child:posterUid] child:postKey];
    [postRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        Post *post = [[Post alloc] initWithSnapshot:snapshot];
        if (!post) {
            NSLog(@"%@: Cannot create post:%@", NSStringFromClass([self class]), post);
            callBack(nil);
        }
        else {
            callBack(post);
        }
    }];
}

@end
