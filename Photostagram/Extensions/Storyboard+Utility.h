//
//  Storyboard+Utility.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-23.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, storyboardType) {
    storyboardMain,
    storyboardLogin
};

@interface UIStoryboard (initialViewControllerOfType)
+ (UIViewController *)initialViewControllerOfType:(storyboardType)type;
@end

NS_ASSUME_NONNULL_END
