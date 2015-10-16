//
//  MBPKHelpers.h
//  MyBeacon
//
//  Created by foundry on 22/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RPKManagerDelegate.h>
#import <RPKBeaconRegion.h>
#import <RPKBeacon.h>

@interface MBPKHelpers : NSObject
+ (void)logBeaconRegion:(RPKBeaconRegion*)region;
+ (NSString*)regionState:(RPKRegionState)state;

@end
