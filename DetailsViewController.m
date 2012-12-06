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
    NSLog(@"Restaurant ID: %@", restaurantID);
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
    NSLog(@"Inside this method");
    NSLog(@"Key: %@", key);
    NSLog(@"URI Again: %@", url);
    
    //NSMutableString *tempKey = [[NSMutableString alloc] initWithString:key];
    //NSLog(@"Temp Key: %@", tempKey);
    [key replaceOccurrencesOfString:@"-" withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, [key length])];
    NSLog(@"Inside this method 1.1");
    [key replaceOccurrencesOfString:@"_" withString:@"/" options:NSLiteralSearch range:NSMakeRange(0, [key length])];
    
    
    NSLog(@"Got here 1.0");
    
    // Create instance of Google's URL-safe Base64 coder/decoder.
    GTMStringEncoding *encoding = [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];
    
    // Decodes the URL-safe Base64 key to binary.
    NSData *binaryKey = [encoding decode:key];
    
    //Put the URL path and query in a string
    NSString *urlpath = url;
    
    // Stores the url in a NSData.
    //Put the URL in an NSData object using ASCII String Encoding. Stores it in binary.
    //NSData *urlData = [url dataUsingEncoding: NSASCIIStringEncoding];
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
    
    NSLog(@"Signature from method: %@", signature);
    
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
    NSLog(@"jsonCheck = %@", jsonCheck);
    
    /* Now try to deserialize the JSON object into a dictionary */
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if(jsonObject != nil && error == nil)
    {
        NSLog(@"Successfully desearilzer!!");
        
        if([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
            NSString *count = [deserializedDictionary objectForKey:@"count"];
            NSLog(@"Count: %d", [count integerValue]);
            
            if([count integerValue] > 0)
            {
                //CLLocationCoordinate2D placeLocation = CLLocationCoordinate2DMake(37.802787, -122.211471);
                //SPAnnotations *annotation = [[SPAnnotations alloc] initWithCoordinates:placeLocation title:@"Jorge's Place" subtitle:@"Karen's Place"];
                //[worldView addAnnotation:annotation];
                
                //id results = [deserializedDictionary objectForKey:@"results"];
                //NSLog(@"Type for results: %@", [results class]);
                NSArray *results = [deserializedDictionary objectForKey:@"results"];
                NSLog(@"Results Array Count: %d", [results count]);
                
                for(int i=0; i < [results count]; i++)
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
                    
                }
            }
            
            //NSLog(@"Deserialized JSON dictionary = %@", deserializedDictionary);
        }
        else if([jsonObject isKindOfClass:[NSArray class]])
        {
            NSArray *deserializedArray = (NSArray *)jsonObject;
            NSLog(@"Deserealized JSON Array %@", deserializedArray);
        }
        else
        {
            /* Some other object was returned. We don't know how to deal with this situation. */
        }
    }
    else if(error != nil)
    {
        NSLog(@"An error happened while deserializing the JSON data");
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
    //NSLog(@"Signature: %@", signature);
    [uri appendFormat:@"&sig=%@", signature];
    //NSLog(@"URI: %@", uri)
    
    jsonData = [[NSMutableData alloc] init];
    NSURL *myUrl = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@", BASE_SINGLEPLATFORM_HOST, uri]];
    NSLog(@"Final URL: %@", myUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:myUrl];
    
    connection  = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}


@end
