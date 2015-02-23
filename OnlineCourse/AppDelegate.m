//
//  AppDelegate.m
//  OnlineCourse
//
//  Created by Masih Tabrizi on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "DBModel.h"
#import "LoginViewController.h"
@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

/* Initialize database and populate data */
- (void)constructDB {

    DBModel *database = [[DBModel alloc] init];
    /*[database dropTables];*/
    [database createTables];
    
    [database removeCurrentUser];
    
    [database setUserWithId:@"Di" password:@"di"];
    [database setUserWithId:@"Masih" password:@"masih"];
    [database setUserWithId:@"Merritt" password:@"merritt"];
    
    [database setChapterWithTitle:@"Chapter 0 Section 1" chapterText:@"" videoUrl:@"http://www.softwaremerchant.com/stream/CH00/SECTION_1/prog_index.m3u8"];
    [database setChapterWithTitle:@"Chapter 0 Section 2" chapterText:@"" videoUrl:@"http://www.softwaremerchant.com/stream/CH00/SECTION_2/prog_index.m3u8"];
    [database setChapterWithTitle:@"Chapter 0 Section 3" chapterText:@"" videoUrl:@"http://www.softwaremerchant.com/stream/CH00/SECTION_3/prog_index.m3u8"];
    [database setChapterWithTitle:@"Chapter 1 Section 1" chapterText:@"" videoUrl:@"http://www.softwaremerchant.com/stream/CH01/SECTION_1/prog_index.m3u8"];
    [database setChapterWithTitle:@"Chapter 2 Section 1" chapterText:@"" videoUrl:@"http://www.softwaremerchant.com/stream/CH02/SECTION_1/prog_index.m3u8"];
    [database setChapterWithTitle:@"Chapter 2 Section 2" chapterText:@"" videoUrl:@"http://www.softwaremerchant.com/stream/CH02/SECTION_2/prog_index.m3u8"];
    [database setChapterWithTitle:@"Chapter 2 Section 3" chapterText:@"" videoUrl:@"http://www.softwaremerchant.com/stream/CH02/SECTION_3/prog_index.m3u8"];
    
    /*[database setJournalWithUserId:@"Di" chapterTitle:@"Chapter 0 Section 1" comment:@"WTH did I just read" date:[NSDate dateWithTimeIntervalSince1970:1424361502]];
    [database setJournalWithUserId:@"Di" chapterTitle:@"Chapter 0 Section 2" comment:@"I did not understand a thing" date:[NSDate dateWithTimeIntervalSince1970:1424376502]];
    [database setJournalWithUserId:@"Masih" chapterTitle:@"Chapter 1 Section 1" comment:@"Is this really chapter 1?" date:[NSDate dateWithTimeIntervalSince1970:1424373863]];
    [database setJournalWithUserId:@"Merritt" chapterTitle:@"Chapter 2 Section 3" comment:@"Where is chapter 1?" date:[NSDate dateWithTimeIntervalSince1970:1424291939]];*/
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self constructDB];
    
    
//    BOOL isLoggedIn;
//    
//    if  (isLoggedIn == YES){
    
        LoginViewController *controller = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"login"];
        
        self.window.rootViewController = controller;

    
    

    
//    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
//    splitViewController.delegate = self;
   return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] chapterTitle] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
