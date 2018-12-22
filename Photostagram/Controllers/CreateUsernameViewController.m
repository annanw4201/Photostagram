//
//  CreateUsernameViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-21.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "CreateUsernameViewController.h"
#import "../Models/User.h"
#import "../Services/UserService.h"

@interface CreateUsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@end

@implementation CreateUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    // get username from textfield
    NSString *textFieldUsername = self.usernameTextField.text;
    if (!textFieldUsername && [textFieldUsername isEqualToString:@""]) return;
    
    [UserService createUserWithName:textFieldUsername andCallBack:^(User * _Nonnull user) {
        if (user) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.view.window setRootViewController:[mainStoryboard instantiateInitialViewController]];
            [self.view.window makeKeyAndVisible];
            NSLog(@"username created and direct to MainVC");
        }
    }];
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
