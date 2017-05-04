//
//  LocationController.m
//  LocationReminders
//
//  Created by Christina Lee on 5/2/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "LocationController.h"
//@import MapKit;
@import CoreLocation;
@import UserNotifications;

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
    self.locationManager.distanceFilter = 100; //meters
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    self.location = locations.lastObject;
    
    NSLog(@"Coordinate: %f, %f - Altitude: %f", self.location.coordinate.latitude, self.location.coordinate.longitude, self.location.altitude);
    [self.delegate locationControllerUpdatedLocation:self.location];
}

-(void)startMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startMonitoringForRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"We have successfully started monitoring changed for region: %@", region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"User DID ENTER Region: %@", region.identifier);
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"Reminder!";
    content.body = [NSString stringWithFormat:@"%@", region.identifier];
    content.sound = [UNNotificationSound defaultSound];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Location Entered" content:content trigger:trigger];
    
    UNUserNotificationCenter *current = [UNUserNotificationCenter currentNotificationCenter];
    
    [current removeAllPendingNotificationRequests];
    [current addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error Posting User Notification: %@", error.localizedDescription);
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"User DID EXIT Region: %@", region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"There was an error: %@", error.localizedDescription); //ignore if in simulator
}

-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    NSLog(@"This is here for no reason... But heres a visit: %@", visit);
}

@end


