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

@interface ViewController ()

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
    
}

- (IBAction)location1Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566674, -122.351096);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
