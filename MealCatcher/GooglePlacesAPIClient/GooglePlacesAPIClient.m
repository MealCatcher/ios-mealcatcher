//
//  GooglePlacesAPIClient.m
//  MealCatcher
//
//  Created by Jorge E. Astorga on 7/22/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import "GooglePlacesAPIClient.h"
#import "AFJSONRequestOperation.h"

/*@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=sidebar+in+Oakland&sensor=false&key=AIzaSyBiDP9jVA2Tad-yvyEIm1gIi2umJRvYzUg"];*/

static NSString *const kGooglePlacesAPIBaseURLString = @"https://maps.googleapis.com/maps/api/place/textsearch/";

@implementation GooglePlacesAPIClient

+(GooglePlacesAPIClient *)sharedClient
{
    static GooglePlacesAPIClient *_sharedClient;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GooglePlacesAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kGooglePlacesAPIBaseURLString]];
    });
    
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(!self)
    {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //Accept HTTP header
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}


@end
