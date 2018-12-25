//
//  MainTabBarViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-24.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "../Supporting/Constants.h"
#import "../Helpers/PhotoPickerHelper.h"
#import "../Services/PostService.h"

@interface MainTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic)PhotoPickerHelper *photoPickerHelper;
@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.photoPickerHelper = [[PhotoPickerHelper alloc] init];
    [self.photoPickerHelper setPickedImageHandler:^(UIImage *image) {
        NSLog(@"Create post for the selected image");
        [PostService createPostForImage:image];
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController.tabBarItem.tag == photoPickerTabBarItemTag) {
        NSLog(@"photo picker");
        [self.photoPickerHelper showPhotoPickerActionFromViewController:self];
        return NO;
    }
    else {
        return YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
