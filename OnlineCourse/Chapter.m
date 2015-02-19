//
//  Chapter.m
//  OnlineCourse
//
//  Created by Di Kong on 2/19/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "Chapter.h"

@implementation Chapter

- (instancetype)init {

    self = [self initWithChapterTitle:@"Default Chapter" chapterText:@"Default Text" videoUrl:@"http://localhost/"];
    return self;
}

- (instancetype)initWithChapterTitle:(NSString *)chapterTitle chapterText:(NSString *)chapterText videoUrl:(NSString *)videoUrl {

    self = [super init];
    if (self) {
        self.chapterTitle = chapterTitle;
        self.chapterText = chapterText;
        self.videoUrl = videoUrl;
    }
    return self;
}

@end
