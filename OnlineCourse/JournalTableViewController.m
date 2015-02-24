//
//  JournalTableViewController.m
//  OnlineCourse
//
//  Created by Di Kong on 2/23/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "JournalTableViewController.h"
#import "DetailViewController.h"
#import "Database.h"
#import "User.h"
#import "Chapter.h"
#import "Journal.h"

@interface JournalTableViewController ()

@property (nonatomic, strong) NSArray *journalList;

@end

@implementation JournalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@'s Journal", [Database sharedData].currentUserId];
    [self showAllJournal:nil];
}

- (void)viewWillDisappear:(BOOL)animated {

    self.parentView.willPause = YES;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAllJournal:(UIBarButtonItem *)sender {
    
    self.journalList = [[Database sharedData] journalWithCurrentUser];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Current Chapter" style:UIBarButtonItemStylePlain target:self action:@selector(showCurrentChapter:)];
}

- (IBAction)showCurrentChapter:(UIBarButtonItem *)sender {

    self.journalList = [[Database sharedData] journalWithCurrentUserAndChapter];
    if (self.journalList) {
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"All Chapters" style:UIBarButtonItemStylePlain target:self action:@selector(showAllJournal:)];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No chapter loaded!"
                                                                       message:@"Please select a chapter from the list"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        [alert addAction:dismissAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.journalList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Journal *journal = self.journalList[indexPath.row];
    UITextField *chapterField = (UITextField *)[cell viewWithTag:1];
    UITextField *dateField = (UITextField *)[cell viewWithTag:2];
    UITextField *commentField = (UITextField *)[cell viewWithTag:3];
    chapterField.text = journal.chapterTitle;
    dateField.text = journal.date;
    commentField.text = journal.comment;
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DetailViewController *dest = [segue destinationViewController];
    dest.willPause = YES;
}


@end
