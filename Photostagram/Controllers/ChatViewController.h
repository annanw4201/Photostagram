//
//  ChatViewController.h
//  Photostagram
//
//  Created by Wong Tom on 2019-01-20.
//  Copyright © 2019 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
@import JSQMessagesViewController;

NS_ASSUME_NONNULL_BEGIN
@class Chat;

@interface ChatViewController : JSQMessagesViewController
- (void)setChat:(Chat *)chat;
@end

NS_ASSUME_NONNULL_END
