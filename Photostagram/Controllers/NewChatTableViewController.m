//
//  NewChatTableViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-20.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "NewChatTableViewController.h"
#import "../Views/NewChatUserTableViewCell.h"
#import "../Models/User.h"
#import "../Services/UserService.h"
#import "ChatViewController.h"
#import "../Services/ChatService.h"
#import "../Models/Chat.h"

@interface NewChatTableViewController ()
@property(nonatomic, strong)NSArray *followingUsers;
@property(nonatomic, weak)User *selectedUser;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;
@property(nonatomic, strong)Chat *chat;
@end

@implementation NewChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.nextBarButtonItem setEnabled:NO];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [UserService fetchFollowingUsersForUser:[User getCurrentUser] andCallBack:^(NSArray *users) {
        self.followingUsers = users;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender {
    if (!self.selectedUser) return;
    else {
        [sender setEnabled:NO];
        [ChatService retrieveExistingChatForUser:[User getCurrentUser] andCallBack:^(Chat *chat) {
            if (!chat) {
                NSArray *members = @[[User getCurrentUser], self.selectedUser];
                self.chat = [[Chat alloc] initWithMembers:members];
            }
            else self.chat = chat;
            [self performSegueWithIdentifier:@"toChatSegue" sender:self];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followingUsers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewChatUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newChatUserCell" forIndexPath:indexPath];
    
    // Configure the cell...
    User *user = self.followingUsers[indexPath.row];
    cell.textLabel.text = [user getUsername];
    if (self.selectedUser && [self.selectedUser getUserUid] == [user getUserUid]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewChatUserTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self.nextBarButtonItem setEnabled:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewChatUserTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [self.nextBarButtonItem setEnabled:NO];
}

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toChatSegue"]) {
        ChatViewController *chatVC = segue.destinationViewController;
        [chatVC setChat:self.chat];
    }
}

@end
