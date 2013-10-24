//
//  MCFavoritesViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 2/28/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "MCFavoritesViewController.h"
#import "MCSearchViewController.h"
#import "Favorite.h"
#import "MCMainSideViewController.h"
#import "DetailsViewController.h"

@interface MCFavoritesViewController ()
@end

@implementation MCFavoritesViewController

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *deleteFavorite = [self.favorites objectAtIndex:indexPath.row];
    [deleteFavorite deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error)
        {
            //Remove the row from data model
            [self.favorites removeObjectAtIndex:indexPath.row];
            
            //Request table view to reload
            [self.tableView reloadData];
        }
    }];
}

-(NSMutableArray *)favorites
{
    if(!_favorites)
    {
        _favorites = [[NSMutableArray alloc] init];
    }
    return _favorites;
}

/*
 *
 */
-(void)setupFavorites
{
    if([PFUser currentUser])
    {
        //query all the favorites
        PFQuery *favoritesQuery = [PFQuery queryWithClassName:@"Favorite"];
        //put the favorites in the array
        [favoritesQuery whereKey:@"parent" equalTo:[PFUser currentUser]];
        //Sort results by name
        [favoritesQuery orderByAscending:@"restaurant"];
        //reload the table view
        [favoritesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error)
            {
                self.favorites = [objects mutableCopy];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupFavorites];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"list3"];
    self.mainSideViewController = [MCMainSideViewController sharedClient];

    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:menuButtonImage
                                                                 style:UIControlStateNormal
                                                                target:self.revealViewController
                                                                action:@selector(revealToggle:)];
    
    [self.navigationItem setLeftBarButtonItem:menuItem];
    
    self.navigationController.navigationBar.titleTextAttributes = [[NSDictionary alloc]
                                             initWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
}

#pragma mark - Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.favorites.count;
}

/** Used to modify the cell properties such as font and color */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.font = [UIFont fontWithName:@"Raleway-Thin" size:20.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"restaurantCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PFObject *myFavorite = [self.favorites objectAtIndex:indexPath.row];
    cell.textLabel.text  = [myFavorite objectForKey:@"restaurant"];
    
    return cell;
}

-(IBAction)savedFavorite:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[DetailsViewController class]])
    {
        [self setupFavorites];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"FavoriteDetailsSegue"])
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        PFObject *favorite = [self.favorites objectAtIndex:ip.row];
        DetailsViewController *dvc = (DetailsViewController *)segue.destinationViewController;
        [dvc setRestaurantID:[favorite objectForKey:@"restaurant_id"]];
    }
}

@end
