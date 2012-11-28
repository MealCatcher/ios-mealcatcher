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

-(void)fetchForumsData;
-(void)fetchRestaurantData;
-(NSString *)signURL:(NSString*)url privateKey:(NSString*)key;

@end
