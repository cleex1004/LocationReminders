//
//  LocationControllerDelegate.h
//  LocationReminders
//
//  Created by Christina Lee on 5/2/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationControllerDelegate <NSObject>

@optional
- (void)locationControllerUpdatedLocation:(CLLocation *)location;

@end
