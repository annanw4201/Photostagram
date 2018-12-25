//
//  Post.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-25.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "Post.h"

@interface Post()
@property(nonatomic)NSString *key;
@property(nonatomic)NSString *imageUrl;
@property(nonatomic)NSDate *creationDate;
@property(nonatomic)CGFloat imageHeight;
@end

@implementation Post

- (instancetype)initWithImageUrl:(NSString *)imageUrl andImageHeight:(CGFloat)imageHeight {
    _imageUrl = imageUrl;
    _imageHeight = imageHeight;
    _creationDate = [NSDate date];
    return self;
}

- (NSDictionary *)dictionary {
    NSTimeInterval createdDate = [self.creationDate timeIntervalSince1970];
    return [NSDictionary dictionaryWithObjectsAndKeys:self.imageUrl, @"image_url", self.imageHeight, @"image_height", createdDate, @"creation_date", nil];
}

@end
