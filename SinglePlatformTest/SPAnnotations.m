//
//  SPAnnotations.m
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 11/29/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "SPAnnotations.h"

@implementation SPAnnotations

@synthesize coordinate, title, subtitle;


-(id)init
{
    return [self initWithCoordinates:CLLocationCoordinate2DMake(43.07, -89.32) title:@"Hometown" subtitle:@"Random Place"];
}

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   title:(NSString *)paramTitle
                subtitle:(NSString *)paramSubTitle
{
    self = [super init];
    
    if(self != nil)
    {
        coordinate = paramCoordinates;
        title = paramTitle;
        subtitle = paramSubTitle;
    }
    
    return self;
}

@end
