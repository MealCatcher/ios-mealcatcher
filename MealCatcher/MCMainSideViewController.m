//
//  MCMainSideViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/9/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "MCMainSideViewController.h"
#import "SWRevealViewControllerSegue.h"
#import "MCFavoritesViewController.h"
#import "AccountViewController.h"
#import "MCSidebarController.h"
#import "UIImageView+AFNetworking.h"

@interface MCMainSideViewController ()

@end

@implementation MCMainSideViewController

/* This is a hack very likely. Don't really understand this code*/
+(MCMainSideViewController *)sharedClient
{
    static MCMainSideViewController *_sharedClient;
    return _sharedClient;
}

/* This is a hack very likely. Don't really understand this code*/
-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"init with coder got called");
    self = [super initWithCoder:aDecoder];
    
    static MCMainSideViewController *_sharedClient;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MCMainSideViewController alloc] init];
    });
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    //UIViewController *frontController = [mainStoryboard instantiateViewControllerWithIdentifier:@"FavoritesController"];
    
    /*UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 20)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    [menuButton setBackgroundImage:[UIImage imageNamed:@"sidebar_menu"] forState:UIControlStateNormal];
    [menuButton setTintColor:[UIColor whiteColor]];
    [menuButton addTarget:self action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setAlpha:0.5f];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];

    frontController.navigationItem.leftBarButtonItem = menuItem;*/
    
    //UIImage *menuButtonImage = [UIImage imageNamed:@"sidebar_menu" ];
    //UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:menuButtonImage style:UIControlStateNormal target:self action:@selector(revealToggle:)];
    //frontController.navigationItem.leftBarButtonItem = menuItem;
    
    //UIViewController *rearController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SidebarMenuController"];
    
    //frontController.view.backgroundColor = [UIColor whiteColor];
    
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:frontController];
    
    /*nav.navigationBar.barTintColor = [UIColor colorWithRed:(203/255.0)
                                                     green:(59/255.0)
                                                      blue:(29/255.0) alpha:1];*/
    
    /*nav.navigationBar.titleTextAttributes = [[NSDictionary alloc]
                                             initWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];*/
    
    [self performSegueWithIdentifier:@"sw_rear" sender:nil];
    [self performSegueWithIdentifier:@"sw_front" sender:nil];
    
    //self.contentViewController = nav;
    //self.sidebarViewController = rearController;
    
    
}

-(void)revealToggle:(id)sender
{
    NSLog(@"reveal toggle got called");
    [super toggleSidebar:!self.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

-(IBAction)done:(UIStoryboardSegue *)segue
{
    //get the results out of the vc
    NSLog(@"Done got called");
    UIViewController *vc = segue.sourceViewController;
    NSLog(@"Segue View Controller: %@", [vc class]);
    
    if([segue.sourceViewController isKindOfClass:[AccountViewController class]])
    {
        NSLog(@"Just came back from AccountViewController - signed up via Facebook");
        MCSidebarController *sideBarVC = (MCSidebarController *)self.sidebarViewController;
        
        //Remove the Signup Row
        sideBarVC.menuItems = @[@"favorites", @"recommended", @"account", @"settings", @"logout"];
        [sideBarVC.tableView reloadData];
        
        //Change the name of the user to actual name
        PFUser *currentUser = [PFUser currentUser];
        NSString *name = [currentUser objectForKey:@"name"];
        sideBarVC.profileNameLabel.text = name;
        NSLog(@"The name: %@", name);
        
        //Get the profile picture
        FBRequest *request = [FBRequest requestForMe];
        
        //Send the request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error)
            {
                //result is a dictionary with the user's Facebook data
                
                NSDictionary *userData = (NSDictionary *)result;
                NSString *facebookID = userData[@"id"];
                NSLog(@"Facebook ID: %@", facebookID);
                
                NSURL *pictureURL = [NSURL URLWithString:[NSString
                                                          stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",
                                                          facebookID]];
                
                [sideBarVC.profileImageView setImageWithURL:pictureURL placeholderImage:nil];
            }
        }];
    }
}

-(void)prepareForSegue:(SWRevealViewControllerSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    if ( [segue isKindOfClass:[SWRevealViewControllerSegue class]] && sender == nil )
    {
        if ( [identifier isEqualToString:@"sw_rear"] )
        {
            segue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
            {
                [self setSidebarViewController:dvc];
            };
        }
        else if ( [identifier isEqualToString:@"sw_front"] )
        {
            segue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
            {
                [self setContentViewController:dvc];
            };
        }
    }
}

@end

#pragma mark MCMainSideViewController Category
@implementation UIViewController (MCMainSideViewController)


-(MCMainSideViewController *)revealViewController
{
    UIViewController *parent = self;
    Class revealClass = [MCMainSideViewController class];
    
    while(nil != (parent = [parent parentViewController]) && ![parent isKindOfClass:revealClass])
    {
        
    }
    
    return (id)parent;
}

@end
