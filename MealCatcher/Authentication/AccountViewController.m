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
@property (weak, nonatomic) IBOutlet UIButton *loginFBButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) BOOL loginSuccessful;

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
- (void)facebookAuthenticate {
    
    [PFFacebookUtils logInWithPermissions:@[@"email,user_checkins"] block:^(PFUser *user, NSError *error) {
        
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
        else if(user.isNew) //If user with FacebookID is not in the MealCatcher system, create the user
        {
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error)
                {
                    user.username = result[@"email"];
                    user.email = result[@"email"];
                    NSString *name = result[@"name"];
                    [user setObject:name forKey:@"name"];
                    [user setObject:result[@"id"] forKey:@"fbId"]; //save the FBId to query later

                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded)
                        {
                            //register for push notifications
                            [self registerPushNotifications];
                            
                            self.loginSuccessful = YES;
                            [self performSegueWithIdentifier:@"testUnwind" sender:self];
                        }
                    }];
                }
            }];
            
            self.loginSuccessful = YES;
            [self performSegueWithIdentifier:@"testUnwind" sender:self];
            
            /*** GET USER CHECKINS ***/
            [self getUserCheckins];
        }
        else //the user exists, just login the user
        {
            //register for push notifications
            [self registerPushNotifications];
            
            self.loginSuccessful = YES;
            [self performSegueWithIdentifier:@"testUnwind" sender:self];
            
            /*** GET USER CHECKINS ***/
            [self getUserCheckins];
        }
    }];
}


/****** THIS IS A METHOD TO GET FACEBOOK CHECKINS FOR THE USER ******/
- (void)getUserCheckins
{

    NSLog(@"Getting user checkins!!!");
    
    [FBRequestConnection startWithGraphPath:@"/me/checkins"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error)
        {
            //NSLog(@"Got the user checkins");
            NSDictionary *checkinsResults = (NSDictionary *)result;
           id data = [checkinsResults objectForKey:@"data"];
            
            for (id specificPlace  in checkinsResults) {
                NSDictionary *placeDictionary = (NSDictionary *)specificPlace;
                NSLog(@"The Place: %@", placeDictionary);
                
            }
            
            if([data isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"The place is a dictionary");
            }
            else if ([data isKindOfClass:[NSArray class]])
            {
                NSLog(@"The place is an array");
                NSLog(@"Data: %@", data);
                //NSLog(@"Data Count: %d", [data count]);
                for (id eachPlace in data) {
                    //NSLog(@"Each Place: %@", eachPlace);
                    if([eachPlace isKindOfClass:[NSDictionary class]])
                    {
                       // NSLog(@"The eachPlace is a dictionary");
                        NSDictionary* placeData = (NSDictionary *)[eachPlace objectForKey:@"place"];
                        if([placeData isKindOfClass:[NSDictionary class]])
                        {
                         //   NSLog(@"placeData is a Dictionary");
                           // NSLog(@"placeData: %@", placeData);
                            NSDictionary *finalPlace = (NSDictionary *)placeData;
                            NSLog(@"Place Name: %@", [finalPlace objectForKey:@"name"]);
                        }
                    }
                }
            }
        }
    }];
}


//This method registers the user for push notifications when the user logs in or signs up
-(void)registerPushNotifications
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
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

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([sender isEqual:self.cancelButton]) //use canceled login
    {
        return YES;
    }
    else
    {
        [self facebookAuthenticate];
        return self.loginSuccessful;
    }
    
}


@end
