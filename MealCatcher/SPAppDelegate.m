//
//  SPAppDelegate.m
//  SinglePlatformTest
//
//  Created by Jorge Astorga on 11/26/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "SPAppDelegate.h"
#import "SPViewController.h"
#import "MCFavoritesViewController.h"

@implementation SPAppDelegate

@synthesize navigationController;
@synthesize window;
@synthesize viewController;

//Testing work computer commit

-(void)setupUI
{
    UIImage *navImage = [UIImage imageNamed:@"clear_nav_bar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
        
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque
                                                animated:YES];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
   
    //self.viewController = [[SPViewController alloc] initWithNibName:@"SPViewController" bundle:nil];
//    self.favoritesViewController = [[MCFavoritesViewController alloc] initWithNibName:MC_FAVORITES_VIEW_CONTROLLER bundle:nil];
    
    //Allocating navigation view controller
    //self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.favoritesViewController];
    
    //[self.window addSubview:self.navigationController.view];
    //self.window.rootViewController = self.viewController;
//    self.window.rootViewController = self.navigationController;
    
    //[self.window makeKeyAndVisible];
    
    //Initialize Test Flight with Meal Catcher Team Token
    [TestFlight takeOff:@"c096138643dd233a896e69c2b19b3a55_MTYzNzQxMjAxMi0xMi0wNiAxNzoxNToyMy4wOTMwMjc"];
    
    #ifdef DEBUG
        NSLog(@"The DEBUG settings are working!");
    #endif
    //[self setupUI];
    
    return YES;
}

@end
