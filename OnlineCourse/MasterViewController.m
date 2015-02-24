//
//  MasterViewController.m
//  OnlineCourse
//
//  Created by Masih Tabrizi on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "DBModel.h"
#import "Chapter.h"
#import "CurrentData.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *chapterList;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {

    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    // Load chapter list
    DBModel *database = [[DBModel alloc] init];
    self.chapterList = [database chapters];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.204f green:0.282f blue:0.369f alpha:1.0f];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Chapter *chapter = self.chapterList[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setChapterTitle:chapter.chapterTitle];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chapterList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Chapter *chapter = self.chapterList[indexPath.row];
    cell.textLabel.text = chapter.chapterTitle;
    cell.textLabel.font = [UIFont fontWithName:@"Kailasa" size:22];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:0.204f green:0.282f blue:0.369f alpha:1.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Chapter *selectedChapter = self.chapterList[indexPath.row];
    [CurrentData sharedData].chapterTitle = selectedChapter.chapterTitle;
}

@end
