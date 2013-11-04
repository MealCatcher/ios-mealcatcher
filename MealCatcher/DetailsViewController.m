//
//  NIBViewController.m
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 12/2/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "DetailsViewController.h"
#import "GooglePlacesAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Favorite.h"
#import <FacebookSDK/FBGraphUser.h>

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *placePhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;

@property (weak, nonatomic) IBOutlet UIButton *btnAddFavorites;
@property (weak, nonatomic) IBOutlet UIButton *btnRecommend;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

@end

@implementation DetailsViewController

#define GOOGLE_API_KEY @"AIzaSyBiDP9jVA2Tad-yvyEIm1gIi2umJRvYzUg"
#define FACEBOOK_SHARE_INDEX 0
#define PROXIMITY_SHARE_INDEX 1

#pragma mark FacebookFriendPicker Delegate Protocol
-(void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"Selection was made");
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {

    NSLog(@"Done button was pressed");
    
    for (id<FBGraphUser> user in self.friendPickerController.selection) //get the selected user(s)
    {
        NSLog(@"User's Facebook ID: %@", user[@"id"]);
        
        //determine if the Facebook friend is a MealCatcher user
        PFQuery *query = [PFUser query];
        [query whereKey:@"fbId" equalTo:user[@"id"]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d the user", objects.count);
                
                // Do something with the found objects
                for (PFObject *object in objects) {
                    NSLog(@"Object %@", object.objectId);
                    PFUser *recommendee = (PFUser *)object;
                    
                    PFObject *newRecommendation = [PFObject objectWithClassName:@"Recommendation"];
                    //newRecommendation[@"address"] = @"1234 Ocean Avenue";
                    newRecommendation[@"address"] = [self.myFavorite objectForKey:@"address"];
                    newRecommendation[@"rating"] = [self.myFavorite objectForKey:@"rating"];
                    newRecommendation[@"restaurant"] = [self.myFavorite objectForKey:@"restaurant"];
                    newRecommendation[@"restaurant_id"] = [self.myFavorite objectForKey:@"restaurant_id"];
                    
                    [newRecommendation setObject:recommendee forKey:@"parent"];
                    [newRecommendation setObject:[PFUser currentUser] forKey:@"recommender"];
                    
                    [newRecommendation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(!error)
                        {
                            NSLog(@"The new recommendation was saved successfully");
                        }
                        else
                        {
                            NSLog(@"There was a problem saving this succesfully");
                        }
                    }];
                    
                }
                
                
                
                //add the restaurant to the recommended list of your friend
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    
    [self dismissViewControllerAnimated:self.friendPickerController completion:^{
    }];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:self.friendPickerController completion:^{
    }];
}

#pragma mark Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Details";

    //if source vc is favorites, remove add to favorites button
    if([self.vcSource isEqualToString:FAVROITES_CONTROLLER])
    {
        self.btnAddFavorites.hidden = YES;
        self.btnRecommend.frame = CGRectMake(14, 494, 286, 54);
    }
    
    GooglePlacesAPIClient *gpClient = [GooglePlacesAPIClient sharedClient];
    
    if(!gpClient)
    {
        NSLog(@"Could not create the client");
    }
    else
    {
        //Setup the call parameters to Google Places API
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:GOOGLE_API_KEY,
                                    @"key",
                                    self.restaurantID,
                                    @"reference",
                                    @"false",
                                    @"sensor",
                                    nil];
        
        //Get the Google Place Details
        [gpClient getPath:@"details/json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *result = [responseObject objectForKey:@"result"];
            
            //populate the details view labels
            self.placeNameLabel.text = [result objectForKey:@"name"];
            self.placePhoneLabel.text = [result objectForKey:@"international_phone_number"];
            self.placeAddressLabel.text = [result objectForKey:@"formatted_address"];
            
            //Creat the Favorite object
            self.myFavorite = [PFObject objectWithClassName:@"Favorite"];
            [self.myFavorite  setObject:[result objectForKey:@"name"] forKey:@"restaurant"];
            [self.myFavorite  setObject:[result objectForKey:@"formatted_address"] forKey:@"address"];
            [self.myFavorite  setObject:[NSNumber numberWithInt:5] forKey:@"rating"];
            [self.myFavorite setObject:self.restaurantID forKey:@"restaurant_id"];
            
            //Create the recommendation (this might need to be moved somewhere else)
            self.myRecommendation = [PFObject objectWithClassName:@"Recommendation"];
            [self.myRecommendation  setObject:[result objectForKey:@"name"] forKey:@"restaurant"];
            [self.myRecommendation  setObject:[result objectForKey:@"formatted_address"] forKey:@"address"];
            [self.myRecommendation  setObject:[NSNumber numberWithInt:5] forKey:@"rating"];
            [self.myRecommendation setObject:self.restaurantID forKey:@"restaurant_id"];
            
            //Method 2 for making the relationship
            if([PFUser currentUser]) //if user is logged in, make the relationship
            {
                [self.myFavorite setObject:[PFUser currentUser] forKey:@"parent"];
                [self.myRecommendation  setObject:[PFUser currentUser] forKey:@"parent"];
            }
            
            
#warning This might need to change. It's grabing the first photo. What if there is no photo?
            NSArray *photoArray = [result objectForKey:@"photos"];
            NSLog(@"Photo Count: %d", [photoArray count]);
            
            
            if([photoArray count] > 0)
            {
                NSDictionary *photoDictionary = photoArray[1];
                NSString *photoReference = [photoDictionary objectForKey:@"photo_reference"];
                NSString *urlString = [NSString stringWithFormat:@"%@photo?maxwidth=%d&maxheight=%d&photoreference=%@&sensor=false&key=%@", [gpClient baseURL], 400, 400, photoReference, GOOGLE_API_KEY];
                [self.placeImageView setImageWithURL:[NSURL URLWithString:urlString]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"This didn't work. Let's try again.");
        }];
    }
}

