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

/*@property(nonatomic, strong) NSString *errMsg;*/

- (instancetype)init;
- (void)createTables;
- (void)dropTables;
- (void)setUserWithId:(NSString *)userId password:(NSString *)password;
- (NSDictionary *)user:(NSString *)userId;
- (void)setChapterWithTitle:(NSString *)chapterTitle chapterText:(NSString *)chapterText videoUrl:(NSString *)videoUrl;
- (NSDictionary *)chapter:(NSString *)chapterTitle;
- (void)setJournalWithUserId:(NSString *)userId chapterTitle:(NSString *)chapterTitle comment:(NSString *)comment date:(NSDate *)date;
- (NSDictionary *)journal:(NSUInteger)journalId;

@end
