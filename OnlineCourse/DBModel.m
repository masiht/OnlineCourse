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
    }
    return self;
}

/* Checks the result of sql command, close db and assert failure if no SQLITE_OK */
- (void)checkOk:(int)result withMessage:(NSString *)errorMsg {

    if (result != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, errorMsg);
    }
}

/* Checks the result of sql command, close db and assert failure if no SQLITE_OK */
- (void)checkDone:(int)result withMessage:(NSString *)errorMsg {
    
    if (result != SQLITE_DONE) {
        sqlite3_close(db);
        NSAssert(0, errorMsg);
    }
}

/* DDL for creating three tables */
- (void)createTables {

    char *errorMsg;
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    NSString *createQuery =
    @"CREATE TABLE IF NOT EXISTS CURRENT_USER ("
    "  CURRENT_USER  TEXT PRIMARY KEY"
    ");"
    "CREATE TABLE IF NOT EXISTS USER ("
    "  USER_ID   TEXT PRIMARY KEY,"
    "  PASSWORD  TEXT NOT NULL"
    ");"
    "CREATE TABLE IF NOT EXISTS CHAPTER ("
    "  CHAPTER_TITLE  TEXT PRIMARY KEY,"
    "  CHAPTER_TEXT   TEXT,"
    "  VIDEO_URL      TEXT NOT NULL"
    ");"
    "CREATE TABLE IF NOT EXISTS JOURNAL ("
    "  JOURNAL_ID     INTEGER PRIMARY KEY AUTOINCREMENT,"
    "  USER_ID        TEXT REFERENCES USER ON DELETE CASCADE,"
    "  CHAPTER_TITLE  TEXT REFERENCES CHAPTER ON DELETE CASCADE,"
    "  COMMENT        TEXT NOT NULL,"
    "  DATE           INTEGER"
    ");";
    
    result = sqlite3_exec(db, [createQuery UTF8String], NULL, NULL, &errorMsg);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error creating table: %s.", errorMsg]];
    
    sqlite3_close(db);
}

/* DDL for dropping all tables */
- (void)dropTables {
    
    char *errorMsg;
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    NSString *dropQuery = @"DROP TABLE JOURNAL; DROP TABLE CHAPTER; DROP TABLE USER;";
    result = sqlite3_exec(db, [dropQuery UTF8String], NULL, NULL, &errorMsg);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error dropping table: %s.", errorMsg]];
    
    sqlite3_close(db);
}

/* Get current logged in user */
- (NSString *)currentUser {

    NSString *selectQuery = @"SELECT * FROM CURRENT_USER;";
    
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    // Retrieve data
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [selectQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", selectQuery]];
    
    NSString *currentUser;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        currentUser = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return currentUser;
}

/* Log out */
- (void)removeCurrentUser {

    NSString *deleteQuery = @"DELETE FROM CURRENT_USER;";
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [deleteQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", deleteQuery]];
    
    char *errorMsg = NULL;
    result = sqlite3_step(statement);
    [self checkDone:result withMessage:[NSString stringWithFormat:@"Error updating table: %s", errorMsg]];
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

/* Returns a complete user list */
- (NSArray *)users {

    return [self userWithColumn:nil equalToValue:nil];
}

/* Returns a complete chapter list */
- (NSArray *)chapters {

    return [self chapterWithColumn:nil equalToValue:nil];
}

/* Returns a complete journal list */
- (NSArray *)journals {

    return [self journalWithColumn:nil equalToValue:nil];
}

/* Returns one or zero user with given id */
- (NSArray *)userWithId:(NSString *)userId {
    
    return [self userWithColumn:@"USER_ID" equalToValue:userId];
}

/* Returns one or zero chapter with given title */
- (NSArray *)chapterWithTitle:(NSString *)chapterTitle {
    
    return [self chapterWithColumn:@"CHAPTER_TITLE" equalToValue:chapterTitle];
}

/* Returns one or zero journal with given id */
- (NSArray *)journalWitId:(NSUInteger)journalId {
    
    return [self journalWithColumn:@"JOURNAL_ID" equalToValue:@(journalId)];
}

/* Returns a list of journals associated with the user */
- (NSArray *)journalWithUserId:(NSString *)userId {
    
    return [self journalWithColumn:@"USER_ID" equalToValue:userId];
}

/* Returns a list of journals associated with the chapter */
- (NSArray *)journalWithChapterTitle:(NSString *)chapterTitle {

    return [self journalWithColumn:@"CHAPTER_TITLE" equalToValue:chapterTitle];
}

/* Returns a list of journals associated with the user and chapter */
- (NSArray *)journalWithUserId:(NSString *)userId chapterTitle:(NSString *)chapterTitle {
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM JOURNAL WHERE USER_ID = '%@' AND CHAPTER_TITLE = '%@';", userId, chapterTitle];
    
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    // Retrieve data
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [selectQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", selectQuery]];
    
    NSMutableArray *journalList = [NSMutableArray array];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSUInteger journalId = sqlite3_column_int(statement, 0);
        NSString *userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        NSString *chapterTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2) ];
        NSString *comment = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3) ];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 4)];
        Journal *j = [[Journal alloc] initWithJournalId:journalId userId:userId chapterTitle:chapterTitle comment:comment date:date];
        [journalList addObject:j];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return [NSArray arrayWithArray:journalList];
}

