//
//  MCSearchViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 12/20/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "MCSearchViewController.h"
#import "AFJSONRequestOperation.h"
#import "GooglePlacesAPIClient.h"
#import "Place.h"

@interface MCSearchViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultsTable;
@property (strong, nonatomic) NSMutableArray *results;
@property (weak, nonatomic) IBOutlet UIView *modalBlock;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MCSearchViewController

#define GOOGLE_API_KEY @"AIzaSyBiDP9jVA2Tad-yvyEIm1gIi2umJRvYzUg"


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"DetailsViewSegue"])
    {
        if([segue.destinationViewController isKindOfClass:[DetailsViewController class]])
        {
            DetailsViewController *detailsViewController = segue.destinationViewController;
            //detailsViewController.delegate = self;

            UITableViewCell *cell = sender;
            NSIndexPath *pathOfCell = [self.tableView indexPathForCell:cell];
            NSInteger rowOfTheCell = [pathOfCell row];
            NSLog(@"Index of cell: %d", rowOfTheCell);
            
            Place *place = self.results[rowOfTheCell];
            detailsViewController.restaurantID = place.reference;            
        }
    }
}

-(NSMutableArray *)results
{
    if(!_results)
    {
        _results = [[NSMutableArray alloc] init];
    }
    return  _results;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[self results] count] == 0)
    {
        [[self resultsTable] setHidden:YES];
    }
}

#pragma mark Search Actions

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [[self resultsTable] setHidden:NO];    
    [self callGooglePlaces];

    
#warning testing removing all objects
    [self.results removeAllObjects];
    [[self resultsTable] reloadData];
}

// TODO: The methods to call the Google API need to be refactored and finished
#warning This method needs refactoring
/* This method will call the Google Places API */
-(void)callGooglePlaces
{
    NSString *searchTerm = [self.searchBar text];
    GooglePlacesAPIClient *gpClient = [GooglePlacesAPIClient sharedClient];
    
    if(!gpClient)
    {
        NSLog(@"could not create the client");
    }
    else
    {
        NSDictionary *parameters =  [[NSDictionary alloc] initWithObjectsAndKeys:searchTerm,
                                     @"query",
                                     GOOGLE_API_KEY,
                                     @"key",
                                     @"false",
                                     @"sensor",nil];
        
        [gpClient getPath:@"textsearch/json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Here are the results: %@", responseObject);
            
            NSMutableDictionary *results = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            
            NSArray *keys = [results allKeys];
            for (int i = 0; i < [keys count]; i++) {
                NSLog(@"Key Name: %@", keys[i]);
            }
            
            NSArray *internalResults = [results objectForKey:@"results"];
          
            for(int i = 0; i < internalResults.count; i++)
            {
                NSDictionary *item = internalResults[i];
                Place *newPlace = [[Place alloc] init];
                newPlace.address = [item objectForKey:@"formatted_address"];
                newPlace.name = [item objectForKey:@"name"];
                newPlace.reference = [item objectForKey:@"reference"];
                [self.results addObject:newPlace];
            }
            
            [[self resultsTable] reloadData];
            [self.searchBar resignFirstResponder];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Description: %@", [gpClient description]);
            NSLog(@"Error: %@", [error localizedDescription]);
            NSLog(@"Request: %@",[[operation request] description]);
        }];
    }
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self results] count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"restaurantCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(self.results.count == 0)
    {
        cell.textLabel.text = @"Jorge";
    }
    else
    {
        Place *resultPlace = self.results[indexPath.row];
        cell.textLabel.text = resultPlace.name;
        cell.detailTextLabel.text = resultPlace.address;
    }
    
    return cell;
}


@end
