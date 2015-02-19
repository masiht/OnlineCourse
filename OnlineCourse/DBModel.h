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

@class User;
@class Chapter;
@class Journal;

@interface DBModel : NSObject {
    sqlite3 *db;
    NSString *dbPath;
}

/*@property(nonatomic, strong) NSString *errMsg;*/

- (instancetype)init;
- (void)createTables;
- (void)dropTables;
- (void)setUserWithId:(NSString *)userId password:(NSString *)password;
- (User *)user:(NSString *)userId;
- (void)setChapterWithTitle:(NSString *)chapterTitle chapterText:(NSString *)chapterText videoUrl:(NSString *)videoUrl;
- (Chapter *)chapter:(NSString *)chapterTitle;
- (void)setJournalWithUserId:(NSString *)userId chapterTitle:(NSString *)chapterTitle comment:(NSString *)comment date:(NSDate *)date;
- (Journal *)journal:(NSUInteger)journalId;

@end
