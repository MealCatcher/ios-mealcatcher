//
//  SPViewController.h
//  SinglePlatformTest
//
//  Created by Jorge Astorga on 11/26/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPViewController : UIViewController <NSURLConnectionDelegate>
{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSMutableData *restaurantData;
}

/* Test Methods */
-(void)fetchForumsData;
-(void)fetchRestaurantData;

/* SinglePlatform API Methods */
-(NSDictionary *)searchRestaurantsByZip:(NSInteger)zipCode;
-(NSDictionary *)searchRestaurantsByPhone:(NSString *)phone;
-(NSDictionary *)serachRestaurantsByKeyword:(NSString *)keyword;
-(NSDictionary *)getRestaurantDetails:(NSString *)location;
-(NSDictionary *)getRestaurantMenu:(NSString *)location;

/* Utility Methods */
-(NSString *)signURL:(NSString*)url signingKey:(NSString*)key;

@end
