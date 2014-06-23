//
//  MBViewController.m
//  MyBeacon
//
//  Created by jonathan on 17/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import "MBCLHelpers.h"
#import "MBViewController.h"
#import "MBBeaconAdvertiser.h"
#import "MBBeaconListener.h"
#import "MBPKBeaconListener.h"

typedef enum {
    MBPKBeaconListenerClass,
    MBBeaconListenerClass
} ListenerClassType;

@import CoreLocation;
@interface MBViewController () <MBPKBeaconListenerDelegate, MBBeaconAdvertiserDelegate>
@property (nonatomic, strong) CABasicAnimation* rotationAnimation;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UIColor* colour;
@property (nonatomic, assign) Class listenerClass;
@property (nonatomic, assign) ListenerClassType listenerClassType;
@end

@implementation MBViewController

- (Class)listenerClass {
    switch (self.listenerClassType) {
        case MBPKBeaconListenerClass:
            return [MBPKBeaconListener class];
            break;
        case MBBeaconListenerClass:
            return [MBBeaconListener class];
            break;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listenerClassType = MBPKBeaconListenerClass;
    [MBCLHelpers logAvailability];

    [self.listenerClass instance].delegate = self;
    [MBBeaconAdvertiser instance].delegate = self;
    //[MB instance].delegate = self;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)advertisingPressed:(UIButton*)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"start advertising"]) {
        [self startAdvertising:sender];
    } else {
        [self stopAdvertising:sender];
    }
}

- (void)startAdvertising:(UIButton*)sender {
    [self hideView:self.listening];
    [[MBBeaconAdvertiser instance] startAdvertising];
    [self startRotating];
    [sender setTitle:@"stop advertising" forState:UIControlStateNormal];

}

- (void)stopAdvertising:(UIButton*)sender {
    [[MBBeaconAdvertiser instance] stopAdvertising];
    [self showView:self.listening];
    [self stopRotating];
    [sender setTitle:@"start advertising" forState:UIControlStateNormal];
}

- (void)advertisingFailedWithError:(NSError *)error {
    self.foundLabel.text = @"Advertising Error";
    [self animateFound];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.foundLabel.text = nil;
        [self stopAdvertising:self.advertising];
    });
}

- (void)startRotating {
    [self animate];
}

- (void)stopRotating {
    [self stopAnimating];
}




- (CABasicAnimation*)rotationAnimation {
    if (!_rotationAnimation) {
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI  ];
        _rotationAnimation.duration = 0.6;
        _rotationAnimation.cumulative = NO;
        _rotationAnimation.repeatCount = HUGE_VALF;
    }
    return _rotationAnimation;
}

- (void)animate {
    [self.radarView.layer removeAllAnimations];
    self.rotationAnimation.repeatCount = HUGE_VALF;
    _rotationAnimation.cumulative = NO;

    [self.radarView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimating {
    [self.radarView.layer removeAllAnimations];
}


- (IBAction)listeningPressed:(UIButton*)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"start listening"]) {
        [(id)[[self listenerClass] instance] startListening];
        [self hideView:self.advertising];
        [self startRotating];
        [sender setTitle:@"stop listening" forState:UIControlStateNormal];
        
    } else {
        [(id)[[self listenerClass] instance] startListening];
        [self stopRotating];
        [self showView:self.advertising];
        [sender setTitle:@"start listening" forState:UIControlStateNormal];
    }

}

- (void)hideView:(UIView*)view
{
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        view.hidden = YES;
    }];
}

- (void)showView:(UIView*)view
{
    view.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 1.0;
    }];
}

#pragma mark - listener delegate methods

- (void)foundBeacon:(CLBeacon *)beacon inRegion:(CLBeaconRegion*)region {
    
    NSLog(@"%s",__func__);
    UIColor* colour;
    if (!beacon || beacon.proximity == CLProximityUnknown) {
        colour = [UIColor whiteColor];
        self.foundLabel.text = nil;
    } else {
        self.foundLabel.text = region.identifier;
        CGFloat red =log(beacon.accuracy*10)/log(50);
        CGFloat green = (-beacon.rssi/100.0f);
        CGFloat blue = beacon.proximity/4.0f;
        colour = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        //  colour = [UIColor colorWithHue:red saturation:green brightness:blue alpha:1.0];
        NSLog(@"red:%.2f,green:%.2f,blue:%.2f",red,green,blue);
        
    }
    self.colour  = colour;
    //if (self.foundLabel.text)[self animateFound];
    [self animateFound];

}

- (void)animateFound {
    NSLog(@"%s",__func__);

    if (self.isAnimating) {
        NSLog(@"isAnimating=TRUE, returning");
        return;
    };
    NSLog(@"isAnimating=FALSE, animating");
    self.isAnimating = YES;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (self.foundLabel.alpha == 1.0) {
                             self.foundLabel.alpha = 0.0;
                         } else {
                             self.foundLabel.alpha = 1.0;
                         }
                         self.view.backgroundColor = self.colour;
                     } completion:^(BOOL completed) {
                         self.isAnimating = NO;
                         if (self.foundLabel.text) {
                             [self animateFound];
                         } else {
                             [UIView animateWithDuration:0.5 animations:^{
                                 self.foundLabel.alpha = 0.0;
                                 self.colour = [UIColor whiteColor];
                                 self.view.backgroundColor = self.colour;
                             }];
                         }
                     }];

}



@end
