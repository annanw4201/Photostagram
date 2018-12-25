//
//  Storyboard+Utility.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-23.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "Storyboard+Utility.h"

@implementation UIStoryboard (initialViewControllerOfType)

- (instancetype)initWithType: (storyboardType)type {
    switch (type) {
        case storyboardMain:
            return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
        case storyboardLogin:
            return [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            break;
        default:
            return [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            break;
    }
}

+ (UIViewController *)initialViewControllerOfType:(storyboardType)type {
    UIStoryboard *storyboard = (UIStoryboard *)[[self alloc] initWithType:type];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    if (!vc) {
        NSLog(@"Cannot init vc for the storyboard: %@", storyboard);
    }
    return vc;
}

@end
