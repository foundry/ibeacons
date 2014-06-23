//
//  MBPKHelpers.h
//  MyBeacon
//
//  Created by foundry on 22/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PKManagerDelegate.h>
#import <PKIBeaconRegion.h>
#import <PKIBeacon.h>

@interface MBPKHelpers : NSObject
+ (void)logBeaconRegion:(PKIBeaconRegion*)region;
+ (NSString*)regionState:(PKRegionState)state;

@end
