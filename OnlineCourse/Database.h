//
//  DBModel.h
//  OnlineCourse
//
//  Created by Di Kong on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class User;
@class Chapter;
@class Journal;

@interface Database : NSObject {
    sqlite3 *db;
    NSString *dbPath;
}

@property (nonatomic, strong) NSString *currentUserId;
@property (nonatomic, strong) NSString *currentChapterTitle;
@property (nonatomic, assign) CMTime currentPlaybackTime;

+ (instancetype)sharedData;
- (instancetype)init;
- (void)createTables;
- (void)dropTables;
- (NSArray *)users;
- (NSArray *)chapters;
- (NSArray *)journals;
- (User *)currentUser;
- (Chapter *)currentChapter;
- (NSArray *)userWithId:(NSString *)userId;
- (NSArray *)chapterWithTitle:(NSString *)chapterTitle;
- (NSArray *)journalWithCurrentUser;
- (NSArray *)journalWithCurrentChapter;
- (NSArray *)journalWithCurrentUserAndChapter;
- (NSArray *)journalWithId:(NSUInteger)journalId;
- (NSArray *)journalWithUserId:(NSString *)userId;
- (NSArray *)journalWithChapterTitle:(NSString *)chapterTitle;
- (NSArray *)journalWithUserId:(NSString *)userId chapterTitle:(NSString *)chapterTitle;
- (void)setUserWithId:(NSString *)userId password:(NSString *)password;
- (void)setChapterWithTitle:(NSString *)chapterTitle chapterText:(NSString *)chapterText videoUrl:(NSString *)videoUrl;
- (void)setJournalWithUserId:(NSString *)userId chapterTitle:(NSString *)chapterTitle comment:(NSString *)comment date:(NSDate *)date;

@end
