//
//  DBModel.h
//  OnlineCourse
//
//  Created by Di Kong on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface DBModel : NSObject {
    sqlite3 *db;
    NSString *dbPath;
}

- (instancetype)init;
- (void)createTables;
- (void)dropTables;
/*- (NSString *)currentUser;
- (void)removeCurrentUser;*/
- (NSArray *)users;
- (NSArray *)chapters;
- (NSArray *)journals;
- (NSArray *)userWithId:(NSString *)userId;
- (NSArray *)chapterWithTitle:(NSString *)chapterTitle;
- (NSArray *)journalWitId:(NSUInteger)journalId;
- (NSArray *)journalWithUserId:(NSString *)userId;
- (NSArray *)journalWithChapterTitle:(NSString *)chapterTitle;
- (NSArray *)journalWithUserId:(NSString *)userId chapterTitle:(NSString *)chapterTitle;
- (void)setCurrentUser:(NSString *)userId;
- (void)setUserWithId:(NSString *)userId password:(NSString *)password;
- (void)setChapterWithTitle:(NSString *)chapterTitle chapterText:(NSString *)chapterText videoUrl:(NSString *)videoUrl;
- (void)setJournalWithUserId:(NSString *)userId chapterTitle:(NSString *)chapterTitle comment:(NSString *)comment date:(NSDate *)date;

@end