#pragma mark Custom Methods

// Method to recommend a plac
- (IBAction)recommend:(id)sender {
    
#warning Save this snippet of code for sharing purposes
    //Get Karen's user
    /*PFUser *kUser = [PFQuery getUserObjectWithId:@"TmoqqK6ue8"];
     if(kUser)
     {
     NSLog(@"User name: %@", [kUser objectForKey:@"name"]);
     }
     
     [self.myRecommendation setObject:kUser forKey:@"recommender"];
     [self.myRecommendation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if(!error)
     {
     NSLog(@"Saved the recommended restaurant successfully");
     }
     }];*/
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Facebook",@"Proximity",nil];
    
    [actionSheet showInView:self.view];

}

//Action sheet delegate method. This selects one of the options to share.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == FACEBOOK_SHARE_INDEX)
    {
        FBSession *fbSession = [PFFacebookUtils session];
        if(fbSession)
        {
            [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error)
                {
                    self.friendPickerController = [[FBFriendPickerViewController alloc] init];
                    self.friendPickerController.title = @"Pick Friends";
                    self.friendPickerController.allowsMultipleSelection = NO;
                    
                    [self.friendPickerController loadData];
                    [self.friendPickerController clearSelection];
                    self.friendPickerController.delegate = self;
                    
                    [self presentViewController:self.friendPickerController animated:YES completion:nil];
                }
            }];
        }
        else
        {
            NSLog(@"Facebook session is nil");
        }
        
    }
    else if (buttonIndex == PROXIMITY_SHARE_INDEX)
    {
        ///Bring up logic to share via proximity
    }
}


// Method used to add a place to your favorites
- (BOOL)addToFavorites
{
    
    if([PFUser currentUser])// if user is logged in
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
        [query whereKey:@"parent" equalTo:[PFUser currentUser]];
        [query whereKey:@"restaurant_id" equalTo:self.restaurantID];
        
        BOOL saveFavorite = NO;
        NSArray *favorites = [query findObjects];
        
        if([favorites count] == 0)
        {
            //Save the favorite
            [self.myFavorite save];
            saveFavorite = YES;
        }
        else //The place is already in the user's favorites list
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Ooops"
                                                         message:@"You already have this in your favorites"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
        }
        return saveFavorite;
    }
    
    /*//Creat the Favorite
     PFObject *myFavorite = [PFObject objectWithClassName:@"Favorite"];
     [myFavorite setObject:@"Chipotle" forKey:@"restaurant"];
     [myFavorite setObject:@"1234 Ocean Street, San Francico, CA 94602" forKey:@"address"];
     [myFavorite setObject:[NSNumber numberWithInt:5] forKey:@"rating"];
     
     //Method 1 for making the relationship
     //[myFavorite setObject:[PFUser currentUser] forKey:@"parent"];
     
     //Method 2 for making the relationship
     NSLog(@"User Object ID: %@", [[PFUser currentUser] objectId]);
     [myFavorite setObject:[PFUser objectWithoutDataWithClassName:@"User" objectId:[[PFUser currentUser] objectId]] forKey:@"parent"];
     
     
     //This will save both myFavorite and the user
     [myFavorite saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if(succeeded)
     {
     NSLog(@"I was able to save favorite");
     }
     else
     {
     NSLog(@"Saving Error: %@", [error localizedDescription]);
     }
     }];*/
}

-(IBAction)popTheController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Segue Methods

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return [self addToFavorites];
}


@end
