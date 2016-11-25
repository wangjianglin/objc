//
//  json.h
//  json
//
//  Created by Dan Kogai on 7/15/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
//import Foundation
#import <Foundation/Foundation.h>
#import <Foundation/NSDateFormatter.h>
#import "json.h"

@interface Json(){
    // NSObject * _value;
}

@end


@implementation Json

@synthesize value;

-(id)initWithIsArray:(BOOL)isArray{
    self = [super init];
    if (self) {
        if (isArray) {
            self.value = [[NSMutableArray alloc] init];
        }else{
            self.value = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

-(id)init{
    self = [self initWithIsArray:false];
    return self;
}

-(id)initWithObject:(NSObject *) obj{
    self = [super init];
    if (self) {
        self.value = obj;
    }
    return self;
}

-(id)initWithJson:(Json*)json{
    self = [super init];
    if (self) {
        self.value = json.value;
    }
    return self;
}

//@property(atomic,readonly)NSString * description;
-(NSString*)description{
    return [self toString];
}
-(NSString*)copyDescription{
    return [self toString];
}
@end
/// init
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

@implementation Json (JsonCopy)

-(Json * ) copy{
    return [[Json alloc] initWithString:[self toString]];
}

@end

//extension Json {
//    public func copy()->Json{
//        return Json(string:self.toString());
//    }
//}
///// class properties
@implementation Json (JsonClassProperties)

+(NSNull * )null{
    //return [[NSNull alloc] init];
    return [NSNull null];
}
-(id)initWithData:(NSData *)data{
    NSError * error;
    NSObject * obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error == nil) {
        self = [self initWithObject:obj];
    }else{
        self = [self initWithObject:error];
    }
    //    self = [super init];
    //    if (self) {
    //
    //        //        var obj:AnyObject? = NSJSONSerialization.JSONObjectWithData(
    //        //            data, options:nil, error:&err
    //        //        )
    //        //        self.init(err != nil ? err! : obj!)
    //    }
    return self;
}
-(id)initWithString:(NSString*)string{
    //    let enc:NSStringEncoding = NSUTF8StringEncoding
    //        self.init(data: string.dataUsingEncoding(enc)!)
    
    self = [self initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    return self;
}
+(Json*)parse:(NSString*)string{
    return [[Json alloc] initWithString:string];
}
-(id)initWithNSURL:(NSURL*)url{
    NSError * err;
    NSStringEncoding enc = NSUTF8StringEncoding;
    NSString * str = [[NSString alloc] initWithContentsOfURL:url usedEncoding:&enc error:&err];
    if (err != nil) {
        self = [self initWithObject:err];
    }else{
        self = [self initWithString:str];
    }
    return self;
}
-(id)initWithUrl:(NSString*)url{
    
    NSURL * nsurl = [[NSURL alloc] initWithString:url];
    if (nsurl != nil) {
        self = [self initWithNSURL:nsurl];
    }else{
        NSError * error = [[NSError alloc] initWithDomain:@"JSONErrorDomain" code:400 userInfo:@{NSLocalizedDescriptionKey:@"malformed URL"}];
        self = [self initWithObject:error];
    }
    return self;
}
+(Json*)fromURL:(NSString*)url{
    return [[Json alloc] initWithUrl:url];
}
+(NSString*)stringify:(NSObject*)obj pretty:(BOOL)pretty{
    //    if !NSJSONSerialization.isValidJSONObject(obj) {
    //        //            Json(NSError(
    //        //                domain:"JSONErrorDomain",
    //        //                code:422,
    //        //                userInfo:[NSLocalizedDescriptionKey: "not an JSON object"]
    //        //                ))
    //        //            return nil
    //        //        }
    //        //        return Json(obj).toString(pretty:pretty)
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        //        NSDictionary * dic = [[NSDictionary alloc] init];
        //        [dic setValue:@"not an JSON object" forKey:NSLocalizedDescriptionKey];
        //        NSError * error = [[NSError alloc] initWithDomain:@"JSONErrorDomain" code:422 userInfo:dic];
        return nil;
    }
    return nil;
}
+(NSString*)stringify:(NSObject*)obj{
    return [Json stringify:obj pretty:FALSE];
}

@end


//extension Json {
//    public typealias NSNull = Foundation.NSNull
//    public typealias NSError = Foundation.NSError
//    public class var null:NSNull { return NSNull() }
//    /// constructs JSON object from data
//    public convenience init(data:NSData) {
//        var err:NSError?
//        var obj:AnyObject? = NSJSONSerialization.JSONObjectWithData(
//            data, options:nil, error:&err
//        )
//        self.init(err != nil ? err! : obj!)
//    }
//    /// constructs JSON object from string
//    public convenience init(string:String) {
//        let enc:NSStringEncoding = NSUTF8StringEncoding
//        self.init(data: string.dataUsingEncoding(enc)!)
//    }
//    /// parses string to the JSON object
//    /// same as JSON(string:String)
//    public class func parse(string:String)->Json {
//        return Json(string:string)
//    }
//    /// constructs JSON object from the content of NSURL
//    public convenience init(nsurl:NSURL) {
//        var enc:NSStringEncoding = NSUTF8StringEncoding
//        var err:NSError?
//        let str:String? =
//        NSString(
//            contentsOfURL:nsurl, usedEncoding:&enc, error:&err
//        )
//        if err != nil { self.init(err!) }
//        else { self.init(string:str!) }
//    }
//    /// fetch the JSON string from NSURL and parse it
//    /// same as JSON(nsurl:NSURL)
//    public class func fromNSURL(nsurl:NSURL) -> Json {
//        return Json(nsurl:nsurl)
//    }
//    /// constructs JSON object from the content of URL
//    public convenience init(url:String) {
//        if let nsurl = NSURL(string:url) as NSURL? {
//            self.init(nsurl:nsurl)
//        } else {
//            self.init(NSError(
//                domain:"JSONErrorDomain",
//                code:400,
//                userInfo:[NSLocalizedDescriptionKey: "malformed URL"]
//                )
//            )
//        }
//    }
//    /// fetch the JSON string from URL in the string
//    public class func fromURL(url:String) -> Json {
//        return Json(url:url)
//    }
//    /// does what JSON.stringify in ES5 does.
//    /// when the 2nd argument is set to true it pretty prints
//    public class func stringify(obj:AnyObject, pretty:Bool=false) -> String! {
//        if !NSJSONSerialization.isValidJSONObject(obj) {
//            Json(NSError(
//                domain:"JSONErrorDomain",
//                code:422,
//                userInfo:[NSLocalizedDescriptionKey: "not an JSON object"]
//                ))
//            return nil
//        }
//        return Json(obj).toString(pretty:pretty)
//    }
//}


@implementation Json (InstanceProperties)

-(BOOL)hasValue:(NSString *)name{
    if (self.isNull) {
        return FALSE;
    }
    Json * obj = self[name];
    return obj != nil && !obj.isNull;
}

-(BOOL)hasValue{
    return self.value != nil && ![self.value isKindOfClass:[NSNull class]];
}

- (void)setObject:(Json *)object forKeyedSubscript:(NSString *)name{
    [self setValue:object.value forName:name];
}
- (Json *)objectForKeyedSubscript:(NSString *)name{
    return [[Json alloc] initWithObject:[self getValue:name]];
}
//
- (void)setObject:(Json *)anObject atIndexedSubscript:(NSUInteger)index{
    
    NSMutableArray * array = (NSMutableArray *)self.value;
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
        self.value = array;
    }
    if (index < array.count) {
        array[index] = anObject.value;
    }else{
        @synchronized(self){
            NSUInteger count = array.count;
            while (count < index) {
                [array addObject:nil];
            }
            [array addObject:anObject.value];
        }
    }
}
- (Json *)objectAtIndexedSubscript:(NSUInteger)index;{
    
    if (self.isError) {
        return self;
    }
    if (!self.isArray) {
        
        NSError * error = [[NSError alloc] initWithDomain:@"JsonErrorDomain" code:500 userInfo:@{NSLocalizedDescriptionKey:@"not a array"}];
        return [[Json alloc] initWithObject:error];
    }
    NSArray * array = (NSArray *)self.value;
    if (index < array.count) {
        return [[Json alloc] initWithObject:array[index]];
    }
    
    NSError * error = [[NSError alloc] initWithDomain:@"JsonErrorDomain" code:404 userInfo:@{NSLocalizedDescriptionKey:[[NSString alloc] initWithFormat:@"[%lu] is out of range",(unsigned long)index]}];
    return [[Json alloc] initWithObject:error];
    
}

- (void)setIntValue:(int)_value forName:(NSString *)name{
    [self setValue:[[NSNumber alloc] initWithInt:_value] forName:name];
}

- (void)setLongValue:(long)_value forName:(NSString *)name{
    [self setValue:[[NSNumber alloc] initWithLong:_value] forName:name];
}

- (void)setUIntValue:(uint)_value forName:(NSString *)name{
    [self setValue:[[NSNumber alloc] initWithUnsignedInt:_value] forName:name];
}
- (void)setDoubleValue:(double)_value forName:(NSString *)name{
    [self setValue:[[NSNumber alloc] initWithDouble:_value] forName:name];
}
- (void)setBoolValue:(BOOL)_value forName:(NSString *)name{
    [self setValue:[[NSNumber alloc] initWithBool:_value] forName:name];
}
//
//- (void)setValue:(NSString*)name value:(NSObject *)value{

- (void)setValue:(NSObject*)_value forName:(NSString *)name{
    
    
    if (_value == nil) {
        [self remove:name];
    }else{
        @synchronized(self){
            while ([_value isKindOfClass:[Json class]]) {
                _value = ((Json*)_value).value;
            }
            NSMutableDictionary * dic = (NSMutableDictionary *)self.value;
            if (dic == nil) {
                dic = [[NSMutableDictionary alloc] init];
                self.value = dic;
            }
            
            [dic setObject:_value forKey:name];
        }
    }
}
- (NSObject *)getValue:(NSString*)name{
    if (self.isError) {
        return self;
    }
    if (!self.isDictionary) {
        //        NSDictionary * dic = [[NSDictionary alloc] init];
        //        [dic setValue:@"not an array" forKey:NSLocalizedDescriptionKey];
        //        NSError * error = [[NSError alloc] initWithDomain:@"JsonErrorDomain" code:500 userInfo:dic];
        //        return [[Json alloc] initWithObject:error];
        return nil;
    }
    NSDictionary * dic = self.asDictionary;
    
    NSObject * v = [dic valueForKey:name];
    
    return v;
}
- (void)remove:(NSString*)name{
    NSMutableDictionary * dic = (NSMutableDictionary *)self.value;
    if (dic != nil) {
        @synchronized(self) {
            [dic removeObjectForKey:name];
        }
    }
}
//- (NSObject*)data;
- (NSString*)type{
    //    switch _value {
    if ([self isKindOfClass:[NSError class]]) {
        return @"NSError";
    }
    if (self.value == nil || [self.value isKindOfClass:[NSNull class]]) {
        return @"NSError";
    }
    //    case is NSError:        return "NSError"
    //    case is NSNull:         return "NSNull"
    //    case let o as NSNumber:
    //        switch String.fromCString(o.objCType)! {
    //        case "c", "C":              return "Bool"
    //        case "q", "l", "i", "s":    return "Int"
    //        case "Q", "L", "I", "S":    return "UInt"
    //        default:                    return "Double"
    //        }
    if ([self.value isKindOfClass:[NSNumber class]]) {
        NSNumber * num = (NSNumber *)self.value;
        const char * str = num.objCType;
        if (str == nil || strlen(str) == 0) {
            return @"Double";
        }
        else if (str[0] == 'c' || str[0] == 'C') {
            return @"Bool";
        }
        else if (str[0] == 'q' || str[0] == 'l' || str[0] == 'i' || str[0] == 's') {
            return @"Int";
        }
        else if (str[0] == 'Q' || str[0] == 'L' || str[0] == 'I' || str[0] == 'S') {
            return @"UInt";
        }
        return @"Double";
    }
    if ([self.value isKindOfClass:[NSString class]]) {
        return @"String";
    }
    //    case is NSString:               return "String"
    //    case is NSArray:                return "Array"
    if ([self.value isKindOfClass:[NSArray class]]) {
        return @"Array";
    }
    //    case is NSDictionary:           return "Dictionary"
    if ([self.value isKindOfClass:[NSDictionary class]]) {
        return @"Dictionary";
    }
    //    case is NSDate:              return "Date"
    if ([self.value isKindOfClass:[NSDate class]]) {
        return @"Date";
    }
    //    default:                        return "NSError"
    //    }
    return @"NSError";
}
-(BOOL)isError{
    return [self.value isKindOfClass:[NSError class]];
}
//
//@property(atomic,readonly) BOOL isError;
//@property(atomic,readonly) BOOL isNull;
-(BOOL)isNull{
    return self.value == nil || [self.value isKindOfClass:[NSNull class]];
}
//@property(atomic,readonly) BOOL isBool;
-(BOOL)isBool{
    return [@"Bool" isEqualToString:self.type];
}
//@property(atomic,readonly) BOOL isInt;
-(BOOL)isInt{
    return [@"Int" isEqualToString:self.type];
}
//@property(atomic,readonly) BOOL isUInt;
-(BOOL)isUInt{
    return [@"UInt" isEqualToString:self.type];
}
//@property(atomic,readonly) BOOL isDouble;
-(BOOL)isDouble{
    return [@"Double" isEqualToString:self.type];
}
//@property(atomic,readonly) BOOL isNumber;
-(BOOL)isNumber{
    //return [@"Double" isEqualToString:self.type];
    return [self.value isKindOfClass:[NSNumber class]];
}
//@property(atomic,readonly) BOOL isString;
-(BOOL)isString{
    return [@"String" isEqualToString:self.type];
}
//@property(atomic,readonly) BOOL isArray;
-(BOOL)isArray{
    return [@"Array" isEqualToString:self.type];
}
//@property(atomic,readonly) BOOL isDictionary;
-(BOOL)isDictionary{
    return [@"Dictionary" isEqualToString:self.type];
}
//@property(atomic,readonly) BOOL isLeaf;
-(BOOL)isLeaf{
    return !(self.isArray || self.isDictionary || self.isError);
}
-(BOOL)isDate{
    return [@"Date" isEqualToString:self.type];
}
//
-(NSError *) asError{
    return (NSError*)self.value;
}
-(NSNull *) asNull{
    return self.isNull ? [Json null] : nil;
}
-(BOOL)asBool{
    if (self.isBool) {
        return (BOOL)self.value;
    }
    return FALSE;
}
-(BOOL)asBool:(BOOL)def{
    if (self.isBool) {
        return [(NSNumber*)self.value boolValue];
    }
    return def;
}
-(int)asInt{
    if (self.isNumber) {
        return [(NSNumber*)self.value intValue];
    }
    return 0;
}

-(int)asInt:(int)def{
    if (self.isNumber) {
        return [(NSNumber*)self.value intValue];
    }
    return def;
}
-(long)asLong{
    if (self.isNumber) {
        return [(NSNumber*)self.value longValue];
    }
    return 0;
}

-(long)asLong:(long)def{
    if (self.isNumber) {
        return [(NSNumber*)self.value longValue];
    }
    return def;
}
-(uint)asUInt{
    if (self.isNumber) {
        return [(NSNumber*)self.value unsignedIntValue];
    }
    return 0;
}
-(uint)asUInt:(uint)def{
    if (self.isNumber) {
        return [(NSNumber*)self.value unsignedIntValue];
    }
    return def;
}
-(double)asDouble{
    if (self.isNumber) {
        return [(NSNumber*)self.value doubleValue];
    }
    return 0;
}

-(double)asDouble:(double)def{
    if (self.isNumber) {
        return [(NSNumber*)self.value doubleValue];
    }
    return def;
}

-(NSNumber*)asNumber{
    //    return [self asDouble];
    if(self.isBool){
        return [[NSNumber alloc] initWithBool:self.asBool];
    }
    if(self.isInt){
        return [[NSNumber alloc] initWithInt:self.asInt];
    }
    if(self.isDouble){
        return [[NSNumber alloc] initWithDouble:self.asDouble];
    }
    return [[NSNumber alloc] init];
}

-(double)asNumber:(double)def{
    return [self asDouble:def];
}

-(NSString*)asString{
    if (self.value && ![self.value isKindOfClass:[NSNull class]]) {
        return (NSString*)self.value;
    }
    return nil;
}
-(NSString*)asString:(NSString*)def{
    if (self.value && ![self.value isKindOfClass:[NSNull class]]) {
        return (NSString*)self.value;
    }
    return def;
}
-(NSArray *)asArray{
    if (self.isArray) {
        //return (BOOL)self.value;
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSArray * arrayValue = (NSArray *)self.value;
        for (int n=0; n<arrayValue.count; n++) {
            [array addObject:[[Json alloc] initWithObject: arrayValue[n]]];
        }
        return array;
    }
    return nil;
}

-(NSDictionary *)asDictionary{
    if (self.isDictionary) {
        return (NSDictionary *)self.value;
    }
    return nil;
}
-(NSDate *)asDate{
    if (self.isDate) {
        return (NSDate *)self.value;
    }
    return nil;
}
-(NSDate *)asDateDef{
    NSDate * date = [self asDate];
    if (date == nil) {
        self.value = [[NSDate alloc] init];
    }
    return (NSDate *)self.value;
}
//-(NSObject *)asObject{
//    return nil;
//}
-(NSArray*)asArray:(Json *(^)(Json *))itemCreate{
    if (self.isArray) {
        //return (BOOL)self.value;
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSArray * arrayValue = (NSArray *)self.value;
        for (int n=0; n<arrayValue.count; n++) {
            [array addObject:itemCreate(arrayValue[n])];
        }
        return array;
    }
    return nil;
}
//-(Json*)asObject:(Json *(^)(Json *))itemCreate{
//
//}
//
//@property(atomic,readonly)int length;
-(NSUInteger)length{
    if (self.isArray) {
        return [(NSArray*)self.value count];
    }
    if (self.isDictionary) {
        return [(NSDictionary*)self.value count];
    }
    return 0;
}

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

@implementation Json (JsonPrintable)


-(NSString*)toString{
    return [self toString:false];
}
-(NSString*)toString:(BOOL)pretty{
    
    return [Json toStringJson:self.value];
}

//    public func toString(pretty:Bool=false)->String {
//
//        if let str = toStringJson(self){
//            return str;
//        }
//        return "";
//        //println("start.");
//

//    }
//
+(NSString*)toStringJson:(NSObject *) v{
    
    NSString * string;
    int t = 0;
    
    SEL jsonSkip = @selector(jsonSkip:);
    if ([v respondsToSelector:jsonSkip]) {
        if ([v performSelector:jsonSkip withObject:v withObject:nil]){
            return nil;
        }
    }
    
    //    if (v respondsToSelector:@selector(jsonSkip:)) {
    //        return nil;
    //    }
    Json * json;
    if (v == nil || [v isKindOfClass:[NSNull class]]) {
        t = -1;
    }else if([v isKindOfClass:[Json class]]){
        json = (Json *)v;
        if (json.isError) {
            
        }else if(json.isArray){
            t = 1;
        }else if(json.isDictionary){
            t = 2;
        }else if(json.isString){
            t = 3;
        }else if(json.isDate){
            t = 4;
        }
        v = json.value;
    }else{
        if ([v isKindOfClass:[NSArray class]]) {
            t = 1;
        }else if([v isKindOfClass:[NSDictionary class]]){
            t = 2;
        }else if([v isKindOfClass:[NSString class]]){
            t = 3;
        }else if([v isKindOfClass:[NSDate class]]){
            t = 4;
        }
    }
    //    NSDateFormatter * dateFormatter;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    switch (t) {
        case -1:
            string = @"null";
            break;
        case 0:
            string = [[NSString alloc] initWithFormat:@"%@",v];
            break;
        case 1:
            string = [Json toArrayString:(NSArray*)v];
            break;
        case 2:
            //            string = [Json toDicString:(NSDictionary*)v json:json];
            string = [Json toDicString:(NSDictionary*)v];
            break;
        case 3:
            string = [[NSString alloc] initWithFormat:@"%@",v];
            string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
            string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            
            string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
            string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
            string = [[NSString alloc] initWithFormat:@"\"%@\"",string];
            break;
        case 4:
            //            NSDate * date = (NSDate*)v;
            string = [dateFormatter stringFromDate:(NSDate*)v];
            break;
        default:
            //            string = [[NSString alloc] initWithFormat:@"%@",v];
            string = [[NSString alloc] initWithFormat:@"%@",v];
            string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
            string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            
            string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
            string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
            break;
    }
    return string;
}


