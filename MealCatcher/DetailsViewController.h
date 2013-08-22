//
//  NIBViewController.h
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 12/2/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

/*@protocol DetailsViewDelegate <NSObject>

@required
-(void)someMethod;

@optional
-(void)theOptionalMethod;

@end*/

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

@property (nonatomic, strong) NSString *restaurantID;
@property (nonatomic, strong) NSString *photoReference;

//@property (nonatomic, weak) id <DetailsViewDelegate> delegate;

-(IBAction)popTheController:(id)sender;

@end
