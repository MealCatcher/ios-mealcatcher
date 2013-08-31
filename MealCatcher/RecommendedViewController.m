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
    //self.mainSideViewController = [MCMainSideViewController sharedClient];
    
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
    
    [self setupRecommendations];
    
    
}

-(void)setupRecommendations
{
    NSLog(@"Setting up recommendations");
    
    //query all the favorites
    PFQuery *recommendedQuery = [PFQuery queryWithClassName:@"Recommendation"];
    //put the favorites in the array
    [recommendedQuery whereKey:@"parent" equalTo:[PFUser currentUser]];
    //reload the table view
    [recommendedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            NSLog(@"Got the recommendations");
            self.recommendations = [objects mutableCopy];
            NSLog(@"Recommendations Count: %d", [self.recommendations count]);
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
    if(recommendingUser)
    {
        NSLog(@"Recommending User: %@", recommendingUser);
        NSLog(@"Recommender ID: %@", [recommendingUser objectId]);
        
    }
    
    PFUser *testUser = [PFQuery getUserObjectWithId:[recommendingUser objectId]];
    NSLog(@"Recommending User Name: %@", [testUser objectForKey:@"name"]);
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Recommended by %@", [testUser objectForKey:@"name"]];
    
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