+(NSString*)toArrayString:(NSArray*)v{
    
    NSMutableString * buffer = [[NSMutableString alloc] init];
    [buffer appendString:@"["];
    
    int n = 0;
    NSString * itemString;
    for (NSObject * item in v) {
        itemString = [Json toStringJson:item];
        if (itemString == nil) {
            continue;
        }
        if (n != 0) {
            [buffer appendString:@","];
        }
        n = 1;
        [buffer appendString:itemString];
    }
    [buffer appendString:@"]"];
    return [[NSString alloc] initWithString:buffer];
}
//    private func toArrayString(v:[AnyObject])->String{
//        var string:String = "[";
//        for (index,item) in enumerate(v){
//            if let s = toStringJson(item){
//                string += s;
//            }
//
//            if index < v.count - 1 {
//                string += ",";
//            }
//        }
//        string += "]";
//        return string;
//    }
//
//+(NSString*)toDicString:(NSDictionary *)v json:(Json*)json{
+(NSString*)toDicString:(NSDictionary *)v{
    
    
    NSMutableString * buffer = [[NSMutableString alloc] init];
    [buffer appendString:@"{"];
    
    int n = 0;
    
    SEL jsonSkip = @selector(jsonSkip:);
    
    
    NSString * itemString;
    NSObject * value;
    for (id key in [v keyEnumerator]) {
        
        //        if (json != nil) {
        if ([v respondsToSelector:jsonSkip]) {
            if ([v performSelector:jsonSkip withObject:v withObject:key]){
                continue;
            }
        }
        //        }
        value = [v objectForKey:key];
        itemString = [Json toStringJson:value];
        if (itemString == nil) {
            continue;
        }
        if (n != 0) {
            [buffer appendString:@","];
        }
        n = 1;
        [buffer appendString:@"\""];
        [buffer appendString:key];
        [buffer appendString:@"\":"];
        [buffer appendString:itemString];
    }
    [buffer appendString:@"}"];
    return [[NSString alloc] initWithString:buffer];
}
//    private func toDicString(v:Dictionary<String,AnyObject>)->String{
//
//        var string:String = "{";
//        var n:Int = 0;
//        for (name,item) in v{
//            if let s = toStringJson(item) {
//                if n != 0 {
//                    string += ",";
//                }
//
//                n++;
//
//                string += "\"\(name)\":"
//                string += s;
//            }
//        }
//        string += "}";
//        return string;
//    }
//
////    public var description:String { return toString() }
////
////    public func copyDescription()->String{return toString();}
//}
//
//
@end

