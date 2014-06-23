//
//  MBBecaon.h
//  MyBeacon
//
//  Created by foundry on 17/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLBeaconRegion;
@protocol MBBeaconAdvertiserDelegate <NSObject>
- (void)advertisingFailedWithError:(NSError*)error;


@end
@interface MBBeaconAdvertiser : NSObject

@property (nonatomic, strong) NSString* UUID;
@property (nonatomic, strong) CLBeaconRegion* region;
@property (nonatomic, weak) id<MBBeaconAdvertiserDelegate>delegate;


+ (MBBeaconAdvertiser*)instance;

- (void)startAdvertising;
- (void)stopAdvertising;
- (NSString*) UUID;
- (NSString*) identifier;
@end
