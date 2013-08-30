//
//  MCMainSideViewController.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/9/13.
//  Copyright (c) 2013 Test. All rights reserved.
//
//  This class is the main container controller for the side view and the content view
//  that appears on top of the view.
//

#import "GHRevealViewController.h"

@interface MCMainSideViewController : GHRevealViewController <NSURLConnectionDelegate>

+(MCMainSideViewController *)sharedClient;
@end

#pragma mark MCMainSideViewController Category
@interface UIViewController (MCMainSideViewController)

- (MCMainSideViewController *)revealViewController;
-(void)revealToggle:(id)sender;

@end