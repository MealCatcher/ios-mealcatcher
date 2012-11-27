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




int main(int argc, const char * argv[])
{

        // insert code here...
        NSLog(@"Hello, World!");
        
    
        
        NSString* url = @"http://api.singleplatform.co/restaurants/haru-7?client=coad3k62n95pi9sbybjydroxy";

        
        NSString *secret = @"Sw3j7scIBviRMWBtLQ5jYsE1JnmgxA41hbrxQeQwfcw";
        NSLog(@"Secret: %@", secret);
        
        secret = [secret stringByAppendingString:@"="];
        NSLog(@"Secret + = : %@", secret);
    
        NSData *binary_key = [NSData dataFromBase64String: secret];
        NSLog(@"Binary Key: %@", binary_key);
        NSString *urlTest = @"/restaurants/search?q=sidebar&client=coad3k62n95pi9sbybjydroxy";
        //NSString *urlTest = @"/restaurants/haru-7?client=coad3k62n95pi9sbybjydroxy";
    sayHello();
       
    return 0;
}

void sayHello()
{
    
    NSString *urlpath = @"/restaurants/search?q=sidebar&client=coad3k62n95pi9sbybjydroxy";
    NSLog(@"Testing another function");
    //NSString *key = @"vNIXE0xscrmjlyV-12Nj_BvUPaw=";
    NSString *key = @"Sw3j7scIBviRMWBtLQ5jYsE1JnmgxA41hbrxQeQwfcw";
    
    NSURL *u = [NSURL URLWithString:urlpath];
    NSString *url = [NSString stringWithFormat:@"%@%@", [u path], [u query]];
    NSLog(@"URL %@", url);
    
    
    // Stores the url in a NSData.
    //NSData *urlData = [url dataUsingEncoding: NSASCIIStringEncoding];
    NSData *urlData = [urlpath dataUsingEncoding: NSASCIIStringEncoding];
    
    // URL-safe Base64 coder/decoder.
    GTMStringEncoding *encoding = [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];
    
    // Decodes the URL-safe Base64 key to binary.
    NSData *binaryKey = [encoding decode:key];
    
    
    // Signs the URL.
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1,
           [binaryKey bytes], [binaryKey length],
           [urlData bytes], [urlData length],
           &result);
    NSData *binarySignature = [NSData dataWithBytes:&result length:CC_SHA1_DIGEST_LENGTH];
    NSLog(@"Binary Signature: %@", binarySignature);
    
    // Encodes the signature to URL-safe Base64.
    NSString *signature = [encoding encode:binarySignature];
    NSLog(@"Signature: %@", signature);
    
    NSString *test =  [NSString stringWithFormat:@"%@&sig=%@", urlpath, signature];
    
    NSLog(@"Test: %@", test);
}