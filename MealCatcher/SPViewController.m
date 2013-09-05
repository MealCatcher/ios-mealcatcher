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
#import "MCSearchViewController.h"
#import "SettingsViewController.h"


@interface SPViewController ()

@end

@implementation SPViewController

@synthesize nibViewController;



#pragma mark Life Cycle Methods

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
    
    NSLog(@"Value of updateLocationCenter in");
    return self;
}




-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self simulateLocation] == YES)
    {
        [self simulateMapLocation];
    }
    else
    {
        if([CLLocationManager locationServicesEnabled] == YES)
        {
            if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
            {
                NSLog(@"Location Services AUTHORIZED");
            }
            else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
            {
                NSLog(@"Location Services Not Determined");
            }
            
            
            NSLog(@"Location Services are enabled");
            [worldView setShowsUserLocation:YES];
            [worldView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
        }
        else if([CLLocationManager locationServicesEnabled] == NO)
        {
            NSLog(@"Location Services are disabled");
        }
        
        
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem* addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRestaurant)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //Add the other bar button item to push the settings view
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [button addTarget:self action:@selector(viewSettings) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:settingsButton animated:YES];
}


#pragma mark Custom Methods

-(BOOL)simulateLocation
{
    NSUserDefaults *locationPreferences = [NSUserDefaults standardUserDefaults];
    
    if([locationPreferences objectForKey:@"location_preferences"] == nil)
    {
        [locationPreferences setBool:NO forKey:@"location_preferences"];
        [locationPreferences synchronize];
        NSLog(@"The value of location preferences has been set to %@", [locationPreferences boolForKey:@"location_preferences"] ?@"YES":@"NO");
        
        return NO;
    }
    else
    {
        if([locationPreferences boolForKey:@"location_preferences"] == YES)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}


/*
 * Method that brings up the view to search for a restaurant
 */
- (void)addRestaurant
{
    NSLog(@"Adding restaurant button called");
    
    MCSearchViewController *searchViewController =
    [[MCSearchViewController alloc] initWithNibName:@"MCSearchViewController" bundle:Nil];
    
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark Map and Location Methods

-(void)simulateMapLocation
{
    
    
    //Oakland, CA
    //CLLocationCoordinate2D placeLocation = CLLocationCoordinate2DMake(37.802787, -122.211471);
    
    //Rackspace SF
    CLLocationCoordinate2D placeLocation = CLLocationCoordinate2DMake(37.785147, -122.397449);
    
    
    //Center the map region around these coordinates
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placeLocation, 1500, 1500);
    [worldView setRegion:region animated:YES];
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:placeLocation.latitude longitude:placeLocation.longitude];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:userLocation
                   completionHandler:^(NSArray* placemarks, NSError* error){
                       if ([placemarks count] > 0)
                       {
                           //CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                       }
                   }];
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
                               
                               
                               
                               //NSInteger test = [[placeMark postalCode] integerValue];
                               
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


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorized) {
        updateLocationCenter = YES;
    }
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
    self.nibViewController = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:Nil];
    self.nibViewController.restaurantID = @"blackberry-bistro";
    [self.navigationController pushViewController:self.nibViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
