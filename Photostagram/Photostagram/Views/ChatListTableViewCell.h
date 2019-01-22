//
//  ChatListTableViewCell.h
//  Photostagram
//
//  Created by Wong Tom on 2019-01-20.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatListTableViewCell : UITableViewCell
- (void)setNamesLabelText:(NSString *)text;
- (void)setLastMessageLabelText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
