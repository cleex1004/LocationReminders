//
//  LocationController.h
//  LocationReminders
//
//  Created by Christina Lee on 5/2/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import "LocationControllerDelegate.h"

@interface LocationController : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) id <LocationControllerDelegate> delegate;

+(instancetype)shared;

-(void)requestPermissions;

-(void)startMonitoringForRegion:(CLRegion *)region;

@end

