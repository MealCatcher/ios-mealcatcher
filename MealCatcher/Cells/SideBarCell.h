//
//  SideBarCell.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/15/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIView *topSeparator;
@property (nonatomic, weak) IBOutlet UIView *bottomSeparator;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;



@end
