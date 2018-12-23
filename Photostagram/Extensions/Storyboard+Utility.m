//
//  Storyboard+Utility.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-23.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "Storyboard+Utility.h"

@implementation Storyboard_Utility

- (instancetype)initWithType: (storyboardType)type {
    switch (type) {
        case storyboardMain:
            return (Storyboard_Utility *)[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
        case storyboardLogin:
            return (Storyboard_Utility *)[UIStoryboard storyboardWithName:@"Login" bundle:nil];
            break;
        default:
            return (Storyboard_Utility *)[UIStoryboard storyboardWithName:@"Login" bundle:nil];
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
