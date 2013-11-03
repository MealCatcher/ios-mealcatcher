//
//  RecommendedViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/30/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "RecommendedViewController.h"
#import "MCMainSideViewController.h"
#import "DetailsViewController.h"

@interface RecommendedViewController ()

@property (nonatomic, strong)NSMutableArray *recommendations;

@end

@implementation RecommendedViewController

#pragma mark Custom Methods
-(void)setupRecommendations
{
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser)
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
}

#pragma mark Lifecycle Methods

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChange:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

-(void)preferredContentSizeChange:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Data Source Methods

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[DetailsViewController class]])
    {
        UITableViewCell *placeCell = (UITableViewCell *)sender;
        NSInteger *row = [[self.tableView indexPathForCell:placeCell] row];
        PFObject *place = [self.recommendations objectAtIndex:row];
        
        DetailsViewController *dvc = (DetailsViewController *)segue.destinationViewController;
        dvc.restaurantID = [place objectForKey:@"restaurant_id"];
    }
}

@end
