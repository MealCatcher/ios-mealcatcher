//
//  SettingsViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 1/18/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize locationSimulationSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"Settings"];
    [self.locationSimulationSwitch setOn:FALSE animated:YES];
    
    NSUserDefaults *locationPreferences = [NSUserDefaults standardUserDefaults];
    
    if([locationPreferences objectForKey:@"location_preferences"] == nil)
    {
        [locationPreferences setBool:NO forKey:@"location_preferences"];
        [locationPreferences synchronize];
        NSLog(@"The value of location preferences has been set to %@", [locationPreferences boolForKey:@"location_preferences"] ?@"YES":@"NO");
    }
    else
    {
        if([locationPreferences boolForKey:@"location_preferences"] == YES)
        {
            [self.locationSimulationSwitch setOn:YES animated:YES];
        }
        else
        {
            [self.locationSimulationSwitch setOn:NO animated:YES];
        }
    }

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveSimulateLocation:(id)sender
{
    NSUserDefaults *locationPreferences = [NSUserDefaults standardUserDefaults];
    
    if(self.locationSimulationSwitch.on == YES)
    {
        [locationPreferences setBool:YES forKey:@"location_preferences"];
        #ifdef DEBUG
            NSLog(@"simulate location set to ON ");
        #endif
    }
    else
    {
        [locationPreferences setBool:NO forKey:@"location_preferences"];
        #ifdef DEBUG
            NSLog(@"simulate location set to OFF ");
        #endif
    }
    
    [locationPreferences synchronize];
}

@end
