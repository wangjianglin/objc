//
//  Global.swift
//  LinCore
//
//  Created by lin on 1/11/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Global.h"

@interface GlobalArgs (){
    @private
    NSMutableDictionary * datas;
}

@end

@implementation GlobalArgs

-(id)init{
    self = [super init];
    if (self) {
        datas = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setObject:(NSObject *)object forKeyedSubscript:(NSString *)key{
    datas[key] = object;
}

- (NSObject *)objectForKeyedSubscript:(NSString *)key{
    return datas[key];
}

-(void)remove:(NSString*)key{
    [datas removeObjectForKey:key];
}

@end

const GlobalArgs * Global;

class GlobalInit{
public:
    GlobalInit(){
        Global = [[GlobalArgs alloc] init];
    }
};

GlobalInit a;
