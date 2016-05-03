//
//  HttpDNS.h
//  LinClient
//
//  Created by lin on 4/28/16.
//  Copyright © 2016 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpDNSDegradationDelegate <NSObject>

- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName;

@end

@protocol HttpDNS <NSObject>

/*
 *   超时域名是否还生效接口
 *
 */
-(void)setExpiredIpAvailable:(BOOL)flags;

-(BOOL)isExpiredIpAvailable;

/*
 * 获取一个IP
 */
-(NSString*)getIpByHost:(NSString*)host;


/*
 * 获取多个IP的接口 NSArray
 * 里面都是NSString的类型IP地址
 */
-(NSArray*)getIpsByHost:(NSString*)host;


//-(void)setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)delegate;
@property (nonatomic, weak) id<HttpDNSDegradationDelegate> delegate;

-(void)setPreResolveHosts:(NSArray*)hosts;
@end
