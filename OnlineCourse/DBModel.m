//
//  DBModel.m
//  OnlineCourse
//
//  Created by Di Kong on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "DBModel.h"
#import "User.h"
#import "Chapter.h"
#import "Journal.h"

@implementation DBModel

/* Init method */
- (instancetype)init {

    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        dbPath = [documentsDirectory stringByAppendingPathComponent:@"db.sqlite"];
        NSLog(@"You may fing the database at \'%@\'", dbPath);
        /*self.errMsg = nil;*/
    }
    return self;
}

/* Checks the result of sql command, close db and assert failure if no SQLITE_OK */
- (void)checkError:(int)result withMessage:(NSString *)errorMsg {

    if (result != SQLITE_OK) {
        /*self.errMsg = errorMsg;*/
        sqlite3_close(db);
        NSAssert(0, errorMsg);
    }
}

/* DDL for creating three tables */
- (void)createTables {

    char *errorMsg;
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    NSString *createQuery =
    @"CREATE TABLE IF NOT EXISTS USER ("
    "  USER_ID   TEXT PRIMARY KEY,"
    "  PASSWORD  TEXT NOT NULL"
    ");"
    "CREATE TABLE IF NOT EXISTS CHAPTER ("
    "  CHAPTER_TITLE  TEXT PRIMARY KEY,"
    "  CHAPTER_TEXT   TEXT"
    "  VIDEO_URL      TEXT NOT NULL,"
    ");"
    "CREATE TABLE IF NOT EXISTS JOURNAL ("
    "  JOURNAL_ID     INTEGER PRIMARY KEY AUTOINCREMENT,"
    "  USER_ID        TEXT REFERENCES USER ON DELETE CASCADE,"
    "  CHAPTER_TITLE  TEXT REFERENCES CHAPTER ON DELETE CASCADE,"
    "  COMMENT        TEXT NOT NULL,"
    "  DATE           INTEGER"
    ");";
    
    result = sqlite3_exec(db, [createQuery UTF8String], NULL, NULL, &errorMsg);
    [self checkError:result withMessage:[NSString stringWithFormat:@"Error creating table: %s.", errorMsg]];
    
    sqlite3_close(db);
}

/* DDL for dropping all tables */
- (void)dropTables {
    
    char *errorMsg;
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    NSString *dropQuery = @"DROP TABLE JOURNAL; DROP TABLE CHAPTER; DROP TABLE USER;";
    result = sqlite3_exec(db, [dropQuery UTF8String], NULL, NULL, &errorMsg);
    [self checkError:result withMessage:[NSString stringWithFormat:@"Error dropping table: %s.", errorMsg]];
    
    sqlite3_close(db);
}

- (void)setUserWithId:(NSString *)userId password:(NSString *)password {
    
    NSString *updateQuery = @"INSERT OR REPLACE INTO USER (USER_ID, PASSWORD) VALUES (?, ?);";
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [updateQuery UTF8String], -1, &statement, nil);
    [self checkError:result withMessage:@"Error preparing for query."];
    
    char *errorMsg = NULL;
    sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
    sqlite3_bind_text(statement, 2, [password UTF8String], -1, nil);
    
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSAssert(0, @"Error updating table: %s", errorMsg);
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

- (void)setChapterWithTitle:(NSString *)chapterTitle chapterText:(NSString *)chapterText videoUrl:(NSString *)videoUrl {

    NSString *updateQuery = @"INSERT OR REPLACE INTO CHAPTER (CHAPTER_TITLE, CHAPTER_TEXT, VIDEO_URL) VALUES (?, ?, ?);";
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [updateQuery UTF8String], -1, &statement, nil);
    [self checkError:result withMessage:@"Error preparing for query."];
    
    char *errorMsg = NULL;
    sqlite3_bind_text(statement, 1, [chapterTitle UTF8String], -1, nil);
    sqlite3_bind_text(statement, 2, [chapterText UTF8String], -1, nil);
    sqlite3_bind_text(statement, 3, [videoUrl UTF8String], -1, nil);
    
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSAssert(0, @"Error updating table: %s", errorMsg);
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

- (void)setJournalWithUserId:(NSString *)userId chapterTitle:(NSString *)chapterTitle comment:(NSString *)comment date:(NSDate *)date {
    
    NSString *updateQuery = @"INSERT OR REPLACE INTO JOURNAL (USER_ID, CHAPTER_TITLE, COMMENT, DATE) VALUES (?, ?, ?, ?);";
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [updateQuery UTF8String], -1, &statement, nil);
    [self checkError:result withMessage:@"Error preparing for query."];
    
    char *errorMsg = NULL;
    sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
    sqlite3_bind_text(statement, 2, [chapterTitle UTF8String], -1, nil);
    sqlite3_bind_text(statement, 3, [comment UTF8String], -1, nil);
    sqlite3_bind_int(statement, 4, [date timeIntervalSince1970]);
    
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSAssert(0, @"Error updating table: %s", errorMsg);
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

- (User *)user:(NSString *)userId {
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM USER WHERE USER_ID = '%@';", userId];
    
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    // Retrieve data
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [selectQuery UTF8String], -1, &statement, nil);
    [self checkError:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", selectQuery]];
    
    User *user = nil;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        NSString *password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        user = [[User alloc] initWithUserId:userId password:password];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return user;
}

- (Chapter *)chapter:(NSString *)chapterTitle {
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM CHAPTER WHERE CHAPTER_TITLE = '%@';", chapterTitle];
    
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    // Retrieve data
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [selectQuery UTF8String], -1, &statement, nil);
    [self checkError:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", selectQuery]];
    
    Chapter *chapter = nil;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *chapterTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        NSString *chapterText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        NSString *videoUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        chapter = [[Chapter alloc] initWithChapterTitle:chapterTitle chapterText:chapterText videoUrl:videoUrl];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return chapter;
}

- (Journal *)journal:(NSUInteger)journalId {
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM JOURNAL WHERE JOURNAL_ID = %lu;", journalId];
    
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    // Retrieve data
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [selectQuery UTF8String], -1, &statement, nil);
    [self checkError:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", selectQuery]];
    
    Journal *journal = nil;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSUInteger journalId = sqlite3_column_int(statement, 0);
        NSString *userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        NSString *chapterTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2) ];
        NSString *comment = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3) ];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 4)];
        journal = [[Journal alloc] initWithJournalId:journalId userId:userId chapterTitle:chapterTitle comment:comment date:date];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return journal;
}


@end
