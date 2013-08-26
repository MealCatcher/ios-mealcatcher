//
//  MCSidebarController.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/11/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "GHRevealViewController.h"

@interface MCSidebarController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItems;
@end
