//
//  MBPKBeaconListener.h
//  MyBeacon
//
//  Created by jonathan on 19/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@protocol MBPKBeaconListenerDelegate
//- (void)foundVenue:(NSString*)venueName;
//- (void)rangedBeaconsWithProximity:(CLProximity)proximity;
- (void)foundBeacon:(CLBeacon*)beacon inRegion:(CLBeaconRegion*)region;
@end

@interface MBPKBeaconListener : NSObject
+ (MBPKBeaconListener*)instance;
@property (weak, nonatomic) id <MBPKBeaconListenerDelegate> delegate;

- (void)startListening;
- (void)stopListening;
@end
