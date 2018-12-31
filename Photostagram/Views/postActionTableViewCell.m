//
//  postActionTableViewCell.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-26.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "postActionTableViewCell.h"
#import "../Supporting/Constants.h"

@interface postActionTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@end

@implementation postActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonPressed:(UIButton *)sender {
    NSLog(@"like button pressed");
    [self.delegate likeButtonPressed:sender onActionCell:self];
}

- (void)setPostTimeLabelText:(NSString *)timeStamp {
    [self.postTimeLabel setText:timeStamp];
}

- (void)setLikesLabelText:(NSString *)likeCounts {
    [self.likesLabel setText:likeCounts];
}

- (void)setLikeButtonSelected:(BOOL)selected {
    [self.likeButton setSelected:selected];
}

+ (CGFloat)getHeight {
    return postActionTableViewCellHeight;
}

@end
