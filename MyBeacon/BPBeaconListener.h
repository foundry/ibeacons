//
//  BPBeaconManager.h
//  Boppl
//
//  Created by Gilbert Jolly on 14/10/2013.
//  Copyright (c) 2013 Boppl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BeaconListenerDelegate

- (void)foundVenue:(NSString*)venueName;
@end
@interface BPBeaconListener : NSObject

+ (BPBeaconListener*)instance;

@property (strong, nonatomic) NSString* rangedVenue;
@property (weak, nonatomic) id <BeaconListenerDelegate> delegate;

- (void)findBeacons;

- (void)startListening;
- (void)stopListening;
- (void)startUpdating;
- (void)stopUpdating;

@end
