//
//  SignupViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/25/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "SignupViewController.h"


@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end

@implementation SignupViewController

- (IBAction)cancelSignup:(id)sender {
    
}

- (IBAction)regularSignup:(id)sender {
    PFUser *user = [PFUser user];
    //user.username = @"chuchosabe";
    user.username = self.emailField.text;
    //user.password = @"12345";
    user.password = self.passwordField.text;
    //user.email = @"email@example.com";
    user.email = self.emailField.text;
    
    
    //other fields can be set just like with PFObject
    [user setObject:@"415-392-0202" forKey:@"phone"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error)
        {
            NSLog(@"The user signed up successfully");
        }
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error String: %@", errorString);
            
            //Display an alert view with a proper error message
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:errorString
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
            
            [theAlert show];
        }
    }];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


@end
