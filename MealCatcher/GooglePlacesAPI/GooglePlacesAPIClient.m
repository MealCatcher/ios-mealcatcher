//
//  GooglePlacesAPIClient.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 7/22/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "GooglePlacesAPIClient.h"
#import "AFJSONRequestOperation.h"

https://maps.googleapis.com/maps/api/place/textsearch/json?query=sidebar+in+Oakland&sensor=false&key=AIzaSyBiDP9jVA2Tad-yvyEIm1gIi2umJRvYzUg

static NSString * const GooglePlacesAPIBaseURLString = @"https://maps.googleapis.com/maps/api/place/textsearch/json?";

@implementation GooglePlacesAPIClient

+(GooglePlacesAPIClient)sharedClient
{
    static GooglePlacesAPIClient *_sharedClient;
    
}

@end
