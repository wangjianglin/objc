//
//  TestHttpPackage.m
//  demo
//
//  Created by lin on 4/29/16.
//  Copyright © 2016 lin. All rights reserved.
//

#import "TestHttpPackage.h"

@implementation TestHttpPackage

-(id)init{
    return [super initWithUrl:@"/core/comm/test.action" method:GET];
}

-(NSObject*)getResult:(Json *)json{
    return [json asString:@""];
}

-(NSString*)data{
    return [self[@"data"] asString:@""];
}

-(void)setData:(NSString *)data{
    [self setValue:data forName:@"data"];
}
@end
