//
//  friendsTableViewCell.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-31.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "friendsTableViewCell.h"

@interface friendsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followFriendButton;
@end

@implementation friendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configureFollowButton];
}

- (void)configureFollowButton {
    self.followFriendButton.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.followFriendButton.layer.borderWidth = 1;
    self.followFriendButton.layer.cornerRadius = 6;
    self.followFriendButton.clipsToBounds = true;
    [self.followFriendButton setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followFriendButton setTitle:@"Following" forState:UIControlStateSelected];
}

- (void)setFriendNameLabelText:(NSString *)friendName {
    self.friendNameLabel.text = friendName;
}

- (void)setFollowFriendButtonSelected:(BOOL)isSelected {
    self.followFriendButton.selected = isSelected;
}

- (IBAction)followButtonPressed:(UIButton *)sender {
    NSLog(@"follow button pressed");
    [self.delegate followButtonPressed:sender onFriendsCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
