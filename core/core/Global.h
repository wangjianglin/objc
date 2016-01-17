//
//  Global.swift
//  LinCore
//
//  Created by lin on 1/11/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface GlobalArgs : NSObject

- (void)setObject:(NSObject *)object forKeyedSubscript:(NSString *)key;
- (NSObject *)objectForKeyedSubscript:(NSString *)key;
-(void)remove:(NSString*)key;

@end

extern const GlobalArgs * Global;
