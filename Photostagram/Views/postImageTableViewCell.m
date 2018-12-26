//
//  postImageTableViewCell.m
//  Photostagram
//
//  Created by Wong Tom on 2018-12-26.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "postImageTableViewCell.h"

@interface postImageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *postImageCellImageView;
@end

@implementation postImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageForPostImageCellImageView: (UIImage * _Nullable)image {
    [self.postImageCellImageView setImage:image];
}

@end
