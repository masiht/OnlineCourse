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
    "  DATE        TEXT NOT NULL"
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
- (void)insertIntoUser {}

- (void)insertIntoChapter {}

- (void)insertIntoJournal {}

- (NSDictionary *)getUser {

    NSString *userQuery = @"SELECT * FROM USER;";
    NSDictionary *returnDict = nil;
    sqlite3_stmt *statement;
    int result = sqlite3_open([dbPath UTF8String], &db);
    [self checkError:result withMessage:@"Failed to open database."];
    result = sqlite3_prepare_v2(db, [userQuery UTF8String], -1, &statement, nil);
    [self checkError:result withMessage:@"Error retrieving data."];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        NSString *password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        returnDict = @{@"UserId" : userId, @"Password" : password};
        NSLog(@"%@", returnDict);
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return returnDict;
}

- (NSDictionary *)getChapter {return nil;}

- (NSDictionary *)getJournal {return nil;}

@end
