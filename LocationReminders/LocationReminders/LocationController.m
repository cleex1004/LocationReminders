//
//  LocationController.m
//  LocationReminders
//
//  Created by Christina Lee on 5/2/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "LocationController.h"

@interface LocationController() <CLLocationManagerDelegate>

@end

@implementation LocationController

+(instancetype)shared {
    static LocationController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc]init];
    });
    
    return shared;
}

-(instancetype)init{
    self = [super init];
    
    if (self) {
        _locationManager = [[CLLocationManager alloc]init];
        _location = [[CLLocation alloc]init];
        _delegate = self;
    }
    return self;
}

@end


