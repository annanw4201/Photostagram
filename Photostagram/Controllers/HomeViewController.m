//
//  HomeViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-23.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "HomeViewController.h"
#import "../Services/UserService.h"
#import "../Models/User.h"
#import "../Models/Post.h"
#import "../Views/postImageTableViewCell.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) NSArray *postArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureTableView];
    [UserService retrievePostsForUser:[User getCurrentUser] withCallBack:^(NSArray * _Nonnull posts) {
        self.postArray = posts;
    }];
}

- (void)configureTableView {
    [self.homeTableView setDataSource:self];
    [self.homeTableView setDelegate:self];
    [self.homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)setPostArray:(NSArray *)postArray {
    if (_postArray != postArray) {
        _postArray = postArray;
        [self.homeTableView reloadData];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homePostImageCell" forIndexPath:indexPath];
    Post *postAtCurrentRow = [self.postArray objectAtIndex:indexPath.row];
    NSString *urlStringForCurrentRowImage = [postAtCurrentRow getImageUrl];
    NSInteger currentRow = indexPath.row;
    [(postImageTableViewCell *)cell setImageForPostImageCellImageView:nil];

    dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
    dispatch_async(downloadQueue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStringForCurrentRowImage]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"set image for current row: %ld", (long)indexPath.row);
            if (currentRow == indexPath.row) {
                [(postImageTableViewCell *)cell setImageForPostImageCellImageView:image];
            }
        });
    });
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.postArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *postAtCurrentRow = [self.postArray objectAtIndex:indexPath.row];
    return [postAtCurrentRow getImageHeight];
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
