//
//  GooglePlacesAPIClient.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 7/22/13.
//  Copyright (c) 2013 Test. All rights reserved.
//
//

#import <Foundation/Foundation.h>
//#import "AFHTTPClient.h"

//@interface GooglePlacesAPIClient : AFHTTPClient
@interface GooglePlacesAPIClient : NSObject

+(GooglePlacesAPIClient *)sharedClient;

@end
