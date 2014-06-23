//
//  MBBecaon.m
//  MyBeacon
//
//  Created by foundry on 17/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import "MBBeaconAdvertiser.h"
@import CoreLocation;
@import CoreBluetooth;

@interface MBBeaconAdvertiser()<CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager* myPeripheralManager;
@property (nonatomic, strong) NSDictionary* peripheralData;
@end

@implementation MBBeaconAdvertiser



+ (MBBeaconAdvertiser*)instance
{
	static dispatch_once_t pred;
	static MBBeaconAdvertiser *sharedInstance = nil;
    
	dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupBeacon];
        }
    return self;
}

- (NSString*)UUID {
    return  MB_UUID;
}

- (NSString*)identifier {
    return MB_IDENTIFIER;
}

- (void)setupBeacon {
    NSUUID* myProximityUUID = [[NSUUID alloc] initWithUUIDString:[self UUID]];
    //NSNumber* branchNumber = @42;
    //NSNumber* tillNumber = @3;
    self.region =
    [[CLBeaconRegion alloc] initWithProximityUUID:myProximityUUID
                                            major:1
                                            minor:1
                                       identifier:[self identifier]];
    
    self.peripheralData = [self.region peripheralDataWithMeasuredPower:nil];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    self.myPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:queue];
}

- (void)startAdvertising {
    if (!self.myPeripheralManager.isAdvertising) {
        NSLog(@"%s %@ %@",__func__, self.myPeripheralManager,self.peripheralData);
        [self.myPeripheralManager startAdvertising:self.peripheralData];
    }
}

- (void)stopAdvertising {
    if (self.myPeripheralManager.isAdvertising) {
        NSLog(@"%s",__func__);
        [self.myPeripheralManager stopAdvertising];
    }
}

#pragma mark - peripheralManager delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"%s %@, %d",__func__,peripheral,peripheral.state);
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"%s %@, %d",__func__,peripheral,peripheral.state);
    if (error) {
        NSLog(@"error: %@",error);
        [self.delegate advertisingFailedWithError:error];
    }
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"%s %@, %@",__func__,peripheral,characteristic);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"%s %@, %@",__func__,peripheral,characteristic);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    NSLog(@"%s %@, %@",__func__,peripheral,service);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"%s %@, %@",__func__,peripheral,request);
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    NSLog(@"%s %@, %@",__func__,peripheral,requests);
}

//- (void) peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict {
//    NSLog(@"%s %@, %@",__func__,peripheral,dict);
//}

- (void) peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    NSLog(@"%s %@, %d",__func__,peripheral,peripheral.state);
}
@end
