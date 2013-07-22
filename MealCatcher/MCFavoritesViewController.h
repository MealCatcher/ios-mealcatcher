//
//  MCFavoritesViewController.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 2/28/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCFavoritesViewController : UITableViewController
{
    NSMutableArray *drinks;
}

@property (nonatomic, retain) NSMutableArray *drinks;
@property (strong, nonatomic) NSMutableArray *favorites;

@end
