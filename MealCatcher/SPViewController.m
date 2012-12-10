//
//  SPViewController.m
//  SinglePlatformTest
//
//  Created by Jorge Astorga on 11/26/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "SPViewController.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Base64.h"
#import "GTMStringEncoding.h"
#import "SPAnnotations.h"
#import "DetailsViewController.h"

@interface SPViewController ()

@end

@implementation SPViewController

@synthesize nibViewController;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        locationManager = [[CLLocationManager alloc] init];
        
        #ifdef DEBUB
            NSLog(@"Location Manager Delegate set!");
        #endif
        
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    //initialize update center
    updateLocationCenter = YES;
    
    return self;
}


- (void)viewDidLoad
{
    //[self fetchForumsData];
    
    //[self fetchRestauransByZip: 94602];
    //[self searchRestaurantsByZip: 94602];
    
    [super viewDidLoad];
    [worldView setShowsUserLocation:YES];
    [worldView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    self.title = @"MealCatcher";
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Method used to get search for restaurants by zip code
 *
 */
-(void)searchRestaurantsByZip:(NSInteger)zipCode;
{
    NSMutableString *SECRET = [[NSMutableString alloc] initWithString:@"Sw3j7scIBviRMWBtLQ5jYsE1JnmgxA41hbrxQeQwfcw"];
    NSString *BASE_SINGLEPLATFORM_HOST = @"http://api.singleplatform.co";
    NSMutableString *RESTAURANT_SEARCH_URI = [[NSMutableString alloc] initWithString:@"/restaurants/search?q=%@"];
    NSMutableString *clientID = [[NSMutableString alloc]initWithString:@"coad3k62n95pi9sbybjydroxy"];
    NSMutableString *uri = [NSMutableString stringWithFormat:@"/restaurants/search?q=%d&client=%@", zipCode, clientID];
    
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



/* Method used to find restaurants by zip code
 *
 */
-(void)fetchRestauransByZip:(NSInteger)zipCode
{
    jsonData = [[NSMutableData alloc] init];
   
    #ifdef DEBUG
      NSLog(@"Zip Code: %d", zipCode);  
    #endif
    
    restaurantData = [[NSMutableData alloc] init];
    
    NSURL *url1 = [NSURL URLWithString:@"http://api.singleplatform.co/restaurants/search?q=94602&page=0&count=10"];
    NSURL *url2 = [NSURL URLWithString:@"http://api.singleplatform.co/restaurants/search?q=sidebar&page=0&count=10"];
    NSURL *url = [NSURL URLWithString:@"http://api.singleplatform.co/restaurants/search?q=sidebar&client=coad3k62n95pi9sbybjydroxy"];
    NSString* noSingUrl = @"http://api.singleplatform.co/restaurants/search?q=sidebar&client=coad3k62n95pi9sbybjydroxy";
    
    NSString *host = @"http://api.singleplatform.co";
    NSString *uri1 = @"/restaurants/search?q=94602&page=0&count=10";
    NSString *uri = @"/restaurants/search?q=sidebar&client=coad3k62n95pi9sbybjydroxy";
    
    NSString *secret_key = @"Sw3j7scIBviRMWBtLQ5jYsE1JnmgxA41hbrxQeQwfcw";
    NSString *clientID = @"coad3k62n95pi9sbybjydroxy";
    
    //restaurants/search?q=sidebar&client=coad3k62n95pi9sbybjydroxy&sig=WP287B9XLhy42Q9X9JdXsJe41j0
    NSString *signature = [self signURL:uri signingKey:[NSMutableString stringWithString:[[NSMutableString alloc] initWithString:secret_key]]];
    
    NSString *signedUrl = [noSingUrl stringByAppendingString:@"&sig=WP287B9XLhy42Q9X9JdXsJe41j0"];
    NSURL *finalURL = [NSURL URLWithString:signedUrl];
    
    #ifdef DEBUG
        NSLog(@"Final URL: %@", finalURL);
    #endif
    
    NSURLRequest *request = [NSURLRequest requestWithURL:finalURL];
    connection  = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}

-(void)fetchForumsData
{
    //Create a new data container for the stuff that comes back from the service
    jsonData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/smartfeed.php?"
                  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    
    #ifdef DEBUG
        NSLog(@"Path: %@", [url path]);
        NSLog(@"Parameter String: %@", [url parameterString]);
        NSLog(@"Query: %@", [url query]);
    #endif
    
    //Put that URL into a NSURLRequest
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    //Create a connection that will exchance this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}

-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    //Add the incoming chunk of data to the container we are keeping
    //The data always comes in the correct order
    [jsonData appendData:data];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    //We are just checking to make sure we are gettin back the JSON
    NSString *jsonCheck = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    #ifdef DEBUG
        NSLog(@"jsonCheck = %@", jsonCheck);
    #endif
    
    
    /* Now try to deserialize the JSON object into a dictionary */
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if(jsonObject != nil && error == nil)
    {
        #ifdef DEBUG
            NSLog(@"Data: %@", jsonObject);
        #endif
        
        
        if([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
            NSString *count = [deserializedDictionary objectForKey:@"count"];
            
            #ifdef DEBUG
                NSLog(@"Count: %d", [count integerValue]);
            #endif
            
            
            if([count integerValue] > 0)
            {
                //CLLocationCoordinate2D placeLocation = CLLocationCoordinate2DMake(37.802787, -122.211471);
                //SPAnnotations *annotation = [[SPAnnotations alloc] initWithCoordinates:placeLocation title:@"Jorge's Place" subtitle:@"Karen's Place"];
                //[worldView addAnnotation:annotation];
                
                //id results = [deserializedDictionary objectForKey:@"results"];
                //NSLog(@"Type for results: %@", [results class]);
                NSArray *results = [deserializedDictionary objectForKey:@"results"];
                
                #ifdef DEBUG
                    NSLog(@"Results Array Count: %d", [results count]);
                #endif
                
                
                
                
                for(int i=0; i < [results count]; i++)
                {
                    NSString *latitude = [[[results objectAtIndex:i] objectForKey:@"location"] objectForKey:@"latitude"];
                    NSString *longitude = [[[results objectAtIndex:i] objectForKey:@"location"] objectForKey:@"longitude"];
                    NSString *name = [[[results objectAtIndex:i] objectForKey:@"general"] objectForKey:@"name"];
                    NSString *businessType =[[results objectAtIndex:i] objectForKey:@"businessType"];
                    CLLocationCoordinate2D testLocation = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
                    
                    //Code that adds the annotations to the MAP view
                    SPAnnotations *anotherAnnotation = [[SPAnnotations alloc] initWithCoordinates:testLocation title:name subtitle:businessType];
                    
                    anotherAnnotation.pinColor = MKPinAnnotationColorRed;
                    
                    [worldView addAnnotation:anotherAnnotation];
                    
                    #ifdef DEBUG
                        NSLog(@"Business Name: %@", name);
                        NSLog(@"Array Content: %@", results);
                        NSLog(@"Array Content Type: %@", [[results objectAtIndex:0] class]);
                    #endif
                    
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
        NSLog(@"An error happened while deserializing the JSON data");
        //Should probably display an error message to the user
        //Should probably send an error to TestFlight
    }
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

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    
    #ifdef DEBUG
        NSLog(@"The user's location updated!");
        NSLog(@"Update Location Center: %d", updateLocationCenter);
    #endif
    
    
    if(updateLocationCenter == YES)
    {
        CLLocationCoordinate2D loc = [userLocation coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1500, 1500);
        [worldView setRegion:region animated:YES];
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:[userLocation location]
                       completionHandler:^(NSArray* placemarks, NSError* error){
                           if ([placemarks count] > 0)
                           {
                               CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                               
                                #ifdef DEBUG
                                    NSLog(@"Number of Placemarks: %d", [placemarks count]);
                                    NSLog(@"Postal Code: %@", [placeMark postalCode]);
                                #endif
                            
                               NSInteger test = [[placeMark postalCode] integerValue];
                               
                               [self searchRestaurantsByZip:test];
                               
                               
                               //annotation.placemark = [placemarks objectAtIndex:0];
                               
                               // Add a More Info button to the annotation's view.
                               //MKPinAnnotationView*  view = (MKPinAnnotationView*)[map viewForAnnotation:annotation];
                               //if (view && (view.rightCalloutAccessoryView == nil))
                               //{
                               //  view.canShowCallout = YES;
                               //view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                               //   }
                           }
                       }];
        //[worldView setShowsUserLocation:NO];
        
        updateLocationCenter = NO;
    }
    // }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *result = nil;
    
    if([annotation isKindOfClass:[SPAnnotations class]] == NO)
    {
        return result;
    }
    if([mapView isEqual: worldView] == NO)
    {
        /* We want to process this event only for the MapView that
         we created previously */
        return result;
    }

    SPAnnotations *senderAnnotation = (SPAnnotations *)annotation;
    NSString *pinReusableIndentifier = [SPAnnotations reusableIdentifierforPinColor:senderAnnotation.pinColor];
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIndentifier];
    
    
	    if(annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:pinReusableIndentifier];
        
        [annotationView setCanShowCallout:YES];
    }
    
    annotationView.pinColor = senderAnnotation.pinColor;
    annotationView.animatesDrop = YES;
    UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = disclosureButton;
    
    result = annotationView;
    
    return result;
}

/* Method that responds to taps on the map pin callout accessory control */
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    //self.testViewController = [[TestViewController alloc]initWithNibName:nil bundle:NULL];
    self.nibViewController = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:Nil];
    
    //THIS IS A GOOD PLACE TO INSERT THE other view
    //[self presentModalViewController:testViewController animated:YES];
    //[self presentModalViewController:nibViewController animated:YES];
    /*  bellanico */
    /* blackberry-bistro */
    /*  mcdonalds-1032 */
    self.nibViewController.restaurantID = @"blackberry-bistro";
    [self.navigationController pushViewController:self.nibViewController animated:YES];
    
}

@end
