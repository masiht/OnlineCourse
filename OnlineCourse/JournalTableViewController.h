//
//  JournalTableViewController.h
//  OnlineCourse
//
//  Created by Di Kong on 2/23/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface JournalTableViewController : UITableViewController

@property (nonatomic, weak) DetailViewController *parentView;

- (IBAction)showAllJournal:(UIBarButtonItem *)sender;
- (IBAction)showCurrentChapter:(UIBarButtonItem *)sender;

@end
