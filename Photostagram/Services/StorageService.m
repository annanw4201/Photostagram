//
//  StorageService.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-24.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "StorageService.h"
#import "FirebaseStorage.h"

@implementation StorageService

+ (void)uploadImage:(UIImage *)image atReference:(FIRStorageReference *)ref withCallBack:(void (^)(NSURL *url))callBack {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    if (!imageData) {
        
        return callBack(nil);
    }
    
    // put the data at the reference location
    [ref putData:imageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error) {
            return callBack(nil);
        }
        
        // if successfully save the data then to return URL via the callback
        [ref downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
            if (error) {
                return callBack(nil);
            }
            callBack(URL);
        }];
    }];
}

@end
