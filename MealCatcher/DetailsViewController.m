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

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize restaurantID;


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
    
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Details";
    
    #ifdef DEBUG
        NSLog(@"Restaurant ID: %@", restaurantID);
    #endif
    
    
    [self getRestaurantDetails:restaurantID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)popTheController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/* This method signs the a URL using HMAC-SHA1 and returns the signature */
-(NSString *)signURL:(NSMutableString *)url signingKey:(NSMutableString*)key
{
    [key replaceOccurrencesOfString:@"-" withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, [key length])];
    [key replaceOccurrencesOfString:@"_" withString:@"/" options:NSLiteralSearch range:NSMakeRange(0, [key length])];
    
    // Create instance of Google's URL-safe Base64 coder/decoder.
    GTMStringEncoding *encoding = [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];
    
    // Decodes the URL-safe Base64 key to binary.
    NSData *binaryKey = [encoding decode:key];
    
    //Put the URL path and query in a string
    NSString *urlpath = url;
    
    // Stores the url in a NSData.
    //Put the URL in an NSData object using ASCII String Encoding. Stores it in binary.
    NSData *urlData = [urlpath dataUsingEncoding: NSASCIIStringEncoding];
    
    // Sign the URL with Objective-C HMAC SHA1 algorithm and put it in character array
    // the size of a SHA1 digest
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1,
           [binaryKey bytes],
           [binaryKey length],
           [urlData bytes],
           [urlData length],
           &result);
    
    NSData *binarySignature = [NSData dataWithBytes:&result length:CC_SHA1_DIGEST_LENGTH];
    
    // Encodes the signature to URL-safe Base64 using Google's encoder/decoder (from binary to URL-safe)
    NSMutableString *signature = [[NSMutableString alloc] initWithString:[encoding encode:binarySignature]];
    
    [signature replaceOccurrencesOfString:@"+" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [signature length])];
    [signature replaceOccurrencesOfString:@"/" withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, [signature length])];
    
    //Remove the equal sign at the end of the signature
    [signature replaceOccurrencesOfString:@"=" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [signature length])];
    
    return signature;
}

-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    //Add the incoming chunk of data to the container we are keeping
    //The data always comes in the correct order
    [jsonData appendData:data];
}


