//
//  postHeaderTableViewCell.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-26.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "postHeaderTableViewCell.h"
#import "../Supporting/Constants.h"

@interface postHeaderTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@end

@implementation postHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)optionButtonPressed:(UIButton *)sender {
    NSLog(@"displaying options");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUsernameLabelText:(NSString *)username {
    [self.usernameLabel setText:username];
}

+ (CGFloat)getHeight {
    return postHeaderTableViewCellHeight;
}

@end
