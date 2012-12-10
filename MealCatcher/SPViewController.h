//
//  SPViewController.h
//  SinglePlatformTest
//
//  Created by Jorge Astorga on 11/26/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DetailsViewController.h"


@class TestViewController;
@class DetailsViewController;

@interface SPViewController : UIViewController <NSURLConnectionDelegate,CLLocationManagerDelegate, MKMapViewDelegate>
{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSMutableData *restaurantData;
    IBOutlet MKMapView *worldView;
    CLLocationManager *locationManager;
    BOOL updateLocationCenter;

}

@property (nonatomic, strong) DetailsViewController *nibViewController;

/* Test Methods */
-(void)fetchForumsData;
-(void)fetchRestaurantData;

/* SinglePlatform API Methods */
-(void )searchRestaurantsByZip:(NSInteger)zipCode;
-(NSDictionary *)searchRestaurantsByPhone:(NSString *)phone;
-(NSDictionary *)serachRestaurantsByKeyword:(NSString *)keyword;
-(NSDictionary *)getRestaurantDetails:(NSString *)location;
-(NSDictionary *)getRestaurantMenu:(NSString *)location;

/* Utility Methods */
-(NSString *)signURL:(NSMutableString*)url signingKey:(NSMutableString*)key;


@end
