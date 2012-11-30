//
//  SPAnnotations.h
//  SinglePlatformTest
//
//  Created by Jorge E. Astorga on 11/29/12.
//  Copyright (c) 2012 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SPAnnotations : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly)CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly)NSString* title;
@property (nonatomic, readonly)NSString* subtitle;

-(id)initWithCoordinates: (CLLocationCoordinate2D)paramCoordinates
                   title: (NSString *)paramTitle
                subtitle: (NSString *)paramSubTitle;

@end
