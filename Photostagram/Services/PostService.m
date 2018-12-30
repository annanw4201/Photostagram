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
    NSString *currentUserUid = currentUser.uid;
    Post *post = [[Post alloc] initWithImageUrl:urlString andImageHeight:aspectHeight];
    NSDictionary *postDictionary = [post getPostDictionary];
    FIRDatabaseReference *postRef = [[[FIRDatabase.database.reference child:databasePosts] child:currentUserUid] childByAutoId];
    [postRef updateChildValues:postDictionary];
}

@end
