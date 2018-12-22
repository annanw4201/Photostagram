//
//  CreateUsernameViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-21.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "CreateUsernameViewController.h"
#import "FIRUser.h"
#import "FIRDatabase.h"
#import "../Models/User.h"

@interface CreateUsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@end

@implementation CreateUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    // verify current logged in user and get username
    FIRUser *firUser = [FIRAuth.auth currentUser];
    NSString *username = self.usernameTextField.text;
    if (!username && [username isEqualToString:@""]) return;
    
    // specify where to store the data and to write the data
    FIRDatabaseReference *ref = [[FIRDatabase.database.reference child:@"users"] child:firUser.uid];
    
    __block User *usermodel = nil;
    NSDictionary *userAttrs = [NSDictionary dictionaryWithObject:username forKey:@"username"];
    [ref setValue:userAttrs];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        usermodel = [[User alloc] initWithSnapshot:snapshot];
        NSLog(@"%@", usermodel);
        if (usermodel) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.view.window setRootViewController:[mainStoryboard instantiateInitialViewController]];
            [self.view.window makeKeyAndVisible];
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
