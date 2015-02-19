//
//  DBModel.m
//  OnlineCourse
//
//  Created by Di Kong on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "DBModel.h"

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
    "  CHAPTER_ID     INTEGER PRIMARY KEY AUTOINCREMENT,"
    "  CHAPTER_TITLE  TEXT NOT NULL,"
    "  VIDEO_URL      TEXT NOT NULL,"
    "  CHAPTER_TEXT   TEXT"
    ");"
    "CREATE TABLE IF NOT EXISTS JOURNAL ("
    "  JOURNAL_ID  INTEGER PRIMARY KEY AUTOINCREMENT,"
    "  USER_ID     TEXT REFERENCES USER ON DELETE CASCADE,"
    "  CHAPTER_ID  INTEGER REFERENCES CHAPTER ON DELETE CASCADE,"
    "  COMMENT     TEXT NOT NULL,"
    "  DATE        INTEGER"
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


/* TODO: implement sqlite insert/update and select methods */
- (void)insertIntoUser:(NSString *)userId password:(NSString *)password {
    
    NSString *updateQuery = @"INSERT OR REPLACE INTO USER (USER_ID, PASSWORD) VALUES (?, ?);";
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(db, [updateQuery UTF8String], -1, &statement, nil);
    [self checkError:result withMessage:@"Error preparing for query."];
    
    char *errorMsg = NULL;
    sqlite3_bind_text(statement, 1, [userId UTF8String], -1, NULL);
    sqlite3_bind_text(statement, 2, [password UTF8String], -1, NULL);
    
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSAssert(0, @"Error updating table: %s", errorMsg);
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

- (void)insertIntoChapter {}

- (void)insertIntoJournal {}

- (NSArray *)execSelect:(NSString *)query columnCount:(NSUInteger)count {

    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    
    sqlite3_stmt *statement;
    /*NSString *pragmaQuery = @"PRAGMA TABLE_INFO()"*/
    
    result = sqlite3_prepare_v2(db, [query UTF8String], -1, &statement, nil);
    [self checkError:result withMessage:[NSString stringWithFormat:@"Error preparing for query: %@", query]];
    
    NSMutableArray *retArr = [NSMutableArray arrayWithCapacity:count];
    int p = sqlite3_step(statement);
    while (p == SQLITE_ROW) {
        for (int i = 0; i < count; i ++) {
            retArr[i] = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
        }
        p = sqlite3_step(statement);
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    if (retArr.count == 0)
        return nil;
    return [NSArray arrayWithArray:retArr];
}

- (NSDictionary *)user:(NSString *)userId {
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM USER WHERE USER_ID = '%@';", userId];
    NSArray *keyArr = @[@"userId", @"password"];
    NSArray *valArr = [self execSelect:selectQuery columnCount:2];
    if (valArr == nil)
        return nil;

    return [NSDictionary dictionaryWithObjects:valArr forKeys:keyArr];
}

- (NSDictionary *)chapter:(NSUInteger)chapterId {
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM CHAPTER WHERE CHAPTER_ID = %lu;", chapterId];
    NSArray *keyArr = @[@"chapterId", @"chapterTitle", @"videoUrl", @"chapterText"];
    NSArray *valArr = [self execSelect:selectQuery columnCount:4];
    if (valArr == nil)
        return nil;
    
    return [NSDictionary dictionaryWithObjects:valArr forKeys:keyArr];
}

- (NSDictionary *)journal:(NSUInteger)journalId {
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM JOURNAL WHERE JOURNAL_ID = %lu;", journalId];
    NSArray *keyArr = @[@"journalId", @"userId", @"chapterId", @"comment", @"date"];
    NSArray *valArr = [self execSelect:selectQuery columnCount:5];
    if (valArr == nil)
        return nil;
    
    return [NSDictionary dictionaryWithObjects:valArr forKeys:keyArr];
}

@end
