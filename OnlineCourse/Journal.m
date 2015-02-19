//
//  Journal.m
//  OnlineCourse
//
//  Created by Di Kong on 2/19/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "Journal.h"

@implementation Journal

- (instancetype)init {

    self = [self initWithJournalId:0 userId:@"Default User" chapterTitle:@"Default Chapter" comment:@"No Comment" date:[NSDate date]];
    return self;
}

- (instancetype)initWithJournalId:(NSUInteger)journalId userId:(NSString *)userId chapterTitle:(NSString *)chapterTitle comment:(NSString *)comment date:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.journalId = journalId;
        self.userId = userId;
        self.chapterTitle = chapterTitle;
        self.comment = comment;
        self.date = date;
    }
    return self;
}

- (NSString *)dateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    return [formatter stringFromDate:self.date];
}

@end
