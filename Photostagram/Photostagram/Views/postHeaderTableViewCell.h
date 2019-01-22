//
//  postHeaderTableViewCell.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-26.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface postHeaderTableViewCell : UITableViewCell
- (void)setUsernameLabelText: (NSString *)username;

+ (CGFloat)getHeight;
@end

NS_ASSUME_NONNULL_END
