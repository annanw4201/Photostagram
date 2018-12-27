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
#import "../Views/postHeaderTableViewCell.h"
#import "../Views/postActionTableViewCell.h"
#import "../Supporting/Constants.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) NSArray *postArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureRefreshControl];
    [self configureTableView];
    [self refreshPosts:nil];
}

- (void)configureRefreshControl {
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    [control addTarget:self action:@selector(refreshPosts:) forControlEvents:UIControlEventValueChanged];
    [control setTintColor:[UIColor colorWithRed:0.25 green:0.72 blue:0.85 alpha:1.0]];
    [control setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Fetching data..."]];
    self.refreshControl = control;
}

- (void)refreshPosts:(id)sender {
    NSLog(@"refresh posts");
    [UserService retrievePostsForUser:[User getCurrentUser] withCallBack:^(NSArray * _Nonnull posts) {
        self.postArray = posts;
    }];
    [self.refreshControl endRefreshing];
}

- (void)configureTableView {
    [self.homeTableView setDataSource:self];
    [self.homeTableView setDelegate:self];
    [self.homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (@available(iOS 10.0, *)) {
        [self.homeTableView setRefreshControl:self.refreshControl];
    }
    else {
        [self.homeTableView addSubview:self.refreshControl];
    }
}

- (void)setPostArray:(NSArray *)postArray {
    if (_postArray != postArray) {
        _postArray = postArray;
        [self.homeTableView reloadData];
    }
}

// get time stamp of the post in the format as (yyyy-mm-dd, hh:mm)
- (NSString *)timeStampOfPost: (Post *)post {
    NSDate *postCreationDate = [post getCreationDate];
    NSString *timeStamp = [NSDateFormatter localizedStringFromDate:postCreationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    return timeStamp;
}

// create cell for each section where each section contains three rows
//  Each post will be a section, three rows in a section are one of postImage
//  postHeader and postAction cell.
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSInteger currentSection = indexPath.section;
    Post *postAtCurrentSection = [self.postArray objectAtIndex:currentSection];
    
    // create cell for the three rows in a section where each section is a post
    switch (indexPath.row) {
        case postHeaderTableViewCellRow:
            cell = [tableView dequeueReusableCellWithIdentifier:@"homePostHeaderCell"];
            [(postHeaderTableViewCell *)cell setUsernameLabelText:[User getUsername]];
            break;
        case postImageTableViewCellRow:
            cell = [tableView dequeueReusableCellWithIdentifier:@"homePostImageCell"];
            [(postImageTableViewCell *)cell setImageForPostImageCellImageView:nil]; // initial image for the post should be blank
        {
            // use GCD to download images asychronously
            dispatch_queue_t downloadQueue = dispatch_queue_create("download", nil);
            dispatch_async(downloadQueue, ^{
                NSString *urlStringForCurrentRowImage = [postAtCurrentSection getImageUrl];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStringForCurrentRowImage]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (currentSection == indexPath.section) {
                        [(postImageTableViewCell *)cell setImageForPostImageCellImageView:image];
                    }
                });
            });
        }
            break;
        case postActionTableViewCellRow:
            cell = [tableView dequeueReusableCellWithIdentifier:@"homePostActionCell"];
            [(postActionTableViewCell *)cell setPostTimeLabelText:[self timeStampOfPost:postAtCurrentSection]];
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.postArray count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case postHeaderTableViewCellRow:
            height = [postHeaderTableViewCell getHeight];
            break;
        case postImageTableViewCellRow:
        {
            Post *postAtCurrentRow = [self.postArray objectAtIndex:indexPath.row];
            height = [postAtCurrentRow getImageHeight];
        }
            break;
        case postActionTableViewCellRow:
            height = [postActionTableViewCell getHeight];
            break;
        default:
            break;
    }
    return height;
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
