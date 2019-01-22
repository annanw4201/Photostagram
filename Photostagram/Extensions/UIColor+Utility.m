//
//  UIColor+Utility.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-06.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)
+ (instancetype)initUsingHex:(NSInteger)hex {
    CGFloat R = ((hex >> 16) & 0xff) / 255.0;
    CGFloat G = ((hex >> 8) & 0xff) / 255.0;
    CGFloat B = ((hex >> 0) & 0xff) / 255.0;
    UIColor *color = [[UIColor alloc] initWithRed:R green:G blue:B alpha:1];
    return color;
}

+ (UIColor *)appBlue {
    return [UIColor initUsingHex:0x3796F0];
}

+ (UIColor *)appRed {
    return [UIColor initUsingHex:0xE7554B];
}

+ (UIColor *)appLightGray {
    return [UIColor initUsingHex:0xDDDCDC];
}

@end
