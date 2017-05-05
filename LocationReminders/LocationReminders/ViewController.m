//
//  ViewController.m
//  LocationReminders
//
//  Created by Christina Lee on 5/1/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "ViewController.h"
#import "AddReminderViewController.h"
#import "LocationControllerDelegate.h"
#import "LocationController.h"
#import "Reminder.h"

@import Parse;
@import MapKit;
@import CoreLocation;
@import ParseUI;

@interface ViewController () <MKMapViewDelegate, LocationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LocationController shared]requestPermissions];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [LocationController shared].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderSavedToParse:) name:@"ReminderSavedToParse" object:nil];
    
    [PFUser logOut];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc]init];
        loginViewController.delegate = self;
        loginViewController.signUpController.delegate = self;
        
        loginViewController.fields = PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsPasswordForgotten;
        
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self allOverlays];
}

-(void)reminderSavedToParse:(id)sender {
    NSLog(@"Do some stuff since our new Reminder was saved!");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"AddReminderViewController"] && [sender isKindOfClass:[MKAnnotationView class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;
        
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
        newReminderViewController.title = annotationView.annotation.title;
        
        __weak typeof(self) bruce = self;
        
        newReminderViewController.completion = ^(MKCircle *circle) {
            __strong typeof(bruce) hulk = bruce; //to prevent retain cycles
            [hulk.mapView removeAnnotation:annotationView.annotation];
            [hulk.mapView addOverlay:circle];
            
            
        };
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReminderSavedToParse" object:nil];
    
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

- (IBAction)userLongPressed:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = coordinate;
        newPoint.title = @"New Location";
        
        [self.mapView addAnnotation:newPoint];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    
    UIButton *rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"Acessory Tapped!");
    [self performSegueWithIdentifier:@"AddReminderViewController" sender:view];
}

- (void)locationControllerUpdatedLocation:(CLLocation *)location{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc]initWithCircle:overlay];
    renderer.strokeColor = [UIColor cyanColor];
    renderer.fillColor = [UIColor magentaColor];
    renderer.alpha = 0.25;
    
    return renderer;
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)allOverlays {
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"Query Results %@", objects);
            for (Reminder *reminder in objects) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude);
                CGFloat radius = [reminder.radius floatValue];
                MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:coordinate radius:radius];
                [self.mapView addOverlay:circleOverlay];
            }
        }
    }];

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

//-(void)fetchQuery {
//    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%@", error.localizedDescription);
//        } else {
//            NSLog(@"Query Results %@", objects);
//        }
//    }];
//}


