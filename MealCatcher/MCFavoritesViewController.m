//
//  MCFavoritesViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 2/28/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "MCFavoritesViewController.h"
#import "MCSearchViewController.h"

@interface MCFavoritesViewController ()

@end

@implementation MCFavoritesViewController

@synthesize drinks;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //Add the title image
   // [self addTitleImage];
    //[self addSampleTitleImage];
    // [self changeNavigationTitleFont];
    //self.title = @"Meal Catcher";
    [self addLabelTitle];
    
    // Add the plus uibar button item
    UIBarButtonItem* addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRestaurant)];
    self.navigationItem.rightBarButtonItem = addButton;
    
#warning Don't forget to replace this data source with either Core Data or cloud storage
    //Create the restaurant array (temp data source)
    self.drinks = [[NSMutableArray alloc] initWithObjects:@"Duende", @"HomeRoom",@"Lin Jia's", @"Boot & Shoe", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return self.drinks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.drinks objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

#pragma mark - Custom Methods


/* new method to test the title view */
-(void)changeNavigationTitleFont
{
    
    /*[[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                           UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], UITextAttributeFont, nil]];*/
    
    //[[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Bira PERSONAL USE ONLY" size:26], UITextAttributeFont, nil]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Bira PERSONAL USE ONLY" size:26], UITextAttributeFont, nil]];
    
    
    CGFloat verticalOffset = +6;
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];


}

/* new method to test the title view */
-(void)addSampleTitleImage
{
    
    //Set the image on the navigation item
    UIImage *image = [UIImage imageNamed:@"text.png"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.titleView = imageView;
 
}

/* new method to test the title view */
-(void)addLabelTitle
{
    NSString *titleText = @"Meal catcher";
    UIFont* titleFont = [UIFont fontWithName:@"Bira PERSONAL USE ONLY" size:30.0];
    CGSize requestedTitleSize = [titleText sizeWithFont:titleFont];
    CGFloat titleWidth = MIN(320.0f, requestedTitleSize.width);
    
    NSLog(@"Requested title size height: %f", requestedTitleSize.height);
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, requestedTitleSize.width, 50.0f)];
    NSLog(@"frame size height: %f", navLabel.frame.size.height);
    NSLog(@"bounds size height: %f", navLabel.bounds.size.height);
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    
    navLabel.font = [UIFont fontWithName:@"Bira PERSONAL USE ONLY" size:30];
    //navLabel.textAlignment = UITextAlignmentCenter;
    navLabel.text = titleText;
    //[navLabel sizeToFit];
    //.adjustsFontSizeToFitWidth = FALSE;
    self.navigationItem.titleView = navLabel;
//[navLabel sizeToFit];
    
    
    NSLog(@"Width: %f", self.navigationItem.titleView.bounds.size.width);
    NSLog(@"Height: %f", self.navigationItem.titleView.bounds.size.height);
    
    
    
    //CGFloat verticalOffset = +6;
    //[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    
}


/* This selector adds the title image to the main home view */
-(void)addTitleImage
{
    //Set the image on the navigation item
    UIImage *image = [UIImage imageNamed:@"text.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    
    imageView.frame = self.navigationController.navigationBar.frame;
    
    imageView.tag = 1001;
    [self.navigationController.view addSubview:imageView];
    
    
    NSLog(@"Width: %f", self.navigationItem.titleView.bounds.size.width);
    NSLog(@"Height: %f", self.navigationItem.titleView.bounds.size.height);
    
    NSLog(@"Width: %f", imageView.bounds.size.width);
    NSLog(@"Height: %f",imageView.bounds.size.height);
}

/*
 * Method that brings up the view to search for a restaurant
 */
- (void)addRestaurant
{
    NSLog(@"Adding restaurant button called");
    
    MCSearchViewController *searchViewController =
    [[MCSearchViewController alloc] initWithNibName:@"MCSearchViewController" bundle:Nil];
    
    [self.navigationController pushViewController:searchViewController animated:YES];
}


@end
