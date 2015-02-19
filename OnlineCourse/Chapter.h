//
//  Chapter.h
//  OnlineCourse
//
//  Created by Di Kong on 2/19/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chapter : NSObject

@property (nonatomic, strong) NSString *chapterTitle;
@property (nonatomic, strong) NSString *chapterText;
@property (nonatomic, strong) NSString *videoUrl;

- (instancetype)init;
- (instancetype)initWithChapterTitle:(NSString *)chapterTitle chapterText:(NSString *)chapterText videoUrl:(NSString *)videoUrl;

@end
