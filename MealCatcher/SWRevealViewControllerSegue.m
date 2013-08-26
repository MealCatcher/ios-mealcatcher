//
//  SWRevealViewControllerSegue.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/25/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "SWRevealViewControllerSegue.h"

@implementation SWRevealViewControllerSegue

- (void)perform
{
    if ( _performBlock != nil )
    {
        _performBlock( self, self.sourceViewController, self.destinationViewController );
    }
}

@end
