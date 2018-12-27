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

- (IBAction)favoriteButtonPressed:(UIButton *)sender {
    
}

- (void)setPostTimeLabelText:(NSString *)timeStamp {
    [self.postTimeLabel setText:timeStamp];
}

+ (CGFloat)getHeight {
    return postActionTableViewCellHeight;
}

@end
