//
//  SettingsViewController.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 1/18/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
{
    IBOutlet UISwitch *locationSimulationSwitch;
}

@property (nonatomic, strong) UISwitch *locationSimulationSwitch;
-(IBAction)saveSimulateLocation:(id)sender;

@end
