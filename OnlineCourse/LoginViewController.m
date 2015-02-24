//
//  LoginViewController.m
//  OnlineCourse
//
//  Created by Merritt Tidwell on 2/23/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "LoginViewController.h"
#import "SplitViewController.h"
#import "User.h"
#import "DBModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    NSString *user;
    NSString *pass;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginPressed:(id)sender {
    BOOL passValidated = NO;
    user = _username.text;
    pass = _password.text;
    
    DBModel *database = [[DBModel alloc] init];
    NSArray *users = [database userWithId:user];
    
    if (!passValidated) {
        for (User *obj in users) {
            if ([pass isEqualToString:obj.password]) {
                passValidated = YES;
                [self loginSuccessfully];
                [database setCurrentUser:user];
                return;
            }
        }
    }
    [self loginFailed];
    
    
}

-(void)loginFailed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Please login again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

    
}

-(void)loginSuccessfully {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Completed" message:@"Welcome to Software merchant online course!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self performSegueWithIdentifier:@"JumpToSplitView" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Set SplitViewController's delegate to AppDelegate and show leftBarButtonItem
    UISplitViewController *splitViewController = (UISplitViewController *)[segue destinationViewController];
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = (id <UISplitViewControllerDelegate>)[[UIApplication sharedApplication] delegate];
}



@end
