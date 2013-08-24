//
//  MCMainSideViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/9/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "MCMainSideViewController.h"

@interface MCMainSideViewController ()

@end

@implementation MCMainSideViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UIViewController *frontController = [mainStoryboard instantiateViewControllerWithIdentifier:@"FavoritesController"];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 20)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];

    frontController.navigationItem.leftBarButtonItem = menuItem;
    
    UIViewController *rearController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SidebarMenuController"];
    
    frontController.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:frontController];
    
    nav.navigationBar.barTintColor = [UIColor colorWithRed:(203/255.0)
                                                     green:(59/255.0)
                                                      blue:(29/255.0) alpha:1];
    
    nav.navigationBar.titleTextAttributes = [[NSDictionary alloc]
                                             initWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    self.contentViewController = nav;
    self.sidebarViewController = rearController;
}

-(void)revealToggle:(id)sender
{
    [super toggleSidebar:!self.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}


@end
