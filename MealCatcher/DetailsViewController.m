//
//  NIBViewController.m
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 12/2/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "DetailsViewController.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Base64.h"
#import "GTMStringEncoding.h"
#import "GooglePlacesAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Favorite.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@end

@implementation DetailsViewController

#define GOOGLE_API_KEY @"AIzaSyBiDP9jVA2Tad-yvyEIm1gIi2umJRvYzUg"

//@synthesize restaurantID;

#pragma mark FacebookFriendPicker Delegate Protocol
-(void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"Selection was made");
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {

    NSLog(@"Done button was pressed");
    NSMutableString *text = [[NSMutableString alloc] init];
    
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
    }
    
    NSLog(@"Names Picked: %@",text);
    [self dismissViewControllerAnimated:self.friendPickerController completion:^{
        NSLog(@"Dismissed the View Controller");
    }];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:self.friendPickerController completion:^{
        NSLog(@"Dismissed the View Controller");
    }];
}

#pragma Action Sheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    FBSession *fbSession = [PFFacebookUtils session];
    if(fbSession)
    {
        NSLog(@"Facebook Session is not nil");
        
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error)
            {
                NSLog(@"Requested Facebook Friends");
                NSLog(@"Results: %@", result);
                
                self.friendPickerController = [[FBFriendPickerViewController alloc] init];
                self.friendPickerController.title = @"Pick Friends";
                
                
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
    
    //Display action sheet with recommending options
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Proximity",nil];
    
    [actionSheet showInView:self.view];

}

/** Method used to add favorites **/
- (BOOL)addToFavorites
{
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"parent" equalTo:[PFUser currentUser]];
    
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Details";
    
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
            
            self.placeNameLabel.text = [result objectForKey:@"name"];
            
            //Creat the Favorite object
            self.myFavorite = [PFObject objectWithClassName:@"Favorite"];
            [self.myFavorite  setObject:[result objectForKey:@"name"] forKey:@"restaurant"];
            [self.myFavorite  setObject:[result objectForKey:@"formatted_address"] forKey:@"address"];
            [self.myFavorite  setObject:[NSNumber numberWithInt:5] forKey:@"rating"];
            [self.myFavorite setObject:self.restaurantID forKey:@"restaurant_id"];
            
            //Creat the recommendation (this might need to be moved somewhere else)
            self.myRecommendation = [PFObject objectWithClassName:@"Recommendation"];
            [self.myRecommendation  setObject:[result objectForKey:@"name"] forKey:@"restaurant"];
            [self.myRecommendation  setObject:[result objectForKey:@"formatted_address"] forKey:@"address"];
            [self.myRecommendation  setObject:[NSNumber numberWithInt:5] forKey:@"rating"];
            [self.myRecommendation setObject:self.restaurantID forKey:@"restaurant_id"];
            
            //Method 2 for making the relationship
            NSLog(@"User Object ID: %@", [[PFUser currentUser] objectId]);
            [self.myFavorite setObject:[PFUser currentUser] forKey:@"parent"];
            [self.myRecommendation  setObject:[PFUser currentUser] forKey:@"parent"];
            
#warning This might need to change. It's grabing the first photo. What if there is no photo?
            NSArray *photoArray = [result objectForKey:@"photos"];
            NSDictionary *photoDictionary = photoArray[1];

            NSString *photoReference = [photoDictionary objectForKey:@"photo_reference"];
            
            NSDictionary *photoParameters = [[NSDictionary alloc] initWithObjectsAndKeys:@"400", @"maxwidth",
                                             photoReference,
                                             @"photoreference",
                                             @"false",
                                             @"sensor",
                                             GOOGLE_API_KEY,
                                             @"key",
                                             nil];

            NSString *urlString = [NSString stringWithFormat:@"%@photo?maxwidth=%d&maxheight=%d&photoreference=%@&sensor=false&key=%@", [gpClient baseURL], 400, 400, photoReference, GOOGLE_API_KEY];
            [self.placeImageView setImageWithURL:[NSURL URLWithString:urlString]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"This didn't work. Let's try again.");
        }];
    }
}

-(IBAction)popTheController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"Should perform segue got called");
    return [self addToFavorites];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Prepare for segue got called");
}

@end
