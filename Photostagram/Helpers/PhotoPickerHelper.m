//
//  PhotoPickerHelper.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-24.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "PhotoPickerHelper.h"

@interface PhotoPickerHelper()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, copy)void(^pickedImageHandler)(UIImage *image);
@end

@implementation PhotoPickerHelper

- (void)showPhotoPickerActionFromViewController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Where to get your photo?" preferredStyle:UIAlertControllerStyleActionSheet];
    // taking photo from camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera fromViewController:viewController];
        }];
        [alertController addAction:cameraAction];
    }
    // uploading photo from library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"Upload from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary fromViewController:viewController];
        }];
        [alertController addAction:photoLibraryAction];
    }
    // cancle action
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancleAction];
    // present the alert actions
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType fromViewController:(UIViewController *)viewController {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:sourceType];
    [imagePickerController setDelegate:self];
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.pickedImageHandler(selectedImage);
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPickedImageHandler:(void (^)(UIImage *image))pickedImageHandler {
    if (_pickedImageHandler != pickedImageHandler) {
        _pickedImageHandler = pickedImageHandler;
    }
}

@end
