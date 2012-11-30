//
//  SPAnnotations.m
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 11/29/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "SPAnnotations.h"

@implementation SPAnnotations

CLLocationCoordinate2D coordinate;

@synthesize coordinate, title, subtitle;

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subtitle:(NSString *)paramSubTitle
{
    self = [super init];
    
    if(self != nil)
    {
        coordinate = paramCoordinates;
        title = paramTitle;
        subtitle = paramSubTitle;
    }
    
    return(self);
}

@end
