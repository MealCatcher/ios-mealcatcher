//
//  MCSearchViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 12/20/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "MCSearchViewController.h"
#import "MCSearchResultsViewController.h"

@interface MCSearchViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultsTable;
@property (strong, nonatomic)NSMutableArray *results;

@end

@implementation MCSearchViewController

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
    
    NSLog(@"viewWillAppear got called");
    if([[self results] count] == 0)
    {
        [[self resultsTable] setHidden:YES];
    }

}

#pragma mark Search Actions

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search Button Clicked");
    [[self resultsTable] setHidden:NO];
    
    [[self results] addObject:@"Test 1"];
    [[self results] addObject:@"Test 2"];
    [[self resultsTable] reloadData];
    
    /*MCSearchResultsViewController *searchResultsVC = [[MCSearchResultsViewController alloc]init];

    [self.navigationController pushViewController:searchResultsVC animated:YES];*/
}

-(void)setupFont
{
    //testLabel.text = @"Setting Bira!";
    //[testLabel setFont:[UIFont fontWithName:@"Bira PERSONAL USE ONLY" size:24.0]];
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
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
    
    cell.textLabel.text = @"Jorge";
    
    return cell;
}


@end
