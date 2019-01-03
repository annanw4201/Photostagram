//
//  FriendsTableViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-31.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "../Models/User.h"
#import "../Views/friendsTableViewCell.h"
#import "../Services/UserService.h"
#import "../Services/FollowService.h"

@interface FriendsTableViewController ()<friendsTableViewCellDelegate>
@property(nonatomic, strong)NSArray *users;
@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 72;
    [UserService fetchUsersExceptCurrentUser:^(NSArray * _Nonnull users) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.users = users;
        });
    }];
}

- (void)setUsers:(NSArray *)users {
    if (_users != users) {
        _users = users;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell" forIndexPath:indexPath];
    // Configure the cell...
    
    User *user = [self.users objectAtIndex:indexPath.row];
    [(friendsTableViewCell *)cell setFriendNameLabelText:[user getUsername]];
    [(friendsTableViewCell *)cell setFollowFriendButtonSelected:[user getIsFollowed]];
    [(friendsTableViewCell *)cell setDelegate:self];
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma friendsTableViewCellDelegate
- (void)followButtonPressed:(UIButton *)followButton onFriendsCell:(friendsTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [followButton setUserInteractionEnabled:NO];
    User *followee = [self.users objectAtIndex:indexPath.row];
    [FollowService setIsFollowing:![followee getIsFollowed] fromCurrentUserToFollowee:followee andCallBack:^(BOOL success) {
        [followButton setUserInteractionEnabled:YES];
        if (!success) {
            return;
        }
        [followee setIsFollowed:![followee getIsFollowed]];
        NSArray *indexPathsToReload = [NSArray arrayWithObjects:indexPath, nil];
        [self.tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationFade];
    }];
}

@end
