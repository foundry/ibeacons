//
//  MBBeaconListener.h
//  MyBeacon
//
//  Created by jonathan on 18/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@protocol MBBeaconListenerDelegate

//- (void)foundVenue:(NSString*)venueName;
//- (void)rangedBeaconsWithProximity:(CLProximity)proximity;
- (void)foundBeacon:(CLBeacon*)beacon inRegion:(CLBeaconRegion*)region;
@end
@interface MBBeaconListener : NSObject

+ (MBBeaconListener*)instance;
@property (weak, nonatomic) id <MBBeaconListenerDelegate> delegate;

- (void)startListening;
- (void)stopListening;

@end
