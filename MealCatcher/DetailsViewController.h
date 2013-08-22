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
    NSMutableData *restaurantData;
    IBOutlet UILabel *restaurantNameLabel;
    IBOutlet UILabel *websiteURL;
    IBOutlet UILabel *address1;
    IBOutlet UILabel *address2;
    IBOutlet UILabel *city;
    IBOutlet UILabel *state;
    IBOutlet UILabel *zip;
    IBOutlet UILabel *phone;
    IBOutlet UILabel *description;
}

@property (nonatomic) NSString *restaurantID;

-(IBAction)popTheController:(id)sender;

@end
