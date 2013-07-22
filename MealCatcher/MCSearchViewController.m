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

@end

@implementation MCSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Search Actions

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search Button Clicked");
    
    MCSearchResultsViewController *searchResultsVC = [[MCSearchResultsViewController alloc]init];

    [self.navigationController pushViewController:searchResultsVC animated:YES];
}

-(void)setupFont
{
    //testLabel.text = @"Setting Bira!";
    //[testLabel setFont:[UIFont fontWithName:@"Bira PERSONAL USE ONLY" size:24.0]];
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
}


@end
