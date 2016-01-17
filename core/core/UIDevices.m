//
//  UIDevices.m
//  seller iOS7
//
//  Created by lin on 2/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "UIDevices.h"


@implementation UIDevice(LinCore)

-(NSString*)orientationString{
    switch (self.orientation) {
        case UIDeviceOrientationUnknown:
            return @"Unknown";
            case UIDeviceOrientationPortrait:
            return @"Portrait";
            case UIDeviceOrientationPortraitUpsideDown:
            return @"PortraitUpsideDown";
        case UIDeviceOrientationLandscapeLeft:
            return @"LandscapeLeft";
        case UIDeviceOrientationLandscapeRight:
            return @"LandscapeRight";
        case UIDeviceOrientationFaceUp:
            return @"FaceUp";
        case UIDeviceOrientationFaceDown:
            return @"FaceDown";
            
        default:
            break;
    }
}

-(NSString*)batteryStateString{
    switch (self.batteryState) {
        case UIDeviceBatteryStateUnknown:
            return @"Unknown";
            case UIDeviceBatteryStateUnplugged:
            return @"Unplugged";
            case UIDeviceBatteryStateCharging:
            return @"Charging";
            case UIDeviceBatteryStateFull:
            return @"Full";
        default:
            break;
    }
}

-(NSString*)userInterfaceIdiomString{
    switch (self.userInterfaceIdiom) {
//        case UIUserInterfaceIdiomUnspecified:
//            return @"Unspecified";
        case UIUserInterfaceIdiomPhone:
            return @"Phone";
        case UIUserInterfaceIdiomPad:
            return @"Pad";
        default:
            break;
    }
    return @"Unspecified";
}

-(NSString *)toString{

    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@%@",@"name:",self.name];
    [str appendFormat:@"\n%@%@",@"model:",self.model];
    [str appendFormat:@"\n%@%@",@"localizedModel:",self.localizedModel];
    [str appendFormat:@"\n%@%@",@"systemName:",self.systemName];
    [str appendFormat:@"\n%@%@",@"systemVersion:",self.systemVersion];
    [str appendFormat:@"\n%@%@",@"orientation:",[self orientationString]];
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0) {
//        [str appendFormat:@"\n%@%@",@"identifierForVendor:",[[self identifierForVendor] description]];
//    }else{
//        [str appendString:@"\nidentifierForVendor:nil"];
//    }
    [str appendFormat:@"\n%@%d",@"generatesDeviceOrientationNotifications:",self.generatesDeviceOrientationNotifications];
    [str appendFormat:@"\n%@%d",@"batteryMonitoringEnabled:",self.batteryMonitoringEnabled];
    [str appendFormat:@"\n%@%@",@"batteryState:",[self batteryStateString]];
    [str appendFormat:@"\n%@%f",@"batteryLevel:",self.batteryLevel];
    [str appendFormat:@"\n%@%d",@"proximityMonitoringEnabled:",self.proximityMonitoringEnabled];
    [str appendFormat:@"\n%@%d",@"multitaskingSupported:",self.multitaskingSupported];
    [str appendFormat:@"\n%@%@",@"userInterfaceIdiom:",[self userInterfaceIdiomString]];

    return str;
}

@end