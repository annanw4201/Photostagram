//
//  ChatListTableViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-19.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "ChatListTableViewController.h"

@interface ChatListTableViewController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation ChatListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    [self.view addGestureRecognizer:panGesture];
}

- (IBAction)dismissButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)panGesture {
    UIPercentDrivenInteractiveTransition *transition = [[UIPercentDrivenInteractiveTransition alloc] init];
    float percent = MAX([panGesture translationInView:self.view].x, 0) / self.view.frame.size.width;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.navigationController.delegate = self;
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"state began");
        case UIGestureRecognizerStateChanged:
            [transition updateInteractiveTransition:percent];
            NSLog(@"state change");
        case UIGestureRecognizerStateEnded:
        {
            float velocity = [panGesture velocityInView:self.view].x;
            if (percent > 0.5 || velocity > 1000) {
                [transition cancelInteractiveTransition];
            }
            NSLog(@"state end");
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            NSLog(@"state cancle, failed");
            [transition cancelInteractiveTransition];
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
