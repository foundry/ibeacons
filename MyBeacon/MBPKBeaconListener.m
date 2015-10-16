 //
//  MBPKBeaconListener.m
//  MyBeacon
//
//  Created by foundry on 19/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import "MBPKBeaconListener.h"
#import <ProximityKit/ProximityKit.h>
#import "MBCLHelpers.h"
#import "MBPKHelpers.h"

@interface MBPKBeaconListener()<RPKManagerDelegate>


@property (strong, nonatomic) RPKManager *beaconManager;

@end


@implementation MBPKBeaconListener


+ (MBPKBeaconListener*)instance {
    static dispatch_once_t onceToken;
    static MBPKBeaconListener* sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.beaconManager = [RPKManager managerWithDelegate:self];
    }
    return self;
}


- (void)startListening {
    NSLog(@"%s",__func__);
    [self.beaconManager start];
    [self.beaconManager startRangingBeacons];
   
}

- (void)stopListening {
    NSLog(@"%s",__func__);
    [self.beaconManager stopRangingIBeacons];
    [self.beaconManager stop];
    [self.delegate foundBeacon:nil inRegion:nil];

    
}

#pragma mark -
#pragma mark ProximityKit delegate methods

- (void)proximityKit:(RPKManager *)manager didEnter:(RPKRegion *)region {
    NSLog(@"-----------------------");
    NSLog(@"%s",__func__);
    NSLog(@"entered %@", region);
    [MBPKHelpers logBeaconRegion:(RPKBeaconRegion*)region];

}
- (void)proximityKit:(RPKManager *)manager didExit:(RPKRegion *)region {
    NSLog(@"-----------------------");
    NSLog(@"%s",__func__);
    NSLog(@"exited %@", region);
    [MBPKHelpers logBeaconRegion:(RPKBeaconRegion*)region];

    [self.delegate foundBeacon:nil inRegion:(CLBeaconRegion*)region];

}

- (void)proximityKit:(RPKManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"-----------------------");
    NSLog(@"%s",__func__);
    NSLog(@"error %@",error);
    NSLog(@"error code: %@",[MBCLHelpers CLErrorCode:error]);

}

- (void)proximityKit:(RPKManager *)manager didDetermineState:(RPKRegionState)state forRegion:(RPKRegion *)region {
    NSLog(@"-----------------------");
    NSLog(@"%s %@",__func__,[MBPKHelpers regionState:state]);
    [MBPKHelpers logBeaconRegion:(RPKBeaconRegion*)region];
    

}

- (void)proximityKit:(RPKManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(RPKRegion *)region {
    NSLog(@"-----------------------");
    NSLog(@"%s %@ %@",__func__,region, beacons);
    [MBPKHelpers logBeaconRegion:(RPKBeaconRegion*)region];
    CLBeacon* preferredBeacon = nil;
    if (beacons.lastObject) {
        CLProximity proximity = CLProximityFar;
        for (RPKBeacon* pkBeacon in beacons) {
            [MBCLHelpers logBeacon:pkBeacon.beacon];
            if (   pkBeacon.proximity != CLProximityUnknown
                && pkBeacon.proximity <= proximity) {
                    proximity = pkBeacon.proximity;
                    preferredBeacon = pkBeacon.beacon;
            }
        }
    }
    [self.delegate foundBeacon:preferredBeacon inRegion:(CLBeaconRegion*)region];
}

- (void)proximityKitDidSync:(RPKManager *)manager {
    NSLog(@"-----------------------");
    NSLog(@"%s",__func__);
}



@end
