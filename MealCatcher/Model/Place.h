//
//  Place.h
//  MealCatcher
//
//  Created by Jorge E. Astorga on 8/18/13.
//  Copyright (c) 2013 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject
{
    
}

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *id;
@property (nonatomic) NSUInteger rating;
@property (strong, nonatomic) NSString *reference;


@end
