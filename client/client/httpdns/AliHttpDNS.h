//
//  AliHttpDNS.h
//  LinClient
//
//  Created by lin on 4/28/16.
//  Copyright © 2016 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDNS.h"

@interface AliHttpDNS<HttpDNS> : NSObject
@property (nonatomic, weak) id<HttpDNSDegradationDelegate> delegate;
-(id)initWithAccount:(NSString*)account;

//-(void)setPreResolveHosts:(NSArray*)hosts;

@end
