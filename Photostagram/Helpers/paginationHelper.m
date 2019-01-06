//
//  paginationHelper.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-05.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "paginationHelper.h"
#import "../Services/UserService.h"
#import "../Models/Post.h"

#define queryPageSize 3; // this value must be greater than 1, otherwise firebase always return the same data
typedef NS_ENUM(NSInteger, paginationState) {
    initial = 0,
    ready = 1,
    loading = 2,
    end = 3
};

@interface paginationHelper()
@property(nonatomic) NSInteger pageSize;
@property(nonatomic) Class service;
@property(nonatomic) paginationState state;
@property(nonatomic) NSString *lastObjectKey;
@end

@implementation paginationHelper

- (instancetype)initWithService:(Class)service {
    self = [super init];
    if (self) {
        self.pageSize = queryPageSize;
        self.state = initial;
        self.service = service;
    }
    return self;
}

- (void) paginate:(void(^)(NSArray *))callBack {
    switch (self.state) {
        case initial:
            NSLog(@"%@: paginate state initial", self.class);
            self.lastObjectKey = nil;
        case ready:
        {
            NSLog(@"%@: paginate state ready", self.class);
            self.state = loading;
            if ([self.service isEqual:UserService.class]) {
                [UserService fetchTimelineForCurrentUser:self.pageSize
                                         withLastPostKey:self.lastObjectKey
                                             AndCallBack:^(NSArray * posts) {
                    Post *lastPost = [posts lastObject];
                    if (!self.lastObjectKey) { // if there is no last post key, then we are at the first page and return
                        self.lastObjectKey = [lastPost getKey];
                        self.state = posts.count < self.pageSize ? end : ready;
                        return callBack(posts);
                    }
                    else { // drop the first item in posts as the firebase will include last post
                        self.lastObjectKey = [lastPost getKey];
                        // if number of posts smaller than pageSize, then we reach the last page
                        self.state = posts.count < self.pageSize ? end : ready;
                        NSMutableArray *postsDroppedFirst = [posts mutableCopy];
                        [postsDroppedFirst removeObjectAtIndex:0];
                        return callBack(postsDroppedFirst);
                    }
                }];
            }
            else {
                NSLog(@"%@:paginate service is not userservice", self.class);
                callBack([NSArray array]);
            }
            break;
        }
        case loading:
        case end:
            NSLog(@"%@: paginate state loading or end", self.class);
            break;
        default:
            break;
    }
}

- (void)reloadData:(void (^)(NSArray *))callBack {
    self.state = initial;
    [self paginate:callBack];
}

@end
