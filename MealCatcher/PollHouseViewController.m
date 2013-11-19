//
//  PollHouseViewController.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 11/18/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "PollHouseViewController.h"
#import "MCMainSideViewController.h"



@interface PollHouseViewController ()

@property (nonatomic, strong)NSMutableArray *pollHouses;

@end

@implementation PollHouseViewController

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
    
    //test setting the poll
    //[self setupPoll];
    [self setupPollHouses];
    
}

-(void)setupPollHouses
{
    PFQuery *pollHouseQuery = [PFQuery queryWithClassName:@"PollHouse"];
    [pollHouseQuery whereKey:@"poller" equalTo:[PFUser currentUser]];
    [pollHouseQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
        {
            
            NSLog(@"There was an error getting the poll houses: %@", [error description]);
            
        }
        else
        {
            NSLog(@"Got the polls successfully");
            self.pollHouses = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

-(void)setupPoll
{
    PFObject *newPollHouse = [PFObject objectWithClassName:@"PollHouse"];
    [newPollHouse setObject:[PFUser currentUser] forKey:@"poller"];
    [newPollHouse setObject:[NSDate date] forKey:@"endTime"];
    [newPollHouse setObject:@"Open" forKey:@"status"];
    
    [newPollHouse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
        {
            NSLog(@"There was an error saving the poll: %@", [error description]);
        }
        else
        {
            NSLog(@"Saved the polls successfull");
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
    return [self.pollHouses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pollHouseCelll";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *pollHouse = [self.pollHouses objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [pollHouse objectForKey:@"status"];
    
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
