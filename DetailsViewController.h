//
//  NIBViewController.h
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 12/2/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailsViewController : UIViewController
{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSMutableData *restaurantData;
}

@property (nonatomic) NSString *restaurantID;

-(IBAction)popTheController:(id)sender;
/* Utility Methods */
-(NSString *)signURL:(NSMutableString*)url signingKey:(NSMutableString*)key;

@end
