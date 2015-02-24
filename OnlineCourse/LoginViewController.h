//
//  LoginViewController.h
//  OnlineCourse
//
//  Created by Merritt Tidwell on 2/23/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

-(IBAction)loginPressed:(id)sender;

@end