/* Set current user */
- (void)setCurrentUser:(NSString *)userId {
    
    NSString *updateQuery = @"INSERT OR REPLACE INTO CURRENT_USER (CURRENT_USER) VALUES (?);";
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [updateQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", updateQuery]];
    
    char *errorMsg = NULL;
    sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
    
    result = sqlite3_step(statement);
    [self checkDone:result withMessage:[NSString stringWithFormat:@"Error updating table: %s", errorMsg]];
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

/* Insert user, or update if exists */
- (void)setUserWithId:(NSString *)userId password:(NSString *)password {
    
    NSString *updateQuery = @"INSERT OR REPLACE INTO USER (USER_ID, PASSWORD) VALUES (?, ?);";
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [updateQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", updateQuery]];
    
    char *errorMsg = NULL;
    sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
    sqlite3_bind_text(statement, 2, [password UTF8String], -1, nil);
    
    result = sqlite3_step(statement);
    [self checkDone:result withMessage:[NSString stringWithFormat:@"Error updating table: %s", errorMsg]];
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

/* Insert chapter, or update if exists */
- (void)setChapterWithTitle:(NSString *)chapterTitle chapterText:(NSString *)chapterText videoUrl:(NSString *)videoUrl {

    NSString *updateQuery = @"INSERT OR REPLACE INTO CHAPTER (CHAPTER_TITLE, CHAPTER_TEXT, VIDEO_URL) VALUES (?, ?, ?);";
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [updateQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", updateQuery]];
    
    char *errorMsg = NULL;
    sqlite3_bind_text(statement, 1, [chapterTitle UTF8String], -1, nil);
    sqlite3_bind_text(statement, 2, [chapterText UTF8String], -1, nil);
    sqlite3_bind_text(statement, 3, [videoUrl UTF8String], -1, nil);
    
    result = sqlite3_step(statement);
    [self checkDone:result withMessage:[NSString stringWithFormat:@"Error updating table: %s", errorMsg]];
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

/* Insert journal, or update if exists */
- (void)setJournalWithUserId:(NSString *)userId chapterTitle:(NSString *)chapterTitle comment:(NSString *)comment date:(NSDate *)date {
    
    NSString *updateQuery = @"INSERT OR REPLACE INTO JOURNAL (USER_ID, CHAPTER_TITLE, COMMENT, DATE) VALUES (?, ?, ?, ?);";
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [updateQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", updateQuery]];
    
    char *errorMsg = NULL;
    sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
    sqlite3_bind_text(statement, 2, [chapterTitle UTF8String], -1, nil);
    sqlite3_bind_text(statement, 3, [comment UTF8String], -1, nil);
    sqlite3_bind_int(statement, 4, [date timeIntervalSince1970]);
    
    result = sqlite3_step(statement);
    [self checkDone:result withMessage:[NSString stringWithFormat:@"Error updating table: %s", errorMsg]];
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

/* Helper method to return a list of users that satisfies 'WHERE columnName = value' */
- (NSArray *)userWithColumn:(NSString *)columnName equalToValue:(id)value {

    NSString *selectQuery = @"SELECT * FROM USER";
    if (value && columnName)
        selectQuery = [selectQuery stringByAppendingFormat:@" WHERE %@ = '%@';", columnName, value];
    else
        selectQuery = [selectQuery stringByAppendingString:@";"];
    
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    // Retrieve data
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [selectQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", selectQuery]];
    
    NSMutableArray *userList = [NSMutableArray array];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        NSString *password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        User *u = [[User alloc] initWithUserId:userId password:password];
        [userList addObject:u];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return [NSArray arrayWithArray:userList];
}

/* Helper method to return a list of chapters that satisfies 'WHERE columnName = value' */
- (NSArray *)chapterWithColumn:(NSString *)columnName equalToValue:(id)value {
    
    NSString *selectQuery = @"SELECT * FROM CHAPTER";
    if (value && columnName)
        selectQuery = [selectQuery stringByAppendingFormat:@" WHERE %@ = '%@';", columnName, value];
    else
        selectQuery = [selectQuery stringByAppendingString:@";"];
    
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    // Retrieve data
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [selectQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", selectQuery]];
    
    NSMutableArray *chapterList = [NSMutableArray array];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *chapterTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        NSString *chapterText = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        NSString *videoUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        Chapter *c = [[Chapter alloc] initWithChapterTitle:chapterTitle chapterText:chapterText videoUrl:videoUrl];
        [chapterList addObject:c];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return [NSArray arrayWithArray:chapterList];
}

/* Helper method to return a list of journals that satisfies 'WHERE columnName = value' */
- (NSArray *)journalWithColumn:(NSString *)columnName equalToValue:(id)value {
    
    NSString *selectQuery = @"SELECT * FROM JOURNAL";
    if (value && columnName)
        selectQuery = [selectQuery stringByAppendingFormat:@" WHERE %@ = '%@';", columnName, value];
    else
        selectQuery = [selectQuery stringByAppendingString:@";"];
    
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkOk:result withMessage:@"Failed to open database."];
    
    // Retrieve data
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [selectQuery UTF8String], -1, &statement, nil);
    [self checkOk:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", selectQuery]];
    
    NSMutableArray *journalList = [NSMutableArray array];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSUInteger journalId = sqlite3_column_int(statement, 0);
        NSString *userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        NSString *chapterTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2) ];
        NSString *comment = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3) ];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 4)];
        Journal *j = [[Journal alloc] initWithJournalId:journalId userId:userId chapterTitle:chapterTitle comment:comment date:date];
        [journalList addObject:j];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return [NSArray arrayWithArray:journalList];
}

@end
