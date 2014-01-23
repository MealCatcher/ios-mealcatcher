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

/** EXPERIMENTAL METHOD FOR READING CHECKINS **/
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
    
}

/** EXPERIMENTAL METHOD FOR READING CHECKINS **/
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

-(void)setupUI
{
    UIImage *navImage = [UIImage imageNamed:@"clear_nav_bar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Enabling the network activity indicator in AFNetwork library
    //[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //Initialize Test Flight with Meal Catcher Team Token
   [TestFlight takeOff:@"90572434-3d7f-4a17-8a4b-39256eb68bc9"];
    
    #ifdef DEBUG
    
    NSLog(@"Testing the new font");
    [UIFont fontWithName:@"Raleway-Thin" size:29.0];
    
    
    #endif
    
    [Parse setApplicationId:@"2Yjd5bZO0eeYwpSoB6eor8vfEaN4H61NSlU1Ho8b"
                  clientKey:@"Rkm8tKkwmfgJPDi1hnQj2AadpE3GJ14Bxz6aWhU8"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}

//Method called when the push notification registration is successful
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    PFUser *user = [PFUser currentUser];
    
    if(user != nil)
    {
        [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
    }
    
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"failed to register for remote notifications");
}


//Method used to handle a push remote notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [PFPush handlePush:userInfo];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [PFFacebookUtils handleOpenURL:url];
}

/** EXPERIMENTAL METHOD Commented out **/
/*-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [PFFacebookUtils handleOpenURL:url];
}*/


@end
