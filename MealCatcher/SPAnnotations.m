//
//  SPAnnotations.m
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 11/29/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import "SPAnnotations.h"

@implementation SPAnnotations

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize pinColor;


+(NSString *)reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor
{
    NSString *result = nil;
    
    switch (paramColor) {
        case MKPinAnnotationColorRed:{
            result = REUSABLE_PIN_RED;
            break;
        }
        case MKPinAnnotationColorGreen:{
            result = REUSABLE_PIN_GREEN;
            break;
        }
        case MKPinAnnotationColorPurple:{
            result = REUSABLE_PIN_PURPLE;
            break;
        }
    }
    return result;
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
        pinColor = MKPinAnnotationColorGreen;
    }
    
    return self;
}

@end
