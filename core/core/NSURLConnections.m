//
//  NSURLConnections.m
//  LinCore
//
//  Created by lin on 4/14/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "NSURLConnections.h"

@implementation NSURLConnection(LinCore)


+(NSString*)data:(NSString *)url{
    NSURL * nsurl = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:nsurl];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data != nil) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
