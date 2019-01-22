//
//  paginationHelper.h
//  Photostagram
//
//  Created by Wong Tom on 2019-01-05.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface paginationHelper<ObjectType> : NSObject
- (instancetype)initWithService:(Class)service;
- (void)reloadData:(void(^)(NSArray *))callBack;
- (void) paginate:(void(^)(NSArray *))callBack;
@end

NS_ASSUME_NONNULL_END
