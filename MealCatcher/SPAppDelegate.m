//
//  SPAppDelegate.m
//  SinglePlatformTest
//
//  Created by Jorge Astorga on 11/26/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "SPAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation SPAppDelegate

-(void)setupUI
{
    UIImage *navImage = [UIImage imageNamed:@"clear_nav_bar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Enabling the network activity indicator in AFNetwork library
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //Initialize Test Flight with Meal Catcher Team Token
   [TestFlight takeOff:@"90572434-3d7f-4a17-8a4b-39256eb68bc9"];
    
    #ifdef DEBUG
    
    #endif
    
    [Parse setApplicationId:@"2Yjd5bZO0eeYwpSoB6eor8vfEaN4H61NSlU1Ho8b"
                  clientKey:@"Rkm8tKkwmfgJPDi1hnQj2AadpE3GJ14Bxz6aWhU8"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [PFFacebookUtils handleOpenURL:url];
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [PFFacebookUtils handleOpenURL:url];
}


@end
