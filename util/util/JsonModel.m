//
//  HttpModel.swift
//  LinClient
//
//  Created by lin on 1/13/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

//import Foundation
#import <Foundation/Foundation.h>
#import "JsonModel.h"
#import "json.h"




@implementation Json(JsonModel)
////public func asObjectArray<T:JsonModel>(item itemCreate:(Json)->T)->[T]
-(NSArray *)asObjectArray:(JsonModel *(^)(Json * json))itemCreate{
    if (self.isArray) {
        //return (BOOL)self.value;
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSArray * arrayValue = (NSArray *)self.value;
//        for (int n=0; n<arrayValue.count; n++) {
//            [array addObject:arrayValue[n]];
//        }
        for (int n=0; n<self.length; n++) {
            [array addObject:itemCreate([[Json alloc] initWithObject:arrayValue[n]])];
        }
        return array;
    }
    return nil;
}
@end


@implementation JsonModel

//@property(atomic,readonly) Json * json;
//@property(atomic,readonly) NSString * description;
-(NSString*)description{
    return [self.json toString];
}

-(id)initWithJson:(Json*)json{
    self = [super init];
    if (self) {
        self->_json = json;
    }
    return self;
}
-(id)init{
    self = [super init];
    if (self) {
        self->_json = [[Json alloc] init];
    }
    return self;
}
-(void)assign:(JsonModel*)model{
    self->_json = model.json;
}


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

@implementation JsonModel (InstanceProperties)

-(BOOL)hasValue:(NSString*)name{
    return [self.json hasValue:name];
}

- (void)setObject:(Json *)object forKeyedSubscript:(NSString *)name{
    [self.json setObject:object forKeyedSubscript:name];
}
- (Json *)objectForKeyedSubscript:(NSString *)name{
    return [self.json objectForKeyedSubscript:name];
}

//- (void)setValue:(NSString*)name value:(NSObject *)value{
//    [self.json setValue:name value:value];
//}
- (void)setValue:(NSObject*)value forName:(NSString *)name{
    if ([value isKindOfClass:[JsonModel class]]) {
        [self.json setValue:((JsonModel*)value).json.value forName:name];
    }else if([value isKindOfClass:[NSArray class]]){
        NSArray * arr = (NSArray*)value;
        NSMutableArray * newArr = [[NSMutableArray alloc] init];
        for (NSObject * item in arr) {
            if ([item isKindOfClass:[JsonModel class]]) {
                [newArr addObject:((JsonModel*)item).json];
            }else{
                [newArr addObject:item];
            }
        }
        [self.json setValue:newArr forName:name];
    }else{
        [self.json setValue:value forName:name];
    }
}

- (void)setIntValue:(int)value forName:(NSString *)name{
    [self.json setIntValue:value forName:name];
}
- (void)setLongValue:(long)value forName:(NSString *)name{
    [self.json setLongValue:value forName:name];
}
- (void)setUIntValue:(uint)value forName:(NSString *)name{
    [self.json setUIntValue:value forName:name];
}
- (void)setDoubleValue:(double)value forName:(NSString *)name{
    [self.json setDoubleValue:value forName:name];
}

- (void)setBoolValue:(BOOL)value forName:(NSString *)name{
    [self.json setBoolValue:value forName:name];
}

- (NSObject *)getValue:(NSString*)name{
    return [self.json getValue:name];
}
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
