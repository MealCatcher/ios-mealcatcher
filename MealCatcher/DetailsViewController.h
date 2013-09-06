//
//  NIBViewController.h
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 12/2/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

/*@protocol DetailsViewDelegate <NSObject>

@required
-(void)someMethod;

@optional
-(void)theOptionalMethod;

@end*/

@interface DetailsViewController : UIViewController <UIActionSheetDelegate, FBFriendPickerDelegate>
{
}
@property (nonatomic, strong) NSString *restaurantID;
@property (nonatomic, strong) NSString *photoReference;
@property (nonatomic, strong) PFObject *myFavorite;
@property (nonatomic, strong) PFObject *myRecommendation;

-(IBAction)popTheController:(id)sender;

@end
