//
//  User.m
//  OnlineCourse
//
//  Created by Di Kong on 2/19/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init {

    self = [self initWithUserId:@"Default User" password:@""];
    return self;
}

- (instancetype)initWithUserId:(NSString *)userId password:(NSString *)password {

    self = [super init];
    if (self) {
        self.userId = userId;
        self.password = password;
    }
    return self;
}

- (NSString *)description {

    return [NSString stringWithFormat:@"User ID: %@   Password: %@", self.userId, self.password];
}

@end
