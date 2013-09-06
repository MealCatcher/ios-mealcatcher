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
#warning This needs to be set depending if the user is logged in or not
    self.profileNameLabel.text = @"Jorge Astorga";
    
    self.profileLocationLabel.textColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    self.profileLocationLabel.font = [UIFont fontWithName:fontName size:12.0f];
#warning This needs to be set depending if the user is logged in or not
    self.profileLocationLabel.text = @"Oakland, CA";

#warning This needs to be set depending if the user is logged in or not
    self.profileImageView.image = [UIImage imageNamed:@"face.jpg"];
    
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.profileImageView.layer.cornerRadius = 35.0f;
    
    /*NSDictionary* object1 = [NSDictionary dictionaryWithObjects:@[ @"Favorites", @"0", @"envelope" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object2 = [NSDictionary dictionaryWithObjects:@[ @"Recommended", @"7", @"check" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object3 = [NSDictionary dictionaryWithObjects:@[ @"SignUp", @"0", @"account" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object4 = [NSDictionary dictionaryWithObjects:@[ @"Settings", @"0", @"settings" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object5 = [NSDictionary dictionaryWithObjects:@[ @"Logout", @"0", @"arrow" ] forKeys:@[ @"title", @"count", @"icon" ]];*/
    
    //self.items = @[object1, object2, object3, object4, object5];
    
    BOOL loggedIn = NO;
    
    if(loggedIn == YES)
    {
        self.menuItems = @[@"favorites", @"recommended", @"account", @"settings", @"logout"];
    }
    else
    {
        self.menuItems = @[@"favorites", @"recommended", @"signup", @"settings", @"logout"];
    }
    
}

#pragma mark TableView Delegate Methods

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

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
        NSLog(@"TestSegue got called");
        if([segue.destinationViewController isKindOfClass:[AccountViewController class]])
        {
            
            UITableViewCell *cell = sender;
            if([cell isKindOfClass: [SideBarCell class]])
            {
                SideBarCell *myCell = sender;
                NSLog(@"The cell is a SideBarCell");
                NSLog(@"Cell Tapped: %@", myCell.titleLabel);
            }
        }
    }
    else if ([segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        if([segue.identifier isEqualToString:@"showFavorites"])
        {
            NSLog(@"I am going to show favorites now");
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
