//
//  StorageService.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-24.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class FIRStorageReference;

NS_ASSUME_NONNULL_BEGIN

@interface StorageService : NSObject
+ (void)uploadImage:(UIImage *)image atReference:(FIRStorageReference *)ref withCallBack:(void(^)(NSURL *url))callBack;
@end

NS_ASSUME_NONNULL_END
