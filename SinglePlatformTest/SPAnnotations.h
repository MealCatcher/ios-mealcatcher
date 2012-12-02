//
//  SPAnnotations.h
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 11/29/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

/* These are the standard SDK pin colors. We are setting unique identifiersd per color for  
    each pin so that later we can reuse pints have already been created with the same color
 */

#define REUSABLE_PIN_RED @"Red"
#define REUSABLE_PIN_GREEN @"Green"
#define REUSABLE_PIN_PURPLE @"Purple"

@interface SPAnnotations : NSObject <MKAnnotation>
{
}

@property (nonatomic,unsafe_unretained,readonly)CLLocationCoordinate2D coordinate;
//@property (nonatomic, copy, readonly)NSString* title;
//@property (nonatomic, copy, readonly)NSString* subtitle;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subtitle;

@property (nonatomic, unsafe_unretained) MKPinAnnotationColor pinColor;

-(id)initWithCoordinates: (CLLocationCoordinate2D)paramCoordinates
                   title: (NSString *)paramTitle
                subtitle: (NSString *)paramSubTitle;

+(NSString *)reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor;

@end
