//
//  SPAppDelegate.h
//  SinglePlatformTest
//
//  Created by Jorge Astorga on 11/26/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestFlight.h"
#import <Parse/Parse.h>

#define MC_FAVORITES_VIEW_CONTROLLER @"MCFavoritesViewController"

@class SPViewController;

@interface SPAppDelegate : UIResponder <UIApplicationDelegate>
{
}
@property (strong, nonatomic) UIWindow *window;

@end
