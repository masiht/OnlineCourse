//
//  DataCenter.m
//  OnlineCourse
//
//  Created by Di Kong on 2/24/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "CurrentData.h"

@implementation CurrentData

+ (CurrentData *)sharedData {
    
    static CurrentData *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[self alloc] init];
    });
    return sharedData;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = nil;
        self.chapterTitle = nil;
        self.playback = CMTimeMake(0, 1);
    }
    return self;
}

@end
