//
//  postActionTableViewCell.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-26.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class postActionTableViewCell;

@protocol postActionTableViewCellDelegate <NSObject>
- (void)likeButtonPressed:(UIButton *)likeButton onActionCell:(postActionTableViewCell *)postActionTableViewCell;
@end

@interface postActionTableViewCell : UITableViewCell
- (void)setPostTimeLabelText: (NSString *)timeStamp;
- (void)setLikesLabelText: (NSString *)likeCounts;
- (void)setLikeButtonSelected:(BOOL)selected;
+ (CGFloat)getHeight;
@property (nonatomic, weak)id<postActionTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
