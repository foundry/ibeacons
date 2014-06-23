//
//  MBPKHelpers.m
//  MyBeacon
//
//  Created by jonathan on 22/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import "MBPKHelpers.h"

@implementation MBPKHelpers


+ (void)logBeaconRegion:(PKIBeaconRegion*)region {
    NSLog(@"\nPKBEACON REGION\nuuid:%@, \nmajor:%ld minor:%ld\nid: %@ name: %@"
          ,region.uuid
          , (long)region.major
          , (long)region.minor
          , region.identifier
          , region.name
          );
}

+ (NSString*)regionState:(PKRegionState)state {
    NSString* result;
    switch (state) {
        case PKRegionStateUnknown:
            result = @"PKRegionStateUnknown";
            break;
        case PKRegionStateInside:
            result = @"PKRegionStateInside";
            break;
        case PKRegionStateOutside:
            result = @"PKRegionStateOutside";
            break;
    }
    return result;
}
@end
