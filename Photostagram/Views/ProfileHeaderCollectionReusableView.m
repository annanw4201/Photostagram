//
//  ProfileHeaderCollectionReusableView.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-09.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "ProfileHeaderCollectionReusableView.h"

@interface ProfileHeaderCollectionReusableView()
@property (weak, nonatomic) IBOutlet UILabel *postsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@end

@implementation ProfileHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.settingsButton.layer.cornerRadius = 6;
    self.settingsButton.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.settingsButton.layer.borderWidth = 1;
}

- (IBAction)settingsButtonPressed:(UIButton *)sender {
    NSLog(@"%@: setting button pressed", self.class);
}

- (void)setPostsCountLabelText:(NSString *)postsCount {
    self.postsCountLabel.text = postsCount;
}

- (void)setFollowerCountLabelText:(NSString *)followerCount {
    self.followerCountLabel.text = followerCount;
}

- (void)setFollowingCountLabelText:(NSString *)followingCount {
    self.followingCountLabel.text = followingCount;
}

@end
