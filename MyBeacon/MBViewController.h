//
//  MBViewController.h
//  MyBeacon
//
//  Created by foundry on 17/06/2014.
//  Copyright (c) 2014 com.boppl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *foundLabel;
@property (weak, nonatomic) IBOutlet UIButton *listening;
- (IBAction)listeningPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *radarView;
@property (weak, nonatomic) IBOutlet UIButton *advertising;
- (IBAction)advertisingPressed:(id)sender;

@end
