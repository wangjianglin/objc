//
//  Log.m
//  LinCore
//
//  Created by lin on 1/29/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Log.h"
#import "LinUtil/util.h"
//#import "LinCore/core.h"
#import "UIDevices.h"

@implementation Log


-(id)initWithName:(NSString *)name{
    self =[super init];
    if(self){
        _name = name;
        self.level = LogLevelInfo;
    }
    return self;
}

-(void)info:(NSString *)infoStr{
    [Log logStr:_name str:infoStr level:LogLevelInfo log:self];
}

-(void)error:(NSString *)errorStr{
    [Log logStr:_name str:errorStr level:LogLevelError log:self];
}

-(void)warn:(NSString *)warnStr{
    [Log logStr:_name str:warnStr level:LogLevelWarn log:self];
}

-(void)debug:(NSString *)debugStr{
    [Log logStr:_name str:debugStr level:LogLevelDebug log:self];
}

-(void)trace:(NSString *)traceStr{
    [Log logStr:_name str:traceStr level:LogLevelTrace log:self];
}

+(Log *)log{
    static dispatch_once_t __log_log_once_t_ = 0;
    static Log * __log_log_install_ = nil;
    dispatch_once(&__log_log_once_t_, ^{
        __log_log_install_ = [[Log alloc] initWithName:@"log"];
    });
    return __log_log_install_;
}

+(NSLock*)lock{
    static dispatch_once_t __log_log_lock_once_t = 0;
    static NSLock * __log_log_lock_install_ = nil;
    dispatch_once(&__log_log_lock_once_t, ^{
        __log_log_lock_install_ = [[NSLock alloc] init];
    });
    return __log_log_lock_install_;
}

+(void)logStr:(NSString*)name str:(NSString*)str level:(LogLevel)level log:(Log*)log{

    if (level > log.level) {
        return;
    }
    NSString * newStr = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
    NSDate * date = [[NSDate alloc] init];
    NSString * filename = [Log getFilename:name date:date];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [[Log lock] lock];
    [Log logStrImpl:[[NSString alloc] initWithFormat:@"[%@]%@ %@\n",[Log levelToString:level],[format stringFromDate:date],newStr] filename:filename];
    [[Log lock] unlock];
}
+(NSString*)levelToString:(LogLevel)level{
    switch(level){
        case LogLevelOff:
            return @"Off";
        case LogLevelError:
            return @"Error";
        case LogLevelWarn:
            return @"Warn";
        case LogLevelInfo:
            return @"Info";
        case LogLevelDebug:
            return @"Debug";
        case LogLevelTrace:
            return @"Trace";
        case LogLevelAll:
            return @"All";
    }
    
    return @"";
}

+(NSString*)getFilename:(NSString*)name date:(NSDate*)date{

    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString * path = pathFor(DocumentsDocument, @"log");

    BOOL isDir = FALSE;
    [fileManager fileExistsAtPath:path isDirectory:&isDir];

    if (!isDir) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:TRUE attributes:nil error:nil];
    }
    
    NSString * filename = [[NSString alloc] initWithFormat:@"%@/%@-%@.txt",path,name,[format stringFromDate:date]];

    for (int n=1; ; n++) {
        if ([fileManager fileExistsAtPath:filename]) {
            NSObject * filesizeObj = [fileManager attributesOfItemAtPath:filename error:nil][@"NSFileSize"];
            int filesize = [((NSNumber*)filesizeObj) intValue];
            if (filesize > 600 * 1024) {
                filename = [[NSString alloc] initWithFormat:@"%@/%@-%@-%d.txt",path,name,[format stringFromDate:date],n];
                continue;
            }
        }
        break;
    }

    if (![fileManager fileExistsAtPath:filename]) {
        NSString * str = [[NSString alloc] initWithFormat:@"%@%@",[[UIDevice currentDevice] toString],@"\n\n"];
        [fileManager createFileAtPath:filename contents:[str dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }

    return filename;
}

+(void)logStrImpl:(NSString*)str filename:(NSString*)filename{

    NSFileHandle * outFile = [NSFileHandle fileHandleForWritingAtPath:filename];
    if (outFile == nil) {
        return;
    }

    [outFile seekToEndOfFile];

    NSData * buffer = [str dataUsingEncoding:NSUTF8StringEncoding];
    if (buffer != nil) {
        [outFile writeData:buffer];
    }
    [outFile closeFile];

}
@end