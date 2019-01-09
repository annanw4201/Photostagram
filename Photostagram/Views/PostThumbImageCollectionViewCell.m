//
//  PostThumbImageCollectionViewCell.m
//  Photostagram
//
//  Created by Wong Tom on 2019-01-08.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import "PostThumbImageCollectionViewCell.h"

@interface PostThumbImageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@end

@implementation PostThumbImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setThumbImageForThumbImageViewImageViewWithUrl:(NSURL *)imageUrl {
    
}

- (void)setThumbImageForThumbImageViewImageViewBackground:(UIColor *)color {
    self.thumbImageView.backgroundColor = color;
}

@end
