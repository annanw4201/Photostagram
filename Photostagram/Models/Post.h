//
//  Post.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-25.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject
- (instancetype)initWithImageUrl:(NSString *)imageUrl andImageHeight:(CGFloat)imageHeight;
- (NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
