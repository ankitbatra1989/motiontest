//
//  ViewController.m
//  motiontest
//
//  Created by Ankit Batra on 15/06/14.
//  Copyright (c) 2014 new. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
//macro to change radians to degrees
#define radiansToDegrees(x) (180/M_PI)*x


@interface ViewController ()
{
    //private declarations
    AppDelegate *appdelgate;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //called first after this view is loaded into memory
	// Do any additional setup after loading the view, typically from a nib.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [appdelgate motionManager].accelerometerUpdateInterval = 1;
    [appdelgate motionManager].gyroUpdateInterval =1;
    [appdelgate motionManager].deviceMotionUpdateInterval = 1;
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
    
    //
    appdelgate = [[UIApplication sharedApplication]delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidDisappear
{
    // Request to stop receiving accelerometer events and turn off accelerometer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark - Orientation change triggerred
-(void) orientationDidChange:(NSNotification *)notification{
    // Get the current orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    // Handle any device orientation changes
    NSLog(@"Orientation : %ld",orientation);
    switch (orientation)
    {
        case 0:
            NSLog(@"UIDeviceOrientationUnknown");
            break;
        case 1:
            NSLog(@"UIDeviceOrientationPortrait");
            break;
        case 2:
            NSLog(@"UIDeviceOrientationPortraitUpsideDown");
            break;
        case 3:
            NSLog(@"UIDeviceOrientationLandscapeLeft");
            break;
        case 4:
            NSLog(@"UIDeviceOrientationLandscapeRight");
            break;
        case 5:
            NSLog(@"UIDeviceOrientationFaceUp");
            break;
        case 6:
            NSLog(@"UIDeviceOrientationFaceDown");
            break;
            
        default:
            break;
    }
    
    return;
}

#pragma mark - UIControl Methods
- (IBAction)startSenseTapped:(UIButton *)sender
{
    if ([startStopButton isSelected])
    {
        [startStopButton setSelected:NO];
        [[appdelgate motionManager] stopAccelerometerUpdates];
        [[appdelgate motionManager] stopDeviceMotionUpdates];
        [[appdelgate motionManager] stopGyroUpdates];
        return;
    }
    [startStopButton setSelected:YES];
    
    CMMotionManager *motionManager = [appdelgate motionManager];
    if (motionManager.deviceMotionAvailable)
    {
        
        [[appdelgate motionManager] startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                         withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                             [self outputAccelertionData:accelerometerData.acceleration];
                                                             if(error){
                                                                 
                                                                 NSLog(@"%@", error);
                                                             }
                                                         }];
        
        [[appdelgate motionManager] startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                                withHandler:^(CMGyroData *gyroData, NSError *error) {
                                                    [self outputRotationData:gyroData.rotationRate];
                                                }];
        
        
        //memory usage <45%
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                           withHandler:^ (CMDeviceMotion *motionData, NSError *error) {
                                               CMAttitude *attitude = motionData.attitude;
                                               /* CMAcceleration gravity = motionData.gravity;
                                                CMAcceleration userAcceleration = motionData.userAcceleration;
                                                CMRotationRate rotate = motionData.rotationRate;
                                                CMCalibratedMagneticField field = motionData.magneticField;*/
                                               [self outputDeviceMotionData:attitude];
                                           }];
        
        /*
         memory usage 48%
         [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical toQueue:[NSOperationQueue currentQueue]
         withHandler:^ (CMDeviceMotion *motionData, NSError *error) {
         CMAttitude *attitude = motionData.attitude;
         CMAcceleration gravity = motionData.gravity;
         CMAcceleration userAcceleration = motionData.userAcceleration;
         CMRotationRate rotate = motionData.rotationRate;
         CMCalibratedMagneticField field = motionData.magneticField;
         [self outputDeviceMotionData:attitude];
         }];
         */
    }
    
    else
    {
        NSLog(@"No device motion on device.");
    }
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    self.accX.text = [NSString stringWithFormat:@" %.2fg",acceleration.x];
    if(fabs(acceleration.x) > fabs(currentMaxAccelX))
    {
        currentMaxAccelX = acceleration.x;
    }
    self.accY.text = [NSString stringWithFormat:@" %.2fg",acceleration.y];
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
    self.accZ.text = [NSString stringWithFormat:@" %.2fg",acceleration.z];
    if(fabs(acceleration.z) > fabs(currentMaxAccelZ))
    {
        currentMaxAccelZ = acceleration.z;
    }
    
    
}
-(void)outputRotationData:(CMRotationRate)rotation
{
    self.rotX.text = [NSString stringWithFormat:@" %.2fr/s",rotation.x];
    if(fabs(rotation.x) > fabs(currentMaxRotX))
    {
        currentMaxRotX = rotation.x;
    }
    self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    if(fabs(rotation.y) > fabs(currentMaxRotY))
    {
        currentMaxRotY = rotation.y;
    }
    self.rotZ.text = [NSString stringWithFormat:@" %.2fr/s",rotation.z];
    if(fabs(rotation.z) > fabs(currentMaxRotZ))
    {
        currentMaxRotZ = rotation.z;
    }
    
}
-(void)outputDeviceMotionData:(CMAttitude*)attitude
{
    //uses euler angles
    /*  self.roll.text = [NSString stringWithFormat:@"%.2f degrees",radiansToDegrees(attitude.roll)];
     self.pitch.text = [NSString stringWithFormat:@"%.2f degrees",radiansToDegrees(attitude.pitch)];
     self.yaw.text = [NSString stringWithFormat:@"%.2f degrees",radiansToDegrees(attitude.yaw)]
     ;
     */
    //use of quaternions
    CMQuaternion quat = attitude.quaternion;
    self.roll.text = [NSString stringWithFormat:@"%.2f degrees",radiansToDegrees(atan2(2*(quat.y*quat.w - quat.x*quat.z), 1 - 2*quat.y*quat.y - 2*quat.z*quat.z))];
    self.pitch.text = [NSString stringWithFormat:@"%.2f degrees",radiansToDegrees(atan2(2*(quat.x*quat.w + quat.y*quat.z), 1 - 2*quat.x*quat.x - 2*quat.z*quat.z))];
    self.yaw.text = [NSString stringWithFormat:@"%.2f degrees",radiansToDegrees(2*(quat.x*quat.y + quat.w*quat.z))];
    
}


@end