//
//  MCSidebarController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/11/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "MCSidebarController.h"
#import "SideBarCell.h"
#import "SignupViewController.h"
#import "SWRevealViewControllerSegue.h"

@interface MCSidebarController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation MCSidebarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Isn't this set in the StoryBoard?
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.view.backgroundColor = [UIColor colorWithRed:209/255.0 green:78/255.0 blue:51/255.0 alpha:1.0];
    //self.view.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:209/255.0 alpha:1.0];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.tableView.backgroundColor = [UIColor colorWithRed:209/255.0 green:78/255.0 blue:51/255.0 alpha:1.0];
    //self.tableView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:209/255.0 alpha:1.0];
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    
    NSString *boldFontName = @"Avenir-Black";
    NSString *fontName = @"Avenir-BlackOblique";
    
    self.profileNameLabel.textColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.profileNameLabel.font = [UIFont fontWithName:boldFontName size:14.0f];
    self.profileNameLabel.text = @"Jorge Astorga";
    
    self.profileLocationLabel.textColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    self.profileLocationLabel.font = [UIFont fontWithName:fontName size:12.0f];
    self.profileLocationLabel.text = @"Oakland, CA";
    
    //self.profileImageView.image = [UIImage imageNamed:@"profile_jorge.jpg"];
    self.profileImageView.image = [UIImage imageNamed:@"profile.jpg"];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.profileImageView.layer.cornerRadius = 35.0f;
    
    NSDictionary* object1 = [NSDictionary dictionaryWithObjects:@[ @"Favorites", @"0", @"envelope" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object2 = [NSDictionary dictionaryWithObjects:@[ @"Recommended", @"7", @"check" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object3 = [NSDictionary dictionaryWithObjects:@[ @"SignUp", @"0", @"account" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object4 = [NSDictionary dictionaryWithObjects:@[ @"Settings", @"0", @"settings" ] forKeys:@[ @"title", @"count", @"icon" ]];
    NSDictionary* object5 = [NSDictionary dictionaryWithObjects:@[ @"Logout", @"0", @"arrow" ] forKeys:@[ @"title", @"count", @"icon" ]];
    
    self.items = @[object1, object2, object3, object4, object5];
    
    self.menuItems = @[@"favorites", @"recommended", @"signup", @"settings", @"logout"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.items count];
    return [self.menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Just selected a row from the table");
}


//TODO: Look at the sidebar menu. We need to get the UINAvigationControl
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    if([segue.identifier isEqualToString:@"showSignup"])
    {
        NSLog(@"showing the signup screen");
        
    }
    else if([segue.identifier isEqualToString:@"TestSegue"])
    {
        if([segue.destinationViewController isKindOfClass:[SignupViewController class]])
        {
            SignupViewController *signUpViewController = segue.destinationViewController;
            //detailsViewController.delegate = self;
            
            UITableViewCell *cell = sender;
            if([cell isKindOfClass: [SideBarCell class]])
            {
                SideBarCell *myCell = sender;
                NSLog(@"The cell is a SideBarCell");
                NSLog(@"Cell Tapped: %@", myCell.titleLabel);
            }
            NSIndexPath *pathOfCell = [self.tableView indexPathForCell:cell];
            NSInteger rowOfTheCell = [pathOfCell row];
            
        }
    }
    else if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            //TODO: Look at the sidebar menu. We need to get the UINAvigationControl
            /*UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];*/
        };
        
    }

}

@end