@implementation Json (JsonParams)

-(NSDictionary*)toParams{
    return [Json toParamsJson:@"" value:self.value includeNull:TRUE];
}

-(NSDictionary*)toParams:(BOOL)includeNull{
    return [Json toParamsJson:@"" value:self.value includeNull:includeNull];
}


//extension Json{
//    public func toParams()->Dictionary<String,String>{
//
////        var dic = Dictionary<String,String>();
//
//        return self.toParamsJson("", v: self);
//
//
////        return dic;
//
//    }
//
+(NSDictionary*)toParamsJson:(NSString*)pre value:(NSObject*)v includeNull:(BOOL)includeNull{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    int t = 0;
    //    if (v respondsToSelector:@selector(jsonSkip:)) {
    //        return nil;
    //    }
    //-1、nil，1、数据，2：字典，4：日期
    if (v == nil || [v isKindOfClass:[NSNull class]]) {
        t = -1;
    }else if([v isKindOfClass:[Json class]]){
        Json * json = (Json *)v;
        if (json.isNull) {
            t = -1;
        }
        else if (json.isError) {
            
        }else if(json.isArray){
            t = 1;
        }else if(json.isDictionary){
            t = 2;
        }else if(json.isString){
            t = 3;
        }else if(json.isDate){
            t = 4;
        }
        v = json.value;
    }else{
        if ([v isKindOfClass:[NSArray class]]) {
            t = 1;
        }else if([v isKindOfClass:[NSDictionary class]]){
            t = 2;
        }else if([v isKindOfClass:[NSString class]]){
            t = 3;
        }else if([v isKindOfClass:[NSDate class]]){
            t = 4;
        }
    }
    if (t == -1 && !includeNull) {
        return dic;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary * tmpDic;
    NSString * stringItem;
    switch (t) {
        case -1:
            //            string = @"null";
            [dic setValue:@"null" forKey:pre];
            break;
        case 0:
            //            string = [[NSString alloc] initWithFormat:@"%@",v];
            [dic setValue:[[NSString alloc] initWithFormat:@"%@",v] forKey:pre];
            break;
        case 1:
            //            string = [Json toArrayString:(NSArray*)v];toArrayParams
            //            NSDictionary * tmp = [Json toArrayParams:pre value:v];
            tmpDic = [Json toArrayParams:pre value:(NSArray*)v includeNull:includeNull];
            if (tmpDic != nil) {
                for (NSString * key in [tmpDic keyEnumerator]) {
                    [dic setValue:[tmpDic objectForKey:key] forKey:key];
                }
            }
            break;
        case 2:
            if ([@"" isEqualToString:pre]) {
                tmpDic = [Json toDicParams:@"" value:(NSDictionary*)v includeNull:includeNull];
            }else{
                tmpDic = [Json toDicParams:[[NSString alloc] initWithFormat:@"%@.",pre] value:(NSDictionary*)v includeNull:includeNull];
            }
            if (tmpDic != nil) {
                for (NSString * key in [tmpDic keyEnumerator]) {
                    [dic setValue:[tmpDic objectForKey:key] forKey:key];
                }
            }
            //            string = [Json toDicString:(NSDictionary*)v];
            break;
        case 3:
            //            string = [[NSString alloc] initWithFormat:@"\"%@\"",v];
            stringItem = [[NSString alloc] initWithFormat:@"%@",v];
            //            stringItem = [stringItem stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            
            [dic setValue:stringItem forKey:pre];
            
            break;
        case 4:
            ////            let dateFormatter = NSDateFormatter()
            ////            //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            ////            NSDateFormatter * formatter;// = [[NSDateFormatter alloc] init];
            ////            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //            NSDate * date = (NSDate*)v;
            ////            date
            //            string = @"";
            [dic setValue:[dateFormatter stringFromDate:(NSDate*)v] forKey:pre];
            break;
        default:
            [dic setValue:[[NSString alloc] initWithFormat:@"%@",v] forKey:pre];
            break;
    }
    return dic;
}


//        switch t{
//        case -1:
//            dic[pre] = "null";
//        case 0:
//            dic[pre] = "\(v)";
//        case 3:
//            dic[pre] = dateFormatter.stringFromDate(v as NSDate);
//        case 1:
//            var d = toArrayParams(pre,v:tmpv as [AnyObject]);
//            for (name,item) in d{
//                dic[name] = item;
//            }
//        case 2:
//            if pre.lengthOfBytesUsingEncoding(1) != 0{
//                var d = toDicParams("\(pre).", v: tmpv as Dictionary<String,AnyObject>)
//                for (name,item) in d{
//                    dic[name] = item;
//                }
//            }else{
//                var d = toDicParams("", v: tmpv as Dictionary<String,AnyObject>)
//                for (name,item) in d{
//                    dic[name] = item;
//                }
//            }
//        default:
//            dic[pre] = "\(tmpv)";
//        }
//        return dic;
//    }
//
+(NSDictionary*)toArrayParams:(NSString*)pre value:(NSArray*)v includeNull:(BOOL)includeNull{
    
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    NSDictionary * itemDic;
    int n = 0;
    
    for (NSObject * item in v) {
        //itemString = [Json toStringJson:item];
        itemDic = [Json toParamsJson:[[NSString alloc] initWithFormat:@"%@[%d]",pre,n] value:item includeNull:includeNull];
        if (itemDic == nil) {
            continue;
        }
        n++;
        for (NSString * key in [itemDic keyEnumerator]) {
            [dic setValue:[itemDic objectForKey:key] forKey:key];
        }
    }
    
    return dic;
}
//    private func toArrayParams(pre:String,v:[AnyObject])->Dictionary<String,String>{
//        var dic = Dictionary<String,String>();
//        for (index,item) in enumerate(v){
//            var d = toParamsJson("\(pre)[\(index)]",v:item);
//            for (name,item) in d{
//                dic[name] = item;
//            }
//        }
//        return dic;
//    }
//
+(NSDictionary*)toDicParams:(NSString*)pre value:(NSDictionary*)v includeNull:(BOOL)includeNull{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSDictionary * itemDic;
    
    NSObject * value;
    
    for (NSString * key in [v keyEnumerator]) {
        value = [v objectForKey:key];
        
        itemDic = [Json toParamsJson:[[NSString alloc] initWithFormat:@"%@%@",pre,key] value:value includeNull:includeNull];
        
        if (itemDic == nil) {
            continue;
        }
        for (NSString * key in [itemDic keyEnumerator]) {
            [dic setValue:[itemDic objectForKey:key] forKey:key];
        }
    }
    
    return dic;
}
//    private func toDicParams(pre:String,v:Dictionary<String,AnyObject>)->Dictionary<String,String>{
//        
//        var dic = Dictionary<String,String>();
//        for (name,item) in v{
//            var d = toParamsJson("\(pre)\(name)",v:item);
//            for (name,item) in d{
//                dic[name] = item;
//            }
//        }
//        return dic;
//    }
//}
@end
