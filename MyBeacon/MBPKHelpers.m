//
//  MBPKHelpers.m
//  MyBeacon
//
//  Created by foundry on 22/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import "MBPKHelpers.h"

@implementation MBPKHelpers


+ (void)logBeaconRegion:(RPKBeaconRegion*)region {
    NSLog(@"\nPKBEACON REGION\nuuid:%@, \nmajor:%ld minor:%ld\nid: %@ name: %@"
          ,region.uuid
          , (long)region.major
          , (long)region.minor
          , region.identifier
          , region.name
          );
}

+ (NSString*)regionState:(RPKRegionState)state {
    NSString* result;
    switch (state) {
        case RPKRegionStateUnknown:
            result = @"RPKRegionStateUnknown";
            break;
        case RPKRegionStateInside:
            result = @"RPKRegionStateInside";
            break;
        case RPKRegionStateOutside:
            result = @"RPKRegionStateOutside";
            break;
    }
    return result;
}
@end
