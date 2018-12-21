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
    FIRUser *user = authDataResult.user;
    FIRDatabaseReference *userRef = [[FIRDatabase.database.reference child:@"users"] child:user.uid];
    [userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        User *user = [[User init] initWithSnapshot:snapshot];
        if (user) {
            NSLog(@"Welcome back: %@", user.username);
        }
        else {
            NSLog(@"New User.");
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
