//
//  SplitViewController.m
//  OnlineCourse
//
//  Created by Masih Tabrizi on 2/19/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//


#import "SplitViewController.h"

@interface SplitViewController ()

@end

@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self presentAlertView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Alert View Methods
//
//-(void)presentAlertView {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Please enter your username and password:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
//    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//    UITextField *username = [alert textFieldAtIndex:0];
//    UITextField *password = [alert textFieldAtIndex:1];
//    username.placeholder = @"Enter Username";
//    password.placeholder = @"Enter Password";
//    [alert show];
//    
//}
//
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        NSLog(@"User: %@",[alertView textFieldAtIndex:0].text);
//        NSLog(@"Pass:%@",[alertView textFieldAtIndex:1].text);
//    } else { 
//        NSLog(@"Continue as a guest");
//    }
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

