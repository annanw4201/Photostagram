//
//  UIImage+size.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-25.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+size.h"

@implementation UIImage(aspectHeight)

- (void)setAspectHeight:(CGFloat)aspectHeight {
    self.aspectHeight = aspectHeight;
}

- (CGFloat)aspectHeight {
    CGFloat heightRatio = self.size.height / 736;
    CGFloat widthRatio = self.size.width / 414;
    CGFloat aspectRation = fmax(heightRatio, widthRatio);
    return self.size.height / aspectRation;
}

@end
