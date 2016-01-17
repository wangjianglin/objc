//
//  json.h
//  json
//
//  Created by Dan Kogai on 7/15/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
//import Foundation
#import <Foundation/Foundation.h>
/// init
@interface Json : NSObject

@property NSObject * value;

-(id)initWithIsArray:(BOOL)isArray;

//-(id)initWithIsArray;

-(id)initWithObject:(NSObject *) obj;

-(id)initWithJson:(Json*)json;

@property(atomic,readonly)NSString * description;
-(NSString*)copyDescription;
@end
//public class Json {
//    private var _value:AnyObject
//    public var value:AnyObject{return self._value;}
//    public init(isArray:Bool = false){
//        if isArray {
//            _value = [AnyObject]();
//        }else{
//            _value = Dictionary<String,AnyObject>();
//        }
//    }
//    /// pass the object that was returned from
//    /// NSJSONSerialization
//    public init(_ obj:AnyObject) {self._value = obj}
//    /// pass the JSON object for another instance
//    public init(_ json:Json){ self._value = json._value; }
//    
//    public var description:String { return toString() }
//    
//    public func copyDescription()->String{return toString();}
//}
//
@interface Json (JsonCopy)
-(Json *)copy;
@end

//extension Json {
//    public func copy()->Json{
//        return Json(string:self.toString());
//    }
//}
///// class properties
//typedef Foundation.NSNull NSNull;

@interface Json (JsonClassProperties)

+(NSNull * )null;

-(id)initWithData:(NSData *)data;
-(id)initWithString:(NSString*)string;
+(Json*)parse:(NSString*)string;
-(id)initWithNSURL:(NSURL*)url;
-(id)initWithUrl:(NSString*)url;
+(Json*)fromURL:(NSString*)url;
+(NSString*)stringify:(NSObject*)obj pretty:(BOOL)pretty;
+(NSString*)stringify:(NSObject*)obj;
@end

@interface Json (InstanceProperties)

-(BOOL)hasValue:(NSString*)name;
-(BOOL)hasValue;

- (void)setObject:(Json *)object forKeyedSubscript:(NSString *)aKey;
- (Json *)objectForKeyedSubscript:(NSString *)key;

- (void)setObject:(Json *)anObject atIndexedSubscript:(NSUInteger)index;
- (Json *)objectAtIndexedSubscript:(NSUInteger)idx;

//- (void)setValue:(NSString*)name value:(NSObject *)value;
- (void)setValue:(NSObject*)value forName:(NSString *)name;
- (void)setIntValue:(int)value forName:(NSString *)name;
- (void)setLongValue:(long)value forName:(NSString *)name;
- (void)setUIntValue:(uint)value forName:(NSString *)name;
- (void)setDoubleValue:(double)value forName:(NSString *)name;
- (void)setBoolValue:(BOOL)value forName:(NSString *)name;
- (NSObject *)getValue:(NSString*)name;
- (void)remove:(NSString*)name;
//- (NSObject*)data;
//- (NSString*)type;

@property(atomic,readonly) BOOL isError;
@property(atomic,readonly) NSString * type;
@property(atomic,readonly) BOOL isNull;
@property(atomic,readonly) BOOL isBool;
@property(atomic,readonly) BOOL isInt;
@property(atomic,readonly) BOOL isUInt;
@property(atomic,readonly) BOOL isDouble;
@property(atomic,readonly) BOOL isNumber;
@property(atomic,readonly) BOOL isString;
@property(atomic,readonly) BOOL isArray;
@property(atomic,readonly) BOOL isDictionary;
@property(atomic,readonly) BOOL isLeaf;
@property(atomic,readonly) BOOL isDate;

-(NSError *) asError;
-(NSNull *) asNull;
-(BOOL)asBool;
-(BOOL)asBool:(BOOL)def;
-(int)asInt;
-(int)asInt:(int)def;
-(long)asLong;
-(long)asLong:(long)def;
-(uint)asUInt;
-(uint)asUInt:(uint)def;
-(double)asDouble;
-(double)asDouble:(double)def;
-(NSNumber*)asNumber;
-(double)asNumber:(double)def;
-(NSString*)asString;
-(NSString*)asString:(NSString*)def;
-(NSArray *)asArray;
-(NSArray*)asArray:(Json *(^)(Json * json))itemCreate;
//-(Json*)asObject:(Json *(^)(Json *))itemCreate;
//public func asObjectArray<T:JsonModel>(item itemCreate:(Json)->T)->[T]

-(NSDictionary *)asDictionary;
-(NSDate *)asDate;
-(NSDate *)asDateDef;
//-(NSDate *)asObject;

@property(atomic,readonly)NSUInteger length;
@end


//extension Json : SequenceType {
//    public func generate()->GeneratorOf<(AnyObject,Json)> {
//        switch _value {
//        case let o as NSArray:
//            var i = -1
//            return GeneratorOf<(AnyObject, Json)> {
//                if ++i == o.count { return nil }
//                return (i, Json(o[i]))
//            }
//        case let o as NSDictionary:
//            var ks = o.allKeys.reverse()
//            return GeneratorOf<(AnyObject, Json)> {
//                if ks.isEmpty { return nil }
//                let k = ks.removeLast() as String
//                return (k, Json(o.valueForKey(k)!))
//            }
//        default:
//            return GeneratorOf<(AnyObject, Json)>{ nil }
//        }
//    }
//    public func mutableCopyOfTheObject() -> AnyObject {
//        return _value.mutableCopy()
//    }
//}
@interface Json (JsonPrintable)

-(NSString*)toString:(BOOL)pretty;
-(NSString*)toString;
@end

@interface Json (JsonParams)

-(NSDictionary*)toParams;
-(NSDictionary*)toParams:(BOOL)includeNull;

@end
