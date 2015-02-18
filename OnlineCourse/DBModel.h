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
- (void)insertIntoUser;
- (NSDictionary *)getUser;
- (void)insertIntoChapter;
- (NSDictionary *)getChapter;
- (void)insertIntoJournal;
- (NSDictionary *)getJournal;

@end
