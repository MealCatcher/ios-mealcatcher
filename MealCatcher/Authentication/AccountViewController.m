//
//  SignupViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/25/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "AccountViewController.h"

//TODO: Need to handle error conditions
@interface AccountViewController()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation AccountViewController

/* This is code that can be used later for the linking of a Facebook account in signup */
//TODO: facebookLink method needs to be removed from here
-(IBAction)facebookLink:(id)sender
{
    //Loggin in the existing user first
    [PFUser logInWithUsernameInBackground:@"jeastorga@gmail.com" password:@"12345" block:^(PFUser *user, NSError *error) {
        if(user)
        {
            NSLog(@"Linking in the user");
            if(![PFFacebookUtils isLinkedWithUser:user])
            {
                NSLog(@"user is not linked with facebook");
                [PFFacebookUtils linkUser:user permissions:nil block:^(BOOL succeeded, NSError *error) {
                    if(succeeded)
                    {
                        NSLog(@"The user is now linked");
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
        }
        else
        {
            //login failed. Check error to see why.
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorAlert show];
        }
    }];
    
    
}

/* Method used to authenticate (signup/sign in) with Facebook in MealCatcher */
- (IBAction)facebookAuthenticate:(id)sender {
    
    [PFFacebookUtils logInWithPermissions:@[@"email"] block:^(PFUser *user, NSError *error) {
        
        //user canceled the login/signup with Facebook
        if(!user)
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
        else if(user.isNew) //If user with FacebookID is not in the MealCatcher system
        {
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error)
                {
                    user.username = result[@"email"];
                    user.email = result[@"email"];
                    NSString *name = result[@"name"];
                    [user setObject:name forKey:@"name"];

                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded)
                        {
                            NSLog(@"The user data was saved succesfully");
                        }
                    }];
                }
            }];
        }
        else
        {
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
    
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser)
    {
    }
    else
    {
        NSLog(@"The user is not alive!");
    }
}


@end
