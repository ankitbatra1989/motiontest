//
//  ViewController.h
//  motiontest
//
//  Created by Ankit Batra on 15/06/14.
//  Copyright (c) 2014 new. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
double currentMaxAccelX;
double currentMaxAccelY;
double currentMaxAccelZ;
double currentMaxRotX;
double currentMaxRotY;
double currentMaxRotZ;

@interface ViewController : UIViewController
{
    
    __weak IBOutlet UIButton *startStopButton;
}
@property (strong, nonatomic) IBOutlet UILabel *accX;
@property (strong, nonatomic) IBOutlet UILabel *accY;
@property (strong, nonatomic) IBOutlet UILabel *accZ;

@property (strong, nonatomic) IBOutlet UILabel *rotX;
@property (strong, nonatomic) IBOutlet UILabel *rotY;
@property (strong, nonatomic) IBOutlet UILabel *rotZ;
@property (weak, nonatomic) IBOutlet UILabel *roll;
@property (weak, nonatomic) IBOutlet UILabel *pitch;
@property (weak, nonatomic) IBOutlet UILabel *yaw;

- (IBAction)startSenseTapped:(UIButton *)sender;
@end
