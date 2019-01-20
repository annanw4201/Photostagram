//
//  ChatListTableViewCell.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-20.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "ChatListTableViewCell.h"

@interface ChatListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *namesLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@end

@implementation ChatListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNamesLabelText:(NSString *)text {
    self.namesLabel.text = text;
}

- (void)setLastMessageLabelText:(NSString *)text {
    self.lastMessageLabel.text = text;
}

@end
