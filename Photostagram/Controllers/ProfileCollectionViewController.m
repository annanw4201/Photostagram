//
//  ProfileCollectionViewController.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-08.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "ProfileCollectionViewController.h"
#import "../Views/PostThumbImageCollectionViewCell.h"
#import "../Views/ProfileHeaderCollectionReusableView.h"
#import "../Models/User.h"
#import "FIRDatabase.h"
#import "../Services/UserService.h"
#import "../Models/Post.h"
#import "FIRAuth.h"
#import "../Controllers/LoginViewController.h"
#import "../Extensions/Storyboard+Utility.h"

@interface ProfileCollectionViewController ()<UICollectionViewDelegateFlowLayout, ProfileHeaderCollectionReusableViewDelegate>
@property(nonatomic, strong)User *user;
@property(nonatomic, strong)NSArray *posts;
@property(nonatomic) FIRAuthStateDidChangeListenerHandle authHandle;
@end

@implementation ProfileCollectionViewController

static NSString * const reuseIdentifier = @"PostThumbImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[PostThumbImageCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.user = [User getCurrentUser];
    [UserService fetchProfileForUser:self.user andCallBack:^(FIRDatabaseReference * _Nonnull userRef, User * _Nonnull user, NSArray * _Nonnull posts) {
        self.posts = posts;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
    // add listener for observing user's login status
    self.authHandle = [FIRAuth.auth addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        // if user log out, user should be nil
        if (user != nil) return;
        UIViewController *loginVC = [UIStoryboard initialViewControllerOfType:storyboardLogin];
        [self.view.window setRootViewController:loginVC];
        [self.view.window makeKeyAndVisible];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.authHandle) {
        [FIRAuth.auth removeAuthStateDidChangeListener:self.authHandle];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat colums = 3;
    CGFloat spacing = 1.5;
    CGFloat totalHorizontalSpacing = (colums - 1) * spacing;
    
    CGFloat itemWidth = (collectionView.bounds.size.width - totalHorizontalSpacing) / colums;
    CGSize size = CGSizeMake(itemWidth, itemWidth);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.5;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PostThumbImageCollectionViewCell *thumbImageCell = (PostThumbImageCollectionViewCell *)cell;
    // Configure the cell
    Post *post = [self.posts objectAtIndex:indexPath.row];
    NSString *imageUrlString = [post getImageUrl];
    [thumbImageCell setThumbImageForThumbImageViewImageViewWithUrl:[NSURL URLWithString:imageUrlString]];
    return thumbImageCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind != UICollectionElementKindSectionHeader) {
        NSLog(@"%@: kind is not Header", self.class);
    }
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ProfileHeaderView" forIndexPath:indexPath];
    ProfileHeaderCollectionReusableView *headerView = (ProfileHeaderCollectionReusableView *)view;
    [headerView setPostsCountLabelText:[self.user getPostsCount]];
    [headerView setFollowerCountLabelText:[self.user getFollowerCount]];
    [headerView setFollowingCountLabelText:[self.user getFollowingCount]];
    [headerView setDelegate:self];
    return headerView;
}

#pragma mark <ProfileHeaderCollectionReusableViewDelegate>
- (void)settingsButtonPressed:(UIButton *)sender fromHeaderView:(ProfileHeaderCollectionReusableView *)headerView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *signOutAction = [UIAlertAction actionWithTitle:@"Sign Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"user signing out");
        NSError *error = nil;
        [FIRAuth.auth signOut:&error];
        if (error) {
            NSLog(@"%@: Error signing out: %@", self.class, error.localizedDescription);
        }
    }];
    [alertController addAction:signOutAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
