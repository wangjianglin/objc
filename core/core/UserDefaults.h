//
//  UserDefaults.swift
//  LinCore
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserDefaultsImpl : NSObject


- (void)setObject:(NSString *)object forKeyedSubscript:(NSString *)key;
- (NSString *)objectForKeyedSubscript:(NSString *)key;

-(NSObject*)objectForKey:(NSString*)defaultName;
-(void)setObject:(NSObject*)value forKey:(NSString*)defaultName;
-(void)removeObjectForKey:(NSString*)defaultName;
-(NSString*)stringForKey:(NSString*)defaultName;
-(NSArray*)arrayForKey:(NSString*)defaultName;
-(NSDictionary*)dictionaryForKey:(NSString*)defaultName;
-(NSData*)dataForKey:(NSString*)defaultName;
-(NSArray*)stringArrayForKey:(NSString*)defaultName;
-(NSInteger)integerForKey:(NSString*)defaultName;
-(float)floatForKey:(NSString*)defaultName;
-(BOOL)boolForKey:(NSString*)defaultName;
-(double)doubleForKey:(NSString*)defaultName;
-(NSURL*)URLForKey:(NSString*)defaultName;

-(NSString*)stringForKey:(NSString*)defaultName defalutValue:(NSString*)defalutValue;
-(NSArray*)arrayForKey:(NSString*)defaultName defalutValue:(NSArray*)defalutValue;
-(NSDictionary*)dictionaryForKey:(NSString*)defaultName defalutValue:(NSDictionary*)defalutValue;
-(NSData*)dataForKey:(NSString*)defaultName defalutValue:(NSData*)defalutValue;
-(NSArray*)stringArrayForKey:(NSString*)defaultName defalutValue:(NSString*)defalutValue;
-(NSInteger)integerForKey:(NSString*)defaultName defalutValue:(NSInteger)defalutValue;
-(float)floatForKey:(NSString*)defaultName defalutValue:(float)defalutValue;
-(BOOL)boolForKey:(NSString*)defaultName defalutValue:(BOOL)defalutValue;
-(double)doubleForKey:(NSString*)defaultName defalutValue:(double)defalutValue;
-(NSURL*)URLForKey:(NSString*)defaultName defalutValue:(NSURL*)defalutValue;


-(void)setInteger:(int)value forKey:(NSString*)defaultName;
-(void)setDouble:(double)value forKey:(NSString*)defaultName;
-(void)setBool:(BOOL)value forKey:(NSString*)defaultName;
-(void)setURL:(NSURL*)value forKey:(NSString*)defaultName;
-(BOOL)synchronize;
-(BOOL)objectIsForcedForKey:(NSString*)key;
//-(BOOL)objectIsForcedForKey:(NSString*)key inDomain:(NSString*)domain;

@end

extern const UserDefaultsImpl * UserDefaults;

