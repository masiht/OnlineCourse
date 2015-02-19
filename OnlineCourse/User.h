//
//  User.h
//  OnlineCourse
//
//  Created by Di Kong on 2/19/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *password;

- (instancetype)init;
- (instancetype)initWithUserId:(NSString *)userId password:(NSString *)password;

@end
