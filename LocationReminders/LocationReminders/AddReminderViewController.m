//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by Christina Lee on 5/2/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Annotation Title: %@", self.annotationTitle);
    NSLog(@"Coordinates: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
}



@end