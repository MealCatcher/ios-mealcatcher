//
//  MCFavoritesViewController.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 2/28/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMainSideViewController.h"

@interface MCFavoritesViewController : UITableViewController
{
}

//@property (strong, nonatomic) NSMutableArray *favorites;
@property (strong, nonatomic) NSArray *favorites;
@property (strong, nonatomic) MCMainSideViewController *mainSideViewController;

@end
