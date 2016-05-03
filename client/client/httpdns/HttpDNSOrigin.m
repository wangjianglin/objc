//
//  HttpDNSOrigin.m
//  LinClient
//
//  Created by lin on 4/28/16.
//  Copyright © 2016 lin. All rights reserved.
//

#import "HttpDNSOrigin.h"

@implementation HttpDNSOrigin

-(id)initWithHost:(NSString*)host
{
    if (self = [super init]) {
        _host = host;
    }
    return self;
}


-(BOOL)isExpired
{
    return _query + _ttl < [[NSDate date] timeIntervalSince1970];
}

-(NSString*)getIp
{
    return _ips ? [_ips objectAtIndex:0] : nil;
}


-(NSArray*)getIps
{
    return _ips;
}
@end

