//
//  UserDefaults.swift
//  LinCore
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 lin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UserDefaults.h"



@interface UserDefaultsImpl (){
    @private
    NSUserDefaults * defaults;
}

@end


@implementation UserDefaultsImpl

-(id)init{
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}


- (void)setObject:(NSString *)object forKeyedSubscript:(NSString *)key{
    [defaults setObject:object forKey:key];
}

- (NSString *)objectForKeyedSubscript:(NSString *)key{
    return [defaults stringForKey:key];
}


-(NSObject*)objectForKey:(NSString*)defaultName{
    return [defaults objectForKey:defaultName];
}

-(void)setObject:(NSObject*)value forKey:(NSString*)defaultName{
    [defaults setObject:value forKey:defaultName];
}

-(void)removeObjectForKey:(NSString*)defaultName{
    [defaults removeObjectForKey:defaultName];
}

-(NSString*)stringForKey:(NSString*)defaultName{
    return [defaults stringForKey:defaultName];
}

-(NSArray*)arrayForKey:(NSString*)defaultName{
    return [defaults arrayForKey:defaultName];
}

-(NSDictionary*)dictionaryForKey:(NSString*)defaultName{
    return [defaults dictionaryForKey:defaultName];
}

-(NSData*)dataForKey:(NSString*)defaultName{
    return [defaults dataForKey:defaultName];
}

-(NSArray*)stringArrayForKey:(NSString*)defaultName{
    return [defaults stringArrayForKey:defaultName];
}

-(NSInteger)integerForKey:(NSString*)defaultName{
    return [defaults integerForKey:defaultName];
}

-(float)floatForKey:(NSString*)defaultName{
    return [defaults floatForKey:defaultName];
}

-(BOOL)boolForKey:(NSString*)defaultName{
    return [defaults boolForKey:defaultName];
}

-(double)doubleForKey:(NSString*)defaultName{
    return [defaults doubleForKey:defaultName];
}

-(NSURL*)URLForKey:(NSString*)defaultName{
    return [defaults URLForKey:defaultName];
}


-(NSString*)stringForKey:(NSString*)defaultName defalutValue:(NSString*)defalutValue{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    return (NSString *)obj;
}
-(NSArray*)arrayForKey:(NSString*)defaultName defalutValue:(NSArray*)defalutValue{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    return (NSArray *)obj;
}
-(NSDictionary*)dictionaryForKey:(NSString*)defaultName defalutValue:(NSDictionary*)defalutValue{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    return (NSDictionary *)obj;
}
-(NSData*)dataForKey:(NSString*)defaultName defalutValue:(NSData*)defalutValue{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    return (NSData *)obj;
}
-(NSArray*)stringArrayForKey:(NSString*)defaultName defalutValue:(NSArray*)defalutValue{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    return (NSArray *)obj;
}
-(NSInteger)integerForKey:(NSString*)defaultName defalutValue:(NSInteger)defalutValue{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    NSNumber * num = (NSNumber *)obj;
    return [num integerValue];
}
-(float)floatForKey:(NSString*)defaultName defalutValue:(float)defalutValue{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    NSNumber * num = (NSNumber *)obj;
    return [num floatValue];
}
-(BOOL)boolForKey:(NSString*)defaultName defalutValue:(BOOL)defalutValue{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    NSNumber * num = (NSNumber *)obj;
    return [num boolValue];
}
-(double)doubleForKey:(NSString*)defaultName defalutValue:(double)defalutValue;{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    NSNumber * num = (NSNumber *)obj;
    return [num doubleValue];
}
-(NSURL*)URLForKey:(NSString*)defaultName defalutValue:(NSURL*)defalutValue{
    NSObject * obj = [self objectForKey:defaultName];
    if (obj == nil) {
        return defalutValue;
    }
    return (NSURL *)obj;
}



-(void)setInteger:(int)value forKey:(NSString*)defaultName{
    [defaults setInteger:value forKey:defaultName];
}

-(void)setDouble:(double)value forKey:(NSString*)defaultName{
    [defaults setDouble:value forKey:defaultName];
}

-(void)setBool:(BOOL)value forKey:(NSString*)defaultName{
    [defaults setBool:value forKey:defaultName];
}

-(void)setURL:(NSURL*)value forKey:(NSString*)defaultName{
    [defaults setURL:value forKey:defaultName];
}

-(BOOL)synchronize{
    return [defaults synchronize];
}

-(BOOL)objectIsForcedForKey:(NSString*)key{
    return [defaults objectIsForcedForKey:key];
}


@end

const UserDefaultsImpl * UserDefaults;

class UserDefaultsInit{
public:
    UserDefaultsInit(){
        UserDefaults = [[UserDefaultsImpl alloc] init];
    }
};
UserDefaultsInit __UserDefaultsImplA;


