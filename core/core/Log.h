//
//  Log.h
//  LinCore
//
//  Created by lin on 1/29/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LogLevel) {
    LogLevelOff=0,LogLevelError=3,LogLevelWarn=4,LogLevelInfo=6,LogLevelDebug = 7,LogLevelTrace=8,LogLevelAll=9
};

@interface Log : NSObject

-initWithName:(NSString*)name;

@property LogLevel level;
@property(readonly) NSString* name;

-(void)info:(NSString*)infoStr;
-(void)error:(NSString*)errorStr;
-(void)warn:(NSString*)warnStr;
-(void)debug:(NSString*)debugStr;
-(void)trace:(NSString*)traceStr;
+(Log*)log;

@end
