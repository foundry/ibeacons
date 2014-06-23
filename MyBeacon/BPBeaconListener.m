//
//  BPBeaconManager.m
//  Boppl
//
//  Created by Gilbert Jolly on 14/10/2013.
//  Copyright (c) 2013 Boppl. All rights reserved.
//

#import "BPBeaconListener.h"
#import "MBBeaconAdvertiser.h"

@import CoreLocation;

#define IGNORE_DATE NO

@interface BPBeaconListener () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *dateOfLastPush;
@property (strong, nonatomic) NSNumber *currentMajor;


@end




@implementation BPBeaconListener


+ (BPBeaconListener*)instance
{
	static dispatch_once_t pred;
	static BPBeaconListener *sharedInstance = nil;
    
	dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}


- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"%s",__func__);

        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        NSLog (@"location services enabled? %d",self.locationManager.locationServicesEnabled);
        [self initRegion];
    }
    return self;
}



- (void)findBeacons
{
    //Just have this method for the method name, so that we can call the instance and it looks like it does something.  Beacons are always being looked for
}



- (void)initRegion {
    NSLog(@"%s",__func__);
   
    
    self.beaconRegion = [[MBBeaconAdvertiser instance] region];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    self.beaconRegion.notifyOnExit = YES;
    NSLog(@"authorisation status: %u",[CLLocationManager authorizationStatus]);
    NSLog(@"isMonitoringAvaialble: %u",[CLLocationManager isMonitoringAvailableForClass:[self.beaconRegion class]]);
    NSLog(@"isRangingAvailable: %u",[CLLocationManager isRangingAvailable]);

}


- (void)startListening {
    NSLog(@"%s",__func__);
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    for (CLRegion* region in self.locationManager.monitoredRegions) {
        NSLog(@"monitoring region: %@",region);
    }

}

- (void)stopListening {
    NSLog(@"%s",__func__);
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
}

- (void)startUpdating {
    self.locationManager.distanceFilter = 1.0;
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdating {
    [self.locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLBeaconRegion *)region
{
    NSLog(@"%s",__func__);
    [self enteredRegion:region];
}




-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"%s",__func__);

    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.rangedVenue = nil;
}




- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLBeaconRegion *)region
{
    NSLog(@"%s,%ld,%@",__func__,state,region);
    switch (state) {
        case  CLRegionStateUnknown: {
            NSLog(@"CLRegionStateUnknown");
            break;
        }
        case  CLRegionStateInside: {
            NSLog(@"CLRegionStateInside");
            [self enteredRegion:region];
            break;
        }
        case  CLRegionStateOutside: {
            NSLog(@"CLRegionStateOutside");
            ;
            break;
        }
    }
}




- (void)enteredRegion:(CLBeaconRegion*)region
{
    NSLog(@"%s %@",__func__,region);
    self.rangedVenue = @"FOUND";
    //[self.delegate foundVenue:@"FOUND"];
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (id)region;

        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}




-(void)locationManager:(CLLocationManager *)manager
       didRangeBeacons:(NSArray *)beacons
              inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    if ([self isInANewVenue:beacon.major]) {
        self.dateOfLastPush = [NSDate date];
        self.currentMajor = beacon.major;
        
        [self displayNotification:beacon.major];
        
    }else if (!beacon.major){
        self.rangedVenue = nil;
    }
    
    
    NSString *distance;
    if (beacon.proximity == CLProximityUnknown) {
        distance = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        distance = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        distance = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
        distance = @"Far";
    }
}




- (BOOL)enoughTimeHasPassedSinceLastPush
{
    NSLog(@"%s",__func__);

    int numSeconds = [[NSDate date] timeIntervalSinceDate:self.dateOfLastPush];
    if (!self.dateOfLastPush) {
        numSeconds = 10000;
    }
    BOOL enoughTime = (numSeconds > (60 * 5));
    
    return enoughTime || IGNORE_DATE;
}




- (BOOL)isInANewVenue:(NSNumber*)venueID
{
    NSLog(@"%s",__func__);

    if (!venueID) {
        return NO;
    }
    
    if (![self.currentMajor isEqualToNumber:venueID]) {
        return YES;
    }
    return NO;
}




- (void)displayNotification:(NSNumber*)venueID
{
    NSLog(@"%s",__func__);

        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"FOUND";
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%s",__func__);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"%s %@",__func__,region);
    //[self.locationManager requestStateForRegion:self.beaconRegion];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        NSLog(@"Couldn't turn on monitoring: Location services not authorised.");
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion - error: %@", [error localizedDescription]);
}

@end
