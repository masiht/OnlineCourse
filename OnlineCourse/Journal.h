//
//  Journal.h
//  OnlineCourse
//
//  Created by Di Kong on 2/19/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Journal : NSObject

@property (nonatomic, assign) NSUInteger journalId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *chapterTitle;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSDate *date;

- (instancetype)init;
- (instancetype)initWithJournalId:(NSUInteger)journalId userId:(NSString *)userId chapterTitle:(NSString *)chapterTitle comment:(NSString *)comment date:(NSDate *)date;
- (NSString *)dateString;

@end
