//
//  NSExceptions.m
//  LinCore
//
//  Created by lin on 2/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "NSExceptions.h"

@implementation NSException(LinCore)

-(NSString *)toString{
    const char * method = __FUNCTION__;
    NSString * file = @__FILE__;
    int line = __LINE__;
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@:%@",self.name,self.reason];
    [str appendFormat:@"\n%@:%@",@"type:",self.name];
    [str appendFormat:@"\n%@:%@",@"value:",self.reason];
    if (method != nil && file != nil && line > 0) {
        [str appendFormat:@"\nfilename:%@\tfunction:%s\tline:%d",file,method,line];
    }
//    NSLog(@"desc:%@",self.description);
//    NSLog(@"desc:%@",self.debugDescription);
////    NSLog(@"string:%@",self.toString);
//    NSLog(@"user info:%@",self.userInfo);
////    NSLog(@"version:%@",self.version);
    NSArray * callStack = self.callStackSymbols;
    if (callStack != nil) {
        for (NSObject * call in callStack) {
            [str appendFormat:@"\nfunction:%@",call];
        }
    }
    return str;
}

@end

