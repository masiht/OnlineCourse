//
//  OnlineCourseTests.m
//  OnlineCourseTests
//
//  Created by Masih Tabrizi on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DBModel.h"

@interface OnlineCourseTests : XCTestCase

@end

@implementation OnlineCourseTests {
    DBModel *database;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    database = [[DBModel alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRebuildDB {
    [database dropTables];
    [database createTables];
    
    [database setUserWithId:@"Di" password:@"di"];
    [database setUserWithId:@"Masih" password:@"masih"];
    [database setUserWithId:@"Merritt" password:@"merritt"];
    
    [database setChapterWithTitle:@"Chapter 0" chapterText:@"This chapter is very boring" videoUrl:@"http://192.168.1.12/~dk/CH00/SECTION_1/prog_index.m3u8"];
    [database setChapterWithTitle:@"Chapter 1" chapterText:@"This chapter is somewhat boring" videoUrl:@"http://192.168.1.12/~dk/CH01/SECTION_1/prog_index.m3u8"];
    [database setChapterWithTitle:@"Chapter 2" chapterText:@"This chapter is extremely boring" videoUrl:@"http://192.168.1.12/~dk/CH02/SECTION_1/prog_index.m3u8"];
    
    [database setJournalWithUserId:@"Di" chapterTitle:@"Chapter 1" comment:@"WTH did I just read" date:[NSDate dateWithTimeIntervalSince1970:1424361502]];
    [database setJournalWithUserId:@"Di" chapterTitle:@"Chapter 2" comment:@"I did not understand a thing" date:[NSDate dateWithTimeIntervalSince1970:1424376502]];
    [database setJournalWithUserId:@"Masih" chapterTitle:@"Chapter 1" comment:@"Is this really chapter 1?" date:[NSDate dateWithTimeIntervalSince1970:1424373863]];
    [database setJournalWithUserId:@"Merritt" chapterTitle:@"Chapter 3" comment:@"Where is chapter 1?" date:[NSDate dateWithTimeIntervalSince1970:1424291939]];
    
}

/*- (void)testDatabase {
    
    DBModel *database = [[DBModel alloc] init];
    NSLog(@"%@", [database journals]);
    
}*/

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
