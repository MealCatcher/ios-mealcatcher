//
//  main.m
//  TestHMACSHa
//
//  Created by Jorge E. Astorga on 11/26/12.
//  Copyright (c) 2012 bignerdranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Base64.h"
#import "GTMStringEncoding.h"

void sayHello();




int inasdmain(int argc, const char * argv[])
{
    sayHello();
       
    return 0;
}

void sayHello()
{
    
    //Get the private/secret key from Single Platform
    NSString *key = @"Sw3j7scIBviRMWBtLQ5jYsE1JnmgxA41hbrxQeQwfcw";
    
    // Create instance of Google's URL-safe Base64 coder/decoder.
    GTMStringEncoding *encoding = [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];
    
    // Decodes the URL-safe Base64 key to binary.
    NSData *binaryKey = [encoding decode:key];
    
    //Put the URL path and query in an actual NSURL object
    //NSURL *u = [NSURL URLWithString:urlpath];
    
    //Put the URL and path in a single string????????
    //NSString *url = [NSString stringWithFormat:@"%@%@", [u path], [u query]];
    //NSLog(@"URL %@", url);
    
    //Put the URL path and query in a string
    NSString *urlpath = @"/restaurants/search?q=sidebar&client=coad3k62n95pi9sbybjydroxy";
    
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
    //NSLog(@"Binary Signature: %@", binarySignature);
    
    // Encodes the signature to URL-safe Base64 using Google's encoder/decoder (from binary to URL-safe)
    NSString *signature = [encoding encode:binarySignature];
    //NSLog(@"Signature: %@", signature);
    
    //Put the resulting signed string into a URL
    NSString *test =  [NSString stringWithFormat:@"%@&sig=%@", urlpath, signature];
    
    NSLog(@"Test: %@", test);
}




