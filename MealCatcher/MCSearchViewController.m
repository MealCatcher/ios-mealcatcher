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

@end

@implementation MCSearchViewController

@synthesize testLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self removeTitleImage];
    
    //[self.navigationController setNavigationBarHidden:YES];
    

    testLabel.text = @"Setting Bira!";
    [testLabel setFont:[UIFont fontWithName:@"Bira PERSONAL USE ONLY" size:24.0]];
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
}


#pragma mark Custom Methods

//-(void)removeTitleImage
//{
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    if(nil == navBar)
//    {
//        NSLog(@"nav bar is nil");
//    }
//    else
//    {
//        NSLog(@"nav bar is not nil");
//    }
//    
//    NSLog(@"UINavigationItems: %d", navBar.items.count);
//}

#pragma mark Search Actions

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search Button Clicked");
    
    MCSearchResultsViewController *searchResultsVC = [[MCSearchResultsViewController alloc]init];

    [self.navigationController pushViewController:searchResultsVC animated:YES];
}


@end