-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    //Release the connection object, we're done with it
    conn = nil;
    
    //Releas the jsonData, we're done with it
    jsonData = nil;
    
    //Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    //Create and show an alert view with this error displayed
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [av show];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    //We are just checking to make sure we are gettin back the JSON
    NSString *jsonCheck = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    /* Now try to deserialize the JSON object into a dictionary */
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if(jsonObject != nil && error == nil)
    {
        if([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
            NSString *businessType = [deserializedDictionary objectForKey:@"businessType"];
            
            
            #ifdef DEBUG
                NSLog(@"Business Type: %@", businessType);
            #endif
            
            
            //CLLocationCoordinate2D placeLocation = CLLocationCoordinate2DMake(37.802787, -122.211471);
            //SPAnnotations *annotation = [[SPAnnotations alloc] initWithCoordinates:placeLocation title:@"Jorge's Place" subtitle:@"Karen's Place"];
            //[worldView addAnnotation:annotation];
            
            //id results = [deserializedDictionary objectForKey:@"results"];
            
            NSArray *results = [deserializedDictionary objectForKey:@"results"];
            
            #ifdef DEBUG
                NSLog(@"Results Array Count: %d", [results count]);
            #endif
            
            
            id general = [deserializedDictionary objectForKey:@"general"];
            if([general isKindOfClass:[NSDictionary class]])
            {
                
                #ifdef DEBUG
                    NSLog(@"Got the general json data and it's  dictionary");
                #endif
                
                
                NSDictionary *generalRestaurantData = (NSDictionary *)general;
                
                /* Get the fields for the restaurant */
                NSString *restaurantName = [generalRestaurantData objectForKey:@"name"];
                NSString *website = [generalRestaurantData objectForKey:@"website"];
                NSString *descriptionText = [generalRestaurantData objectForKey:@"desc"];
                
                
                restaurantNameLabel.text = restaurantName;
                websiteURL.text  = website;
                description.text = descriptionText;
                
            }
            
            id location = [deserializedDictionary objectForKey:@"location"];
            if ([location isKindOfClass:[NSDictionary class]]) {
                
                #ifdef DEBUG
                    NSLog(@"Getting the location data");
                #endif
                
                NSDictionary *locationData = (NSDictionary *)location;
                NSString *address1Text = [locationData objectForKey:@"address1"];
                NSString *address2Text = [locationData objectForKey:@"address2"];
                NSString *cityText = [locationData objectForKey:@"city"];
                NSString *stateText = [locationData objectForKey:@"state"];
                NSString *zipText = [locationData objectForKey:@"zipCode"];
                
                address1.text = address1Text;
                address2.text = address2Text;
                city.text = cityText;
                state.text = stateText;
                zip.text = zipText;
            }
            
            id phones = [deserializedDictionary objectForKey:@"phones"];
            if([phones isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *phoneData = (NSDictionary*)phones;
                
                NSString *mainText = [phoneData objectForKey:@"main"];
                NSString *faxText = [phoneData objectForKey:@"fax"];
                
                #ifdef DEBUG
                    NSLog(@"Main: %@", mainText);
                    NSLog(@"Fax: %@", faxText);
                #endif
                
                phone.text = mainText;
            }
            
            /*for(int i=0; i < [results count]; i++)
             {
             NSString *latitude = [[[results objectAtIndex:i] objectForKey:@"location"] objectForKey:@"latitude"];
             NSString *longitude = [[[results objectAtIndex:i] objectForKey:@"location"] objectForKey:@"longitude"];
             //NSLog(@"Latitude: %@", latitude);
             //NSLog(@"Longitude: %@", longitude);
             NSString *name = [[[results objectAtIndex:i] objectForKey:@"general"] objectForKey:@"name"];
             NSString *businessType =[[results objectAtIndex:i] objectForKey:@"businessType"];
             CLLocationCoordinate2D testLocation = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
             
             //Code that adds the annotations to the MAP view
             //SPAnnotations *anotherAnnotation = [[SPAnnotations alloc] initWithCoordinates:testLocation title:name subtitle:businessType];
             
             //anotherAnnotation.pinColor = MKPinAnnotationColorRed;
             
             NSLog(@"Business Name: %@", name);
             //[worldView addAnnotation:anotherAnnotation];
             
             
             //NSLog(@"Array Content: %@", results);
             //NSLog(@"Array Content Type: %@", [[results objectAtIndex:0] class]);
             //NSArray *theKeys = [[results objectAtIndex:0] allKeys];
             //NSLog(@"%@", theKeys);
             
             //NSLog(@"Location Type: %@", [[[results objectAtIndex:0] objectForKey:@"location"] class]);
             
             }*/
            
            //NSLog(@"Deserialized JSON dictionary = %@", deserializedDictionary);
        }
        else if([jsonObject isKindOfClass:[NSArray class]])
        {
            NSArray *deserializedArray = (NSArray *)jsonObject;
            #ifdef DEBUG
                NSLog(@"Deserealized JSON Array %@", deserializedArray);
            #endif
            
        }
        else
        {
            /* Some other object was returned. We don't know how to deal with this situation. */
        }
    }
    else if(error != nil)
    {
        #ifdef DEBUG
            NSLog(@"An error happened while deserializing the JSON data");
        #endif
        
        //Should probably display an error message to the user
    }
}

-(void)getRestaurantDetails:(NSString *)locationID
{
    NSMutableString *SECRET = [[NSMutableString alloc] initWithString:@"Sw3j7scIBviRMWBtLQ5jYsE1JnmgxA41hbrxQeQwfcw"];
    NSString *BASE_SINGLEPLATFORM_HOST = @"http://api.singleplatform.co";
    NSMutableString *LOCATION_DETAILS_URI = [[NSMutableString alloc] initWithFormat:@"/restaurants/%@", locationID];
    NSMutableString *clientID = [[NSMutableString alloc]initWithString:@"coad3k62n95pi9sbybjydroxy"];
    NSMutableString *uri = [NSMutableString stringWithFormat:@"/restaurants/%@?client=%@", locationID, clientID];
    
    NSString* signature = [self signURL:uri signingKey:SECRET];
    [uri appendFormat:@"&sig=%@", signature];
    
    jsonData = [[NSMutableData alloc] init];
    NSURL *myUrl = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@", BASE_SINGLEPLATFORM_HOST, uri]];
    
    #ifdef DEBUG
        NSLog(@"Final URL: %@", myUrl);
    #endif
    NSURLRequest *request = [NSURLRequest requestWithURL:myUrl];
    connection  = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


@end
