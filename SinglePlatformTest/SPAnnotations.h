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

@interface SPAnnotations : NSObject <MKAnnotation>
{
}

@property (nonatomic, readonly)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly)NSString* title;
@property (nonatomic, copy, readonly)NSString* subtitle;

-(id)initWithCoordinates: (CLLocationCoordinate2D)paramCoordinates
                   title: (NSString *)paramTitle
                subtitle: (NSString *)paramSubTitle;

@end
