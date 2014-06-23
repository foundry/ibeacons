//
//  MBCLHelpers.m
//  MyBeacon
//
//  Created by foundry on 19/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import "MBCLHelpers.h"

@implementation MBCLHelpers

+ (NSString*)CLErrorCode:(NSError*)error {
    NSString* result = @"";
    switch(error.code) {
            
        case(kCLErrorLocationUnknown):
            result = @"kCLErrorLocationUnknown";
            break;
        case(kCLErrorDenied):
            result = @"kCLErrorDenied,";
            break;
        case(kCLErrorNetwork):
            result = @"kCLErrorNetwork,";
            break;
        case(kCLErrorHeadingFailure):
            result = @"kCLErrorHeadingFailure,";
            break;
        case(kCLErrorRegionMonitoringDenied):
            result = @"kCLErrorRegionMonitoringDenied,";
            break;
        case(kCLErrorRegionMonitoringFailure):
            result = @"kCLErrorRegionMonitoringFailure,";
            break;
        case(kCLErrorRegionMonitoringSetupDelayed):
            result = @"kCLErrorRegionMonitoringSetupDelayed,";
            break;
        case(kCLErrorRegionMonitoringResponseDelayed):
            result = @"kCLErrorRegionMonitoringResponseDelayed,";
            break;
        case(kCLErrorGeocodeFoundNoResult):
            result = @"kCLErrorGeocodeFoundNoResult,";
            break;
        case(kCLErrorGeocodeFoundPartialResult):
            result = @"kCLErrorGeocodeFoundPartialResult,";
            break;
        case(kCLErrorGeocodeCanceled):
            result = @"kCLErrorGeocodeCanceled,";
            break;
        case(kCLErrorDeferredFailed):
            result = @"kCLErrorDeferredFailed,";
            break;
        case(kCLErrorDeferredNotUpdatingLocation):
            result = @"kCLErrorDeferredNotUpdatingLocation,";
            break;
        case(kCLErrorDeferredAccuracyTooLow):
            result = @"kCLErrorDeferredAccuracyTooLow,";
            break;
        case(kCLErrorDeferredDistanceFiltered):
            result = @"kCLErrorDeferredDistanceFiltered,";
            break;
        case(kCLErrorDeferredCanceled):
            result = @"kCLErrorDeferredCanceled,";
            break;
        case(kCLErrorRangingUnavailable):
            result = @"kCLErrorRangingUnavailable,";
            break;
        case(kCLErrorRangingFailure):
            result = @"kCLErrorRangingFailure,";
            break;
    }
    return result;
}

+ (void)logBeacon:(CLBeacon*)beacon {
    NSLog(@"\nBEACON:\nuuid:%@, \nmajor:%@ minor:%@ \nproximity:%@ accuracy:%f"
          ,beacon.proximityUUID
          , beacon.major
          , beacon.minor
          , [self proximity:beacon.proximity]
          , beacon.accuracy);
}

+ (void)logBeaconRegion:(CLBeaconRegion*)region {
    NSLog(@"\nBEACON REGION:\nuuid:%@, \nmajor:%@ minor:%@ \nidentifier:%@\nnotifyOnDisplay: %d onEntry %d onExit %d"
          ,region.proximityUUID
          , region.major
          , region.minor
          , region.identifier
          , region.notifyEntryStateOnDisplay
          , region.notifyOnEntry
          , region.notifyOnExit
        

);
}


+ (void)logAvailability {
    NSLog(@"canDeviceSupportAppBackgroundRefresh? %d \n authorization status: %d \n locationServicesEnabled %d \n deferredLocationUpdatesAvailable %d \n significantLocationChangeMonitoringAvailable %d \n headingAvailable %d \n isRangingAvailable %d",
          [self canDeviceSupportAppBackgroundRefresh]
          ,[CLLocationManager authorizationStatus]
          ,[CLLocationManager locationServicesEnabled]
          ,[CLLocationManager deferredLocationUpdatesAvailable]
          ,[CLLocationManager significantLocationChangeMonitoringAvailable]
          ,[CLLocationManager headingAvailable]
          ,[CLLocationManager isRangingAvailable]);
}


+(BOOL)canDeviceSupportAppBackgroundRefresh
{
    BOOL result = NO;
    // Override point for customization after application launch.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
        NSLog(@"Background updates are available for the app.");
        result = YES;
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
    {
        NSLog(@"The user explicitly disabled background behavior for this app or for the whole system.");
        result =  NO;
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        NSLog(@"Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.");
        result =  NO;
    }
    return result;
}

+ (NSString*)proximity:(CLProximity)proximity {
    NSString* result;
    switch (proximity) {
        case CLProximityUnknown:
            result = @"kCLProximityUnknown";
            break;
        case CLProximityFar:
            result = @"CLProximityFar";
            break;
        case CLProximityImmediate:
            result = @"CLProximityImmediate";
            break;
        case CLProximityNear:
            result = @"CLProximityNear";
            break;
    }
    return result;
}

+ (NSString*)regionState:(CLRegionState)state {
    NSString* result;
    switch (state) {
        case CLRegionStateUnknown:
            result = @"CLRegionStateUnknown";
            break;
        case CLRegionStateInside:
            result = @"CLRegionStateInside";
            break;
        case CLRegionStateOutside:
            result = @"CLRegionStateOutside";
            break;
    }
    return result;
}


#pragma mark - Local notifications
+ (void)sendLocalNotificationMessage:(NSString*)message
{
    UILocalNotification *notification = [UILocalNotification new];
    
    // Notification details
    notification.alertBody = message;   // Major and minor are not available at the monitoring stage
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}



+ (void)sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    
    // Notification details
    notification.alertBody = [NSString stringWithFormat:@"Entered beacon region for UUID: %@",
                              region.proximityUUID.UUIDString];   // Major and minor are not available at the monitoring stage
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

+ (void)sendLocalNotificationForBeacon:(CLBeacon *)beacon
{
    UILocalNotification *notification = [UILocalNotification new];
    
    // Notification details
    notification.alertBody = [NSString stringWithFormat:@"Found beacon %@:%@ for UUID: %@"
                              , beacon.major
                              , beacon.minor
                              ,beacon.proximityUUID.UUIDString];
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


@end
