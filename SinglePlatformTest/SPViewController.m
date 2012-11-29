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

@interface SPViewController ()

@end

@implementation SPViewController


- (void)viewDidLoad
{
    //[self fetchForumsData];
    
    //[self fetchRestauransByZip: 94602];
    [self searchRestaurantsByZip: 94602];
    
    [super viewDidLoad];
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
    //NSLog(@"Got here 1.0");
    NSMutableString *SECRET = [[NSMutableString alloc] initWithString:@"Sw3j7scIBviRMWBtLQ5jYsE1JnmgxA41hbrxQeQwfcw"];
    NSString *BASE_SINGLEPLATFORM_HOST = @"http://api.singleplatform.co";
    NSMutableString *RESTAURANT_SEARCH_URI = [[NSMutableString alloc] initWithString:@"/restaurants/search?q=%@"];
    NSMutableString *clientID = [[NSMutableString alloc]initWithString:@"coad3k62n95pi9sbybjydroxy"];
    //NSLog(@"Got here 1.1");
    NSMutableString *uri = [NSMutableString stringWithFormat:@"/restaurants/search?q=%d&client=%@", zipCode, clientID];
    //NSLog(@"URI: %@", uri);
    
    NSString* signature = [self signURL:uri signingKey:SECRET];
    //NSLog(@"Signature: %@", signature);
    [uri appendFormat:@"&sig=%@", signature];
    //NSLog(@"URI: %@", uri);
    
    jsonData = [[NSMutableData alloc] init];
    NSURL *myUrl = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@", BASE_SINGLEPLATFORM_HOST, uri]];
    NSLog(@"Final URL: %@", myUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:myUrl];
    
    connection  = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}



/* Method used to find restaurants by zip code
 *
 */
-(void)fetchRestauransByZip:(NSInteger)zipCode
{
    jsonData = [[NSMutableData alloc] init];
    
    NSLog(@"Zip Code: %d", zipCode);
    
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
    NSLog(@"Signature: %@", signature);
    
    NSString *signedUrl = [noSingUrl stringByAppendingString:@"&sig=WP287B9XLhy42Q9X9JdXsJe41j0"];
    NSURL *finalURL = [NSURL URLWithString:signedUrl];
    
    NSLog(@"Final URL: %@", finalURL);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:finalURL];
    
    connection  = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}

-(void)fetchForumsData
{
    //Create a new data container for the stuff that comes back from the service
    jsonData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/smartfeed.php?"
                  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    
    NSLog(@"Path: %@", [url path]);
    NSLog(@"Parameter String: %@", [url parameterString]);
    NSLog(@"Query: %@", [url query]);
    
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
            NSLog(@"Deserialized JSON dictionary = %@", deserializedDictionary);
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
@end
