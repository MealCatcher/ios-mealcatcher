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

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeAddressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@end

@implementation DetailsViewController

#define GOOGLE_API_KEY @"AIzaSyBiDP9jVA2Tad-yvyEIm1gIi2umJRvYzUg"

@synthesize restaurantID;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Details";
    
    //[self getRestaurantDetails:restaurantID];
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
            
#warning This might need to change. It's grabing the first photo. What if there is no photo?
            NSArray *photoArray = [result objectForKey:@"photos"];
            NSDictionary *photoDictionary = photoArray[1];
            

            NSString *photoReference = [photoDictionary objectForKey:@"photo_reference"];
            NSLog(@"Photo Reference: %@", photoReference);

            
            NSDictionary *photoParameters = [[NSDictionary alloc] initWithObjectsAndKeys:@"400", @"maxwidth",
                                             photoReference,
                                             @"photoreference",
                                             @"false",
                                             @"sensor",
                                   GOOGLE_API_KEY,
                                   @"key",
                                             nil];
            
            //Get the place photo
            /*[gpClient getPath:@"photo" parameters:photoParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Got the photo");
                
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"did not get the photo: %@", [error localizedDescription]);
                 NSLog(@"did not get the photo: %@", operation);
             }];*/
            NSString *urlString = [NSString stringWithFormat:@"%@photo?maxwidth=%d&maxheight=%d&photoreference=%@&sensor=false&key=%@", [gpClient baseURL], 400, 400, photoReference, GOOGLE_API_KEY];
            [self.placeImageView setImageWithURL:[NSURL URLWithString:urlString]];
            NSLog(@"URL for image: %@", urlString);

            
            
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
