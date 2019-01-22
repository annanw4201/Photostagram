//
//  FIRStorageReference+Post.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-25.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <FirebaseStorage/FirebaseStorage.h>

NS_ASSUME_NONNULL_BEGIN

@interface FIRStorageReference (newPostImageReference)
+ (FIRStorageReference *)newPostImageReference;
@end

NS_ASSUME_NONNULL_END
