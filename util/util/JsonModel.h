//
//  HttpModel.swift
//  LinClient
//
//  Created by lin on 1/13/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

//import Foundation
#import <Foundation/Foundation.h>
#import "json.h"


@class JsonModel;

@interface Json(JsonModel)

-(NSArray *)asObjectArray:(JsonModel *(^)(Json * json))itemCreate;

@end

@interface JsonModel : NSObject

@property(atomic,readonly) Json * json;
@property(atomic,readonly) NSString * description;

-(id)initWithJson:(Json*)json;
-(id)init;
-(void)assign:(JsonModel*)model;


@end
//public class JsonModel{
//    
//    private var _json:Json;
//    public var json:Json{
//        return _json;
//    }
//    public init(json:Json){
//        self._json = json;
//    }
//    
//    public init(){
//        self._json = Json();
//    }
//    
//    public func assign(mode:JsonModel){
//        self._json = mode._json;
//    }
//    
////    deinit {
////        //执行析构
////        println("Json Model deinit.");
////    }
//    public var description:String { return self._json.description; }
//}
//

@interface JsonModel (InstanceProperties)

-(BOOL)hasValue:(NSString*)name;

- (void)setObject:(Json *)object forKeyedSubscript:(NSString *)name;
- (Json *)objectForKeyedSubscript:(NSString *)name;

//- (void)setValue:(NSString*)name value:(NSObject *)value;
- (void)setValue:(NSObject*)value forName:(NSString *)name;
- (void)setIntValue:(int)value forName:(NSString *)name;
- (void)setLongValue:(long)value forName:(NSString *)name;
- (void)setUIntValue:(uint)value forName:(NSString *)name;
- (void)setDoubleValue:(double)value forName:(NSString *)name;
- (void)setBoolValue:(BOOL)value forName:(NSString *)name;
- (NSObject *)getValue:(NSString*)name;
@end
//extension JsonModel{
//    
//    
//    public subscript(name:String) -> Json {
//        get { return self._json[name];}
//        set { self.json[name] = newValue;}
//    }
//    
//    public func setValue(name:String,value:AnyObject?){
//        self._json.setValue(name, value: value);
//    }
//    public func getValue(name:String)->AnyObject?{
//        return self._json.getValue(name);
//    }
//    
//}
