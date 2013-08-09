//
//  GooglePlacesAPIClient.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 7/22/13.
//  Copyright (c) 2013 Test. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

// TODO: This class might need refactoring
#warning This class needs refactoring
@interface GooglePlacesAPIClient : AFHTTPClient

+(GooglePlacesAPIClient *)sharedClient;

@end
