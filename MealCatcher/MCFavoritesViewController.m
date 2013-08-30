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
    
    NSLog(@"Favorites Count: %d", [self.favorites count]);
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
        NSLog(@"Favorites does not exist. Creating it now!");
        _favorites = [[NSMutableArray alloc] init];
    }
    return _favorites;
}

/* Ideally this data would be loaded from core data or some remote store
 *
 */
-(void)setupFavorites
{
    //query all the favorites
    PFQuery *favoritesQuery = [PFQuery queryWithClassName:@"Favorite"];
    //put the favorites in the array
    [favoritesQuery whereKey:@"parent" equalTo:[PFUser currentUser]];
    //reload the table view
    [favoritesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            NSLog(@"Got the favorites");
            self.favorites = [objects mutableCopy];
            NSLog(@"Favorites Count: %d", [self.favorites count]);
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add the plus uibar button item
    /*UIBarButtonItem* addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRestaurant)];
    self.navigationItem.rightBarButtonItem = addButton;*/

    //Create the restaurant array (temp data source)
    //self.drinks = [[NSMutableArray alloc] initWithObjects:@"Duende", @"HomeRoom",@"Lin Jia's", @"Boot & Shoe", nil];
    [self setupFavorites];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"list3"];
    self.mainSideViewController = [MCMainSideViewController sharedClient];
    
    //testing the category

    
    /*UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:menuButtonImage
                                                                 style:UIControlStateNormal
                                                                target:self.mainSideViewController
                                                                action:@selector(revealToggle:)];*/
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:menuButtonImage
                                                                 style:UIControlStateNormal
                                                                target:self.revealViewController
                                                                action:@selector(revealToggle:)];
    
    
    [self.navigationItem setLeftBarButtonItem:menuItem];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(203/255.0)
                                                     green:(59/255.0)
                                                      blue:(29/255.0) alpha:1];
    
    self.navigationController.navigationBar.titleTextAttributes = [[NSDictionary alloc]
                                             initWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
}

#pragma mark - Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.favorites.count;
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(IBAction)savedFavorite:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[DetailsViewController class]])
    {
        [self setupFavorites];
    }
    
    
}

@end
