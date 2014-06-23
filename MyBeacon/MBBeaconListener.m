//
//  MBBeaconListener.m
//  MyBeacon
//
//  Created by foundry on 18/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import "MBBeaconListener.h"
#import "MBBeaconAdvertiser.h"
#import "MBAppDelegate.h"
#import "MBCLHelpers.h"
@interface MBBeaconListener()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray* regions;

@end


@implementation MBBeaconListener


+ (MBBeaconListener*)instance {
    static dispatch_once_t onceToken;
    static MBBeaconListener* sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self initRegions];
    }
    return self;
}

- (void)initRegions {
    NSLog(@"%s",__func__);

    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:MB_UUID];
    CLBeaconRegion* region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:MB_IDENTIFIER];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;
    self.regions = @[region];
}

- (void)startListening {
    [self stopListening];
    NSLog(@"%s",__func__);
    for (CLBeaconRegion* region in self.regions) {
        NSLog(@"%s %@",__func__,region.identifier);
        [self.locationManager startMonitoringForRegion:region];
    }
    NSLog(@"ranged regions: %@",self.locationManager.rangedRegions);
}

- (void)stopListening {
    NSLog(@"%s",__func__);
    NSLog(@"stopListening- monitored regions: %@",self.locationManager.monitoredRegions);
    NSLog(@"stopListening- ranged regions: %@",self.locationManager.rangedRegions);
    for (CLBeaconRegion* region in self.locationManager.monitoredRegions) {
        NSLog(@"%s %@",__func__,region.identifier);
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    }
}

#pragma mark - delegate methods

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion* beaconRegion = (CLBeaconRegion*)region;
        NSLog(@"-----------------------");
        NSLog(@"%s",__func__);
        NSLog(@"entered %@", region);
        [MBCLHelpers logBeaconRegion:beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        NSString* idString = (region.identifier)?region.identifier:beaconRegion.proximityUUID.UUIDString;
        NSString* message =[NSString stringWithFormat:@"Entered region: %@",idString];
        [MBCLHelpers sendLocalNotificationMessage:message];
    }
}




-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion* beaconRegion = (CLBeaconRegion*)region;
        NSLog(@"-----------------------");
        NSLog(@"%s",__func__);
        NSLog(@"exited %@", region);
        [MBCLHelpers logBeaconRegion:beaconRegion];
        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
        [self.delegate foundBeacon:nil inRegion:(CLBeaconRegion*)region];
        NSString* idString = (region.identifier)?region.identifier:beaconRegion.proximityUUID.UUIDString;
        NSString* message =[NSString stringWithFormat:@"Exited region: %@",idString];
        [MBCLHelpers sendLocalNotificationMessage:message];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"-----------------------");
    NSLog(@"%s",__func__);
    NSLog(@"error %@",error);
    NSLog(@"error code: %@",[MBCLHelpers CLErrorCode:error]);
}




- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLBeaconRegion *)region
{
    NSLog(@"-----------------------");
    NSLog(@"%s %@",__func__,[MBCLHelpers regionState:state]);
    [MBCLHelpers logBeaconRegion:(CLBeaconRegion*)region];
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    NSLog(@"-----------------------");
    NSLog(@"%s %@ %@",__func__,region, beacons);
    [MBCLHelpers logBeaconRegion:(CLBeaconRegion*)region];
    CLBeacon* preferredBeacon = nil;
    if (beacons.lastObject) {
        CLProximity proximity = CLProximityFar;
        for (CLBeacon* beacon in beacons) {
            [MBCLHelpers logBeacon:beacon];
            if (beacon.proximity != CLProximityUnknown
                && beacon.proximity <= proximity) {
                    proximity = beacon.proximity;
                    preferredBeacon = beacon;
                }
        }
    }
    [self.delegate foundBeacon:preferredBeacon inRegion:region];
  
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"-----------------------");
    NSLog(@"%s %@",__func__,region);
    NSLog(@"error %@", error);
    NSLog(@"errorCode %@",[MBCLHelpers CLErrorCode:error]);
}




@end
