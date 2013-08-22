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

@interface MCFavoritesViewController ()

@end

@implementation MCFavoritesViewController

@synthesize drinks;

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
    Favorite *favorite1 = [[Favorite alloc] init];
    [favorite1 setName:@"Duende"];
    
    Favorite *favorite2 = [[Favorite alloc] init];
    [favorite2 setName:@"Molcajetes"];
    
    [[self favorites] addObject:favorite1];
    [[self favorites] addObject:favorite2];
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
    
    //cell.textLabel.text = [self.drinks objectAtIndex:indexPath.row];
    Favorite *myFavorite = [self.favorites objectAtIndex:indexPath.row];
    cell.textLabel.text  = [myFavorite name];
    
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

@end
