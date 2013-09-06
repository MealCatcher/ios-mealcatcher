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



#pragma mark Custom Methods
-(void)revealToggle:(id)sender
{
    [super toggleSidebar:!self.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

-(IBAction)done:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[AccountViewController class]])
    {
        MCSidebarController *sideBarVC = (MCSidebarController *)self.sidebarViewController;
        
        //Remove the Signup Row
        sideBarVC.menuItems = @[@"favorites", @"recommended", @"account", @"settings", @"logout"];
        [sideBarVC.tableView reloadData];
        
        //Change the name of the user to actual name
        PFUser *currentUser = [PFUser currentUser];
        NSString *name = [currentUser objectForKey:@"name"];
        sideBarVC.profileNameLabel.text = name;
        
        //Get the profile picture
        FBRequest *request = [FBRequest requestForMe];
        
        //Send the request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error)
            {
                //result is a dictionary with the user's Facebook data
                
                NSDictionary *userData = (NSDictionary *)result;
                NSString *facebookID = userData[@"id"];
                
                NSURL *pictureURL = [NSURL URLWithString:[NSString
                                                          stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",
                                                          facebookID]];
                [sideBarVC.profileImageView setImageWithURL:pictureURL placeholderImage:nil];
            }
        }];
    }
}

/* This is a hack very likely. Don't really understand this code*/
+(MCMainSideViewController *)sharedClient
{
    static MCMainSideViewController *_sharedClient;
    return _sharedClient;
}

#pragma mark  Lifecycle Methods

/* This is a hack very likely. Don't really understand this code*/
-(id)initWithCoder:(NSCoder *)aDecoder
{
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
    
    [self performSegueWithIdentifier:@"sw_rear" sender:nil];
    [self performSegueWithIdentifier:@"sw_front" sender:nil];
}



#pragma mark Segue Methods

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
