//
//  MCSidebarController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/11/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "MCSidebarController.h"
#import "SideBarCell.h"
#import "AccountViewController.h"
#import "SWRevealViewControllerSegue.h"
#import "MCMainSideViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MCSidebarController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation MCSidebarController


#pragma mark Custom Methods

#pragma mark Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
    
    NSString *boldFontName = @"Avenir-Black";
    NSString *fontName = @"Avenir-BlackOblique";
    
    self.profileNameLabel.textColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.profileNameLabel.font = [UIFont fontWithName:boldFontName size:14.0f];
    
    self.profileLocationLabel.textColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    self.profileLocationLabel.font = [UIFont fontWithName:fontName size:12.0f];

    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.profileImageView.layer.cornerRadius = 35.0f;
    
    PFUser *currentUser = [PFUser currentUser];
    
    if(currentUser) //Setup if user is logged in
    {
        //self.profileNameLabel.text = @"Jorge Astorga";
        //self.profileLocationLabel.text = @"Oakland, CA";
        
        PFQuery *userQuery = [PFUser query];
        PFObject *theUser = [userQuery getObjectWithId:currentUser.objectId];
        
        self.profileNameLabel.text = [theUser objectForKey:@"name"];
        self.profileLocationLabel.text = @""; //may set this to current location in the future
        
        FBSession *fbSession = [PFFacebookUtils session];
        if(fbSession)
        {
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
                    
                    [self.profileImageView setImageWithURL:pictureURL placeholderImage:nil];
                }
            }];
        }
        else
        {
            self.profileImageView.image = [UIImage imageNamed:@"face.jpg"];
        }
        
        //configure menu items
        self.menuItems = @[@"favorites", @"recommended", @"account", @"settings", @"logout"];        

    }
    else //If user is logged out
    {
        self.profileNameLabel.text = @"";
        self.profileLocationLabel.text = @"";
        self.profileImageView.image = [UIImage imageNamed:@"face.jpg"];
        
        //configure menu items
        self.menuItems = @[@"favorites", @"recommended", @"signup"];
    }
    
    /*NSDictionary* object1 = [NSDictionary dictionaryWithObjects:@[ @"Favorites", @"0", @"envelope" ] forKeys:@[ @"title", @"count", @"icon" ]];
     NSDictionary* object2 = [NSDictionary dictionaryWithObjects:@[ @"Recommended", @"7", @"check" ] forKeys:@[ @"title", @"count", @"icon" ]];
     NSDictionary* object3 = [NSDictionary dictionaryWithObjects:@[ @"SignUp", @"0", @"account" ] forKeys:@[ @"title", @"count", @"icon" ]];
     NSDictionary* object4 = [NSDictionary dictionaryWithObjects:@[ @"Settings", @"0", @"settings" ] forKeys:@[ @"title", @"count", @"icon" ]];
     NSDictionary* object5 = [NSDictionary dictionaryWithObjects:@[ @"Logout", @"0", @"arrow" ] forKeys:@[ @"title", @"count", @"icon" ]];*/
    
    //self.items = @[object1, object2, object3, object4, object5];
}

#pragma mark TableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *identifier = [cell reuseIdentifier];
   
    if([identifier isEqualToString:@"logout"])
    {
        [PFUser logOut];
        
        //configure menu items for a logged out user
        self.menuItems = @[@"favorites", @"recommended", @"signup"];
        
        //change the profile image to a generic profile image
        self.profileImageView.image = [UIImage imageNamed:@"face.jpg"];
        [self.tableView reloadData];
        
        self.profileNameLabel.text = @"";
        self.profileLocationLabel.text = @"";
        
        [self.revealViewController toggleSidebar:!self.revealViewController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SideBarCell *theCell = (SideBarCell *)cell;
    
    if([CellIdentifier isEqualToString:@"logout"])
    {
        theCell.countLabel.alpha = 0;
    }
    else if ([CellIdentifier isEqualToString:@"settings"])
    {
        theCell.countLabel.alpha = 0;
    }
    else if ([CellIdentifier isEqualToString:@"signup"])
    {
        theCell.countLabel.alpha = 0;
    }
    else if ([CellIdentifier isEqualToString:@"account"])
    {
        theCell.countLabel.alpha = 0;
    }
    else if ([CellIdentifier isEqualToString:@"recommended"])
    {
        if([PFUser currentUser])
        {
             theCell.countLabel.hidden = NO;
            
            //query all the favorites
            PFQuery *recommendedQuery = [PFQuery queryWithClassName:@"Recommendation"];
            
            //put the favorites in the array
            [recommendedQuery whereKey:@"parent" equalTo:[PFUser currentUser]];
            
            //reload the table view
            [recommendedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error)
                {
                    theCell.countLabel.text = [NSString stringWithFormat:@"%d", [objects count]];
                }
            }];

            
        }
        else
        {
            theCell.countLabel.hidden = YES;
        }
    }
    else if ([CellIdentifier isEqualToString:@"favorites"])
    {
        if([PFUser currentUser])
        {
            theCell.countLabel.hidden = NO;
            
            //query all the favorites
            PFQuery *favoritesQuery = [PFQuery queryWithClassName:@"Favorite"];
            //put the favorites in the array
            [favoritesQuery whereKey:@"parent" equalTo:[PFUser currentUser]];
            //reload the table view
            [favoritesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error)
                {
                    theCell.countLabel.text = [NSString stringWithFormat:@"%d", [objects count]];
                }
            }];

        }
        else
        {
            theCell.countLabel.hidden = YES;
        }
    }
    
    
    
    
    return cell;
}

/*-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 SideBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
 
 NSDictionary* item = self.items[indexPath.row];
 
 cell.titleLabel.text = item[@"title"];
 cell.iconImageView.image = [UIImage imageNamed:item[@"icon"]];
 
 NSString *count = item[@"count"];
 if(![count isEqualToString:@"0"])
 {
 cell.countLabel.text = count;
 }
 else
 {
 cell.countLabel.alpha = 0;
 }
 
 return cell;
 }*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}


#pragma mark Segue Methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    if([segue.identifier isEqualToString:@"showSignup"])
    {
        
    }
    else if([segue.identifier isEqualToString:@"TestSegue"])
    {
        if([segue.destinationViewController isKindOfClass:[AccountViewController class]])
        {
            
            UITableViewCell *cell = sender;
            if([cell isKindOfClass: [SideBarCell class]])
            {
                SideBarCell *myCell = sender;
            }
        }
    }
    else if ([segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        if([segue.identifier isEqualToString:@"showFavorites"])
        {
            SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
            
            swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
                
                UINavigationController *testController =  (UINavigationController *)self.revealViewController.contentViewController;
                
                [testController setViewControllers:@[dvc] animated:NO];
                [self.revealViewController toggleSidebar:!self.revealViewController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
            };
        }
        else if([segue.identifier isEqualToString:@"showRecommended"])
        {
            SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *)segue;
            
            swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc){
                UINavigationController *testController = (UINavigationController *)self.revealViewController.contentViewController;
                
                [testController setViewControllers:@[dvc] animated:NO];
                [self.revealViewController toggleSidebar:!self.revealViewController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
            };
        }
    }
}

@end
