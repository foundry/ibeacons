//
//  MBCLHelpers.h
//  MyBeacon
//
//  Created by foundry on 19/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;


@interface MBCLHelpers : NSObject
+ (NSString*)CLErrorCode:(NSError*)error;
+ (void)logBeaconRegion:(CLBeaconRegion*)region;
+ (void)logBeacon:(CLBeacon*)beacon;
+ (void)logAvailability;
+ (NSString*)proximity:(CLProximity)proximity;
+ (NSString*)regionState:(CLRegionState)region;

+ (void)sendLocalNotificationMessage:(NSString*)message;
+ (void)sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region;
+ (void)sendLocalNotificationForBeacon:(CLBeacon *)beacon;
@end
