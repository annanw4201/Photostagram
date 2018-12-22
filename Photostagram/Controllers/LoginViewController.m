//
//  LoginViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-21.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "LoginViewController.h"
#import "FirebaseAuth.h"
#import "FirebaseUI-umbrella.h"
#import "FirebaseDatabase.h"
#import "../Models/User.h"

@interface LoginViewController ()<FUIAuthDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)signUpOrSignIn:(UIButton *)sender {
    FUIAuth *authUI = [FUIAuth defaultAuthUI];
    authUI.delegate = self;
    [self presentViewController:authUI.authViewController animated:YES completion:nil];
}

- (void)authUI:(FUIAuth *)authUI didSignInWithAuthDataResult:(FIRAuthDataResult *)authDataResult error:(NSError *)error {
    if (error) {
        NSLog(@"Error when signing in: %@", [error localizedDescription]);
        return;
    }
    FIRUser *firUser = authDataResult.user;
    FIRDatabaseReference *ref = [[FIRDatabase.database.reference child:@"users"] child:firUser.uid];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        User *usermodel = [[User alloc] initWithSnapshot:snapshot];
        if (usermodel) {
            NSLog(@"Welcome back: %@", usermodel.username);
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.view.window setRootViewController:[mainStoryboard instantiateInitialViewController]];
            [self.view.window makeKeyAndVisible];
        }
        else {
            NSLog(@"New User and direct to create username");
            [self performSegueWithIdentifier:@"createUsernameSegue" sender:self];
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
