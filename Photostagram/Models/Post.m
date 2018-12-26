//
//  Post.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-25.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "Post.h"
#import "FIRDataSnapshot.h"

@interface Post()
@property(nonatomic)NSString *key;
@property(nonatomic)NSString *imageUrl;
@property(nonatomic)NSDate *creationDate;
@property(nonatomic)CGFloat imageHeight;
@end

@implementation Post

- (instancetype)initWithSnapshot:(FIRDataSnapshot *)snapshot {
    NSDictionary *snapshotDict = [snapshot value];
    NSString *imageUrl = [snapshotDict valueForKey:@"image_url"];
    NSString *imageHeight = [snapshotDict valueForKey:@"image_height"];
    NSString *creationDate = [snapshotDict valueForKey:@"creation_date"];
    if (!imageUrl || !imageHeight || !creationDate) {
        return nil;
    }
    self.imageUrl = imageUrl;
    self.imageHeight = [imageHeight floatValue];
    self.creationDate = [NSDate dateWithTimeIntervalSince1970:[creationDate doubleValue]];
    return self;
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl andImageHeight:(CGFloat)imageHeight {
    _imageUrl = imageUrl;
    _imageHeight = imageHeight;
    _creationDate = [NSDate date];
    return self;
}

- (NSDictionary *)dictionary {
    NSTimeInterval createdDate = [self.creationDate timeIntervalSince1970];
    return [NSDictionary dictionaryWithObjectsAndKeys:self.imageUrl, @"image_url", [NSString stringWithFormat:@"%f", self.imageHeight], @"image_height", [NSString stringWithFormat:@"%f", createdDate], @"creation_date", nil];
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

@end
