 //
//  MBPKBeaconListener.m
//  MyBeacon
//
//  Created by jonathan on 19/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import "MBPKBeaconListener.h"
#import <ProximityKit/ProximityKit.h>
#import "MBCLHelpers.h"
#import "MBPKHelpers.h"

@interface MBPKBeaconListener()<PKManagerDelegate>


@property (strong, nonatomic) PKManager *beaconManager;

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
        self.beaconManager = [PKManager managerWithDelegate:self];
    }
    return self;
}


- (void)startListening {
    NSLog(@"%s",__func__);
    [self.beaconManager start];
    [self.beaconManager startRangingIBeacons];
   
}

- (void)stopListening {
    NSLog(@"%s",__func__);
    [self.beaconManager stopRangingIBeacons];
    [self.beaconManager stop];
    [self.delegate foundBeacon:nil inRegion:nil];

    
}

#pragma mark -
#pragma mark ProximityKit delegate methods

- (void)proximityKit:(PKManager *)manager didEnter:(PKRegion *)region {
    NSLog(@"-----------------------");
    NSLog(@"%s",__func__);
    NSLog(@"entered %@", region);
    [MBPKHelpers logBeaconRegion:(PKIBeaconRegion*)region];

}
- (void)proximityKit:(PKManager *)manager didExit:(PKRegion *)region {
    NSLog(@"-----------------------");
    NSLog(@"%s",__func__);
    NSLog(@"exited %@", region);
    [MBPKHelpers logBeaconRegion:(PKIBeaconRegion*)region];

    [self.delegate foundBeacon:nil inRegion:(CLBeaconRegion*)region];

}

- (void)proximityKit:(PKManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"-----------------------");
    NSLog(@"%s",__func__);
    NSLog(@"error %@",error);
    NSLog(@"error code: %@",[MBCLHelpers CLErrorCode:error]);

}

- (void)proximityKit:(PKManager *)manager didDetermineState:(PKRegionState)state forRegion:(PKRegion *)region {
    NSLog(@"-----------------------");
    NSLog(@"%s %@",__func__,[MBPKHelpers regionState:state]);
    [MBPKHelpers logBeaconRegion:(PKIBeaconRegion*)region];
    

}

- (void)proximityKit:(PKManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(PKRegion *)region {
    NSLog(@"-----------------------");
    NSLog(@"%s %@ %@",__func__,region, beacons);
    [MBPKHelpers logBeaconRegion:(PKIBeaconRegion*)region];
    CLBeacon* preferredBeacon = nil;
    if (beacons.lastObject) {
        CLProximity proximity = CLProximityFar;
        for (PKIBeacon* pkBeacon in beacons) {
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

- (void)proximityKitDidSync:(PKManager *)manager {
    NSLog(@"-----------------------");
    NSLog(@"%s",__func__);
}



@end
