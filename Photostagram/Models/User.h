//
//  User.h
//  Photostagram
//
//  Created by Wong Tom on 2018-12-21.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FIRDataSnapshot;

@interface User : NSObject
@property(nonatomic, weak) NSString *uid;
@property(nonatomic, weak) NSString *username;

-(id)initWithSnapshot:(FIRDataSnapshot *)snapshot;
-(instancetype)initWithUid:(NSString *)uid username:(NSString *)username;
@end

NS_ASSUME_NONNULL_END
