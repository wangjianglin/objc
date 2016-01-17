//
//  LocalStorage.h
//  LinCore
//
//  Created by lin on 8/12/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStorage : NSObject

+(void)clean;

+(void)setItem:(NSObject*)value forName:(NSString*)name;

+(void)remove:(NSString*)name;

+(NSObject*)getItem:(NSString*)name;

+(NSString*)getStringItem:(NSString*)name;

+(NSObject*)getItem:(NSString*)name type:(Class)type;


@end
