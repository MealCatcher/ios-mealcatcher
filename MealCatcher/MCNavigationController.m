//
//  MCNavigationController.m
//  MealCatcher
//
//  Created by Jorge Astorga on 9/5/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "MCNavigationController.h"

@interface MCNavigationController ()

@end

@implementation MCNavigationController

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
	
    //self.navigationBar.barTintColor
    //self.navigationBar.barTintColor = [UIColor colorWithRed:(203/255.0) green:(59/255.0) blue:(29/255.0) alpha:1];
    self.navigationBar.barTintColor = [UIColor colorWithRed:(92/255.0) green:(193/255.0) blue:(173/255.0) alpha:1];
    
    //self.navigationBar.barTintColor = [UIColor redColor];
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
