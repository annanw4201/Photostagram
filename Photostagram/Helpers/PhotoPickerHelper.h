//
//  PhotoPickerHelper.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-24.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoPickerHelper : NSObject
- (void)showPhotoPickerActionFromViewController:(UIViewController *)viewController;
- (void)presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType fromViewController:(UIViewController *)viewController;
- (void)setPickedImageHandler: (void(^)(UIImage *image))pickedImageHandler;
@end

NS_ASSUME_NONNULL_END
