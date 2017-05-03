//
//  LocationController.m
//  LocationReminders
//
//  Created by Christina Lee on 5/2/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "LocationController.h"
@import MapKit;
@import CoreLocation;

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
        [self requestPermissions];
    }
    return self;
}

-(void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = 100;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    self.location = locations.lastObject;
    
    NSLog(@"Coordinate: %f, %f - Altitude: %f", self.location.coordinate.latitude, self.location.coordinate.longitude, self.location.altitude);
    [self.delegate locationControllerUpdatedLocation:self.location];
}


@end


