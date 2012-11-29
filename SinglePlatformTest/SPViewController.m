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
    
    [self fetchRestauransByZip: 94602];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* This method will sign the URL with the SigningKey and Client ID */
/*-(NSURL*)signURL:(NSString *)uriPath params:(NSArray *)parameters client:(NSString *)clientID secret:(NSString*)secret
{
   // int paddingFactor = (4 - [secret length] %4) % 4;
    ///secret = [[NSString alloc] stringByAppendingString:@"="];
}*/

-(NSString *)encodeWithHmacsha1:(NSString *)secret
{
    const char *cKey = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [secret cStringUsingEncoding: NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    return [HMAC base64EncodedString];
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
    
    NSLog(@"URL Path: %@", [url path]);
    NSLog(@"URL Path: %@", [url relativeString]);
    NSLog(@"URL Path: %@", [url fragment]);
    
    NSString *host = @"http://api.singleplatform.co";
    NSString *uri1 = @"/restaurants/search?q=94602&page=0&count=10";
    NSString *uri = @"/restaurants/search?q=sidebar&client=coad3k62n95pi9sbybjydroxy";
    
    NSString *secret_key = @"Sw3j7scIBviRMWBtLQ5jYsE1JnmgxA41hbrxQeQwfcw";
    NSString *clientID = @"coad3k62n95pi9sbybjydroxy";
    
    //restaurants/search?q=sidebar&client=coad3k62n95pi9sbybjydroxy&sig=WP287B9XLhy42Q9X9JdXsJe41j0
    NSString *signature = [self signURL:uri privateKey:secret_key];
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
    //NSLog(@"Raw Data: %@", jsonData);
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

-(NSString *)signURL:(NSString *)url privateKey:(NSString *)key
{
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
    
    //Store the generated signature in an NSData object (as opposed to character array)
    NSData *binarySignature = [NSData dataWithBytes:&result length:CC_SHA1_DIGEST_LENGTH];
    
    // Encodes the signature to URL-safe Base64 using Google's encoder/decoder (from binary to URL-safe)
    NSString *signature = [encoding encode:binarySignature];
    
    NSLog(@"Signature from method: %@", signature);
    
    //TODO This method needs refactoring to take into account the regular expression in the ruby code provided by SinglePlatform

    //Remove the equal sign at the end of the signature
    NSString *trimmedSignature = [ signature stringByReplacingOccurrencesOfString:@"=" withString:@""];
    
    //Put the resulting signed string into a URL
    return trimmedSignature;
    //return  [NSString stringWithFormat:@"%@&sig=%@", urlpath, trimmedSignature];
    
}






@end
