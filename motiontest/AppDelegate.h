//
//  AppDelegate.h
//  motiontest
//
//  Created by Ankit Batra on 15/06/14.
//  Copyright (c) 2014 new. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CMMotionManager *motionManager;
}
@property (strong, nonatomic) UIWindow *window;
@property (readonly) CMMotionManager *motionManager;

-(CMMotionManager *) motionManager;
@end
