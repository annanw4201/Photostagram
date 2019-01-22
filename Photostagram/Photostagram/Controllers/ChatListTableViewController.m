//
//  ChatListTableViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-19.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "ChatListTableViewController.h"
#import "../Views/ChatListTableViewCell.h"
#import "../Models/Chat.h"
#import "FIRDatabase.h"
#import "../Services/UserService.h"
#import "../Models/User.h"
#import "ChatViewController.h"

@interface ChatListTableViewController ()
@property(nonatomic, strong)NSArray *chats;
@property(nonatomic)FIRDatabaseHandle chatsHandle;
@property(nonatomic, weak)FIRDatabaseReference *chatsRef;
@end

@implementation ChatListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    [self.view addGestureRecognizer:panGesture];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [UserService ObserveChatsForUser:[User getCurrentUser] andCallBack:^(FIRDatabaseReference * _Nonnull ref, NSArray * _Nonnull chats) {
        self.chatsRef = ref;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.chats = chats;
        });
    }];
}

- (void)dealloc {
    if (self.chatsHandle) [self.chatsRef removeObserverWithHandle:self.chatsHandle]; // stop observing chats in database
}

- (void)setChats:(NSArray *)chats {
    if (_chats != chats) {
        _chats = chats;
        [self.tableView reloadData];
    }
}

- (IBAction)dismissButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)panGesture {
    float percent = MAX([panGesture locationInView:self.view].x , 0) / self.view.frame.size.width;
    if (percent > 0.7) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Chat *chat = self.chats[indexPath.row];
    [cell setNamesLabelText:[chat getTitle]];
    [cell setLastMessageLabelText:[chat getLastMessage]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toChatSegue" sender:self];
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
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [chatVC setChat:self.chats[indexPath.row]];
    }
    
}

@end
