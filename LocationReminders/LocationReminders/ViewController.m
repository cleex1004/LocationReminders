//
//  ViewController.m
//  LocationReminders
//
//  Created by Christina Lee on 5/1/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "ViewController.h"

@import Parse;
@import MapKit;
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPermissions];
    self.mapView.showsUserLocation = YES;
}

-(void)requestPermissions{
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = 100;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (IBAction)location1Pressed:(id)sender {
    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(47.616990, -122.343656);
    
    MKCoordinateRegion region1 = MKCoordinateRegionMakeWithDistance(coordinate1, 500.0, 500.0);
    
    [self.mapView setRegion:region1 animated:YES];
}

- (IBAction)location2Pressed:(id)sender {
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(38.906858, -77.045420);
    
    MKCoordinateRegion region2 = MKCoordinateRegionMakeWithDistance(coordinate2, 500.0, 500.0);
    
    [self.mapView setRegion:region2 animated:YES];
}

- (IBAction)location3Pressed:(id)sender {
    CLLocationCoordinate2D coordinate3 = CLLocationCoordinate2DMake(47.193756, -122.539191);
    
    MKCoordinateRegion region3 = MKCoordinateRegionMakeWithDistance(coordinate3, 500.0, 500.0);
    
    [self.mapView setRegion:region3 animated:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    
    NSLog(@"Coordinate: %f, %f - Altitude: %f", location.coordinate.latitude, location.coordinate.longitude, location.altitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}

@end
//TEST CODE
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//
//    testObject[@"testName"] = @"Adam Wallraff";
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Success saving test object!");
//        } else {
//            NSLog(@"There was a problem saving. Save Error: %@", error.localizedDescription);
//        }
//    }];
//
//    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%@", error.localizedDescription);
//        } else {
//            NSLog(@"Query Results %@", objects);
//        }
//    }];
