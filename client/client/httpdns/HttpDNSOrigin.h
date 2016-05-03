//
//  HttpDNSOrigin.h
//  LinClient
//
//  Created by lin on 4/28/16.
//  Copyright © 2016 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpDNSOrigin : NSObject
@property(nonatomic, copy, readonly) NSString* host;
@property(nonatomic, strong) NSArray* ips;
@property(nonatomic,assign) long ttl;
@property(nonatomic,assign) long query;

-(id)initWithHost:(NSString*)host;

-(BOOL)isExpired;

-(NSString*)getIp;

-(NSArray*)getIps;

@end