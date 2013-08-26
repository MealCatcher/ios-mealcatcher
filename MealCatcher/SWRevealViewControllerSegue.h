//
//  SWRevealViewControllerSegue.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/25/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWRevealViewControllerSegue : UIStoryboardSegue

@property (strong) void(^performBlock)( SWRevealViewControllerSegue* segue, UIViewController* svc, UIViewController* dvc );

@end
