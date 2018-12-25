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

@implementation PostService

+ (void)createPostForImage:(UIImage *)image {
    FIRStorageReference *imageRef = [FIRStorageReference newPostImageReference];
    [StorageService uploadImage:image atReference:imageRef withCallBack:^(NSURL * _Nonnull url) {
        if (!url) return;
        NSString *urlString = url.absoluteString;
        [self createPostForUrlString:urlString withAspectHeight:image.aspectHeight];
        NSLog(@"urlString: %@", urlString);
    }];
}

+ (void)createPostForUrlString:(NSString *)urlString withAspectHeight:(CGFloat)aspectHeight {
    User *currentUser = [User getCurrentUser];
    Post *post = [[Post alloc] initWithImageUrl:urlString andImageHeight:aspectHeight];
    NSDictionary *postDictionary = [post dictionary];
    FIRDatabaseReference *postRef = [[[FIRDatabase.database.reference child:@"posts"] child:currentUser.uid] childByAutoId];
    [postRef updateChildValues:postDictionary];
}

@end
