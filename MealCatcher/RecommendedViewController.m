//
//  RecommendedViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/30/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "RecommendedViewController.h"
#import "MCMainSideViewController.h"

@interface RecommendedViewController ()

@property (nonatomic, strong)NSMutableArray *recommendations;

@end

@implementation RecommendedViewController

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
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"list3"];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:menuButtonImage
                                                                 style:UIControlStateNormal
                                                                target:self.revealViewController
                                                                action:@selector(revealToggle:)];
    
    
    [self.navigationItem setLeftBarButtonItem:menuItem];
    
    self.navigationController.navigationBar.titleTextAttributes = [[NSDictionary alloc]
                                                                   initWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self setupRecommendations];
}

-(void)setupRecommendations
{
    //query all the favorites
    PFQuery *recommendedQuery = [PFQuery queryWithClassName:@"Recommendation"];
    
    //put the favorites in the array
    [recommendedQuery whereKey:@"parent" equalTo:[PFUser currentUser]];
    
    //reload the table view
    [recommendedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            self.recommendations = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.recommendations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"restaurantCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *recommendation = (PFObject *)[self.recommendations objectAtIndex:indexPath.row];
    cell.textLabel.text = [recommendation objectForKey:@"restaurant"];
    
    PFUser *recommendingUser = [recommendation objectForKey:@"recommender"];
    
    PFUser *testUser = [PFQuery getUserObjectWithId:[recommendingUser objectId]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Recommended by %@", [testUser objectForKey:@"name"]];
    
    return cell;
}

@end
