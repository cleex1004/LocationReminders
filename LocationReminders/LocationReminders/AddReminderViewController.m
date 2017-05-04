//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by Christina Lee on 5/2/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "AddReminderViewController.h"
#import "Reminder.h"
#import "LocationController.h"

@interface AddReminderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITextField *radiusField;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)savePressed:(id)sender {
    Reminder *newReminder = [Reminder object];
    newReminder.name = self.nameField.text;
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"Annotation Title: %@", self.annotationTitle);
        NSLog(@"Coordinates: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
        NSLog(@"Save Reminder Successful: %i - Error %@", succeeded, error.localizedDescription);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderSavedToParse" object:nil];
        
        if (self.completion) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            CGFloat radius = [[f numberFromString:self.radiusField.text] floatValue]; //for lab coming from uislider/ textfield from the user
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius];
            
            if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:self.coordinate radius:radius identifier:newReminder.name];
                [LocationController.shared startMonitoringForRegion:region];
            }
            
            self.completion(circle);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];

}



@end
