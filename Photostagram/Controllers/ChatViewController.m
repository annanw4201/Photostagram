//
//  ChatViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-20.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "ChatViewController.h"
#import "../Models/Chat.h"

@interface ChatViewController ()
@property(nonatomic, weak)Chat *chat;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setChat:(Chat *)chat {
    if (_chat != chat) _chat = chat;
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
