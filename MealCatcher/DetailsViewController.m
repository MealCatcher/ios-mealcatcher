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
@end

@implementation DetailsViewController

- (IBAction)addToFavorites:(id)sender
{
    
    //This will save both myFavorite and the user
    /*[self.myFavorite saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
        {
            NSLog(@"I was able to save favorite");
        }
        else
        {
            NSLog(@"Saving Error: %@", [error localizedDescription]);
        }
    }];*/
    
    [self.myFavorite save];
    
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

#define GOOGLE_API_KEY @"AIzaSyBiDP9jVA2Tad-yvyEIm1gIi2umJRvYzUg"

@synthesize restaurantID;


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
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:GOOGLE_API_KEY,
                                    @"key",
                                    self.restaurantID,
                                    @"reference",
                                    @"false",
                                    @"sensor",
                                    nil];
        
        //Get the place details
        [gpClient getPath:@"details/json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Got the details right: %@", responseObject);
            
            NSArray *keys = [responseObject allKeys];
            for (int i = 0; i < keys.count; i++) {
                NSLog(@"Key: %@", keys[i]);
            }
            
            NSDictionary *result = [responseObject objectForKey:@"result"];
            NSLog(@"Result Class Type: %@", [result class]);
            
            NSArray *keys1 = [result allKeys];
            for (int i = 0; i < keys1.count; i++) {
                NSLog(@"Key: %@", keys1[i]);
            }
            
            self.placeNameLabel.text = [result objectForKey:@"name"];
            
            //Creat the Favorite
            self.myFavorite = [PFObject objectWithClassName:@"Favorite"];
            [self.myFavorite  setObject:[result objectForKey:@"name"] forKey:@"restaurant"];
            [self.myFavorite  setObject:[result objectForKey:@"formatted_address"] forKey:@"address"];
            [self.myFavorite  setObject:[NSNumber numberWithInt:5] forKey:@"rating"];
            [self.myFavorite setObject:self.restaurantID forKey:@"restaurant_id"];
            
            //Method 1 for making the relationship
            //[myFavorite setObject:[PFUser currentUser] forKey:@"parent"];
            
            //Method 2 for making the relationship
            NSLog(@"User Object ID: %@", [[PFUser currentUser] objectId]);
            [self.myFavorite setObject:[PFUser currentUser] forKey:@"parent"];
            
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
@end
