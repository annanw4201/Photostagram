//
//  Post.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-25.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "Post.h"
#import "FIRDataSnapshot.h"
#import "../Models/User.h"

@interface Post()
@property(nonatomic)NSString *key;
@property(nonatomic)NSString *imageUrl;
@property(nonatomic)NSDate *creationDate;
@property(nonatomic)CGFloat imageHeight;
@property(nonatomic)NSString *uid;
@property(nonatomic)NSString *username;
@property(nonatomic)NSString *likeCounts;
@property(nonatomic)BOOL currentUserLikedThisPost;
@end

@implementation Post

- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot {
    NSDictionary *snapshotDict = [snapshot value];
    NSString *key = [snapshot key];
    NSString *imageUrl = [snapshotDict valueForKey:@"image_url"];
    NSString *imageHeight = [snapshotDict valueForKey:@"image_height"];
    NSString *creationDate = [snapshotDict valueForKey:@"creation_date"];
    NSString *uid = [snapshotDict valueForKey:@"uid"];
    NSString *username = [snapshotDict valueForKey:@"username"];
    NSString *likeCounts = [snapshotDict valueForKey:@"like_counts"];
    if (!key || !imageUrl || !imageHeight || !creationDate || !uid || !username || !likeCounts) {
        return nil;
    }
    self.key = key;
    self.imageUrl = imageUrl;
    self.imageHeight = [imageHeight floatValue];
    self.creationDate = [NSDate dateWithTimeIntervalSince1970:[creationDate doubleValue]];
    self.uid = uid;
    self.username = username;
    self.likeCounts = likeCounts;
    
    return self;
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl andImageHeight:(CGFloat)imageHeight {
    _imageUrl = imageUrl;
    _imageHeight = imageHeight;
    _creationDate = [NSDate date];
    _likeCounts = @"0";
    _uid = [User getUserUid];
    _username = [User getUsername];
    _currentUserLikedThisPost = NO;
    return self;
}

- (NSDictionary *)getPostDictionary {
    NSTimeInterval createdDate = [self.creationDate timeIntervalSince1970];
    return [NSDictionary dictionaryWithObjectsAndKeys:self.imageUrl, @"image_url",
            [NSString stringWithFormat:@"%f", self.imageHeight], @"image_height",
            [NSString stringWithFormat:@"%f", createdDate], @"creation_date",
            self.uid, @"uid", self.username, @"username", self.likeCounts, @"like_counts",
            [NSString stringWithFormat:@"%d", self.currentUserLikedThisPost], @"current_user_like_this_post", nil];
}

- (CGFloat)getImageHeight {
    return self.imageHeight;
}

- (NSString *)getImageUrl {
    return self.imageUrl;
}

- (NSDate *)getCreationDate {
    return self.creationDate;
}

- (NSString *)getKey {
    return self.key;
}

- (NSString *)getPosterUid {
    return self.uid;
}

- (NSString *)getPosterUsername {
    return self.username;
}

- (NSString *)getLikeCounts {
    return self.likeCounts;
}

- (void)setLikeCounts:(NSString *)likeCounts {
    _likeCounts = likeCounts;
}

- (BOOL)getCurrentUserLikedThisPost {
    return self.currentUserLikedThisPost;
}

- (void)setCurrentUserLikedThisPost:(BOOL)currentUserLikedThisPost {
    _currentUserLikedThisPost = currentUserLikedThisPost;
}

@end
