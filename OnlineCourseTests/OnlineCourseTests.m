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

@implementation OnlineCourseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*- (void)testRebuildDB {
    DBModel *database = [[DBModel alloc] init];
    [database dropTables];
    [database createTables];
}*/

- (void)testDatabase {
    
    DBModel *database = [[DBModel alloc] init];
    /*[database insertIntoUser:@"Di" password:@"di"];
    [database insertIntoChapter:@"Chapter 1" chapterText:@"Some text" videoUrl:@"http://localhost/~dk/chapter1.m3u8"];
    [database insertIntoJournal:@"Di" chapterTitle:@"Chapter 1" comment:@"This is junk" date:[NSDate date]];*/
    
    NSDictionary *dict = [database journal:1];
    for (NSString *key in [dict allKeys]) {
        NSLog(@"key = %@, value = %@", key, dict[key]);
    }
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
