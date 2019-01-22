//
//  PostThumbImageCollectionViewCell.h
//  Photostagram
//
//  Created by Wong Tom on 2019-01-08.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostThumbImageCollectionViewCell : UICollectionViewCell
- (void)setThumbImageForThumbImageViewImageViewWithUrl: (NSURL *)imageUrl;
- (void)setThumbImageForThumbImageViewImageViewBackground: (UIColor *)color;
@end

NS_ASSUME_NONNULL_END
