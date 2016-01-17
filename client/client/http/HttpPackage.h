//
//  Package.h
//  LinClient
//
//  Created by lin on 11/27/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinUtil/util.h"
#import "HttpTask.h"
#import "HttpRequestHandle.h"

@protocol HttpRequestHandle;

@interface HttpPackage : JsonModel

@property(atomic,readwrite) id<HttpRequestHandle> handle;
@property(atomic,readonly) HttpMethod method;
@property(atomic,readwrite) BOOL enableCache;
@property(atomic,readonly) NSString * url;

-(id)initWithUrl:(NSString *)url method:(HttpMethod)method;
-(id)initWithUrl:(NSString *)url;

-(NSObject *)getResult:(Json*)json;


-(NSDictionary*)toParams;

@end


//extern id<HttpRequestHandle> HTTP_NONE_HANDLE;
//extern id<HttpRequestHandle> HTTP_STANDARD_HANDLE;
//extern id<HttpRequestHandle> HTTP_STANDARD_JSON_HANDLE;
//extern id<HttpRequestHandle> HTTP_ENCRYPT_JSON_HANDLE;
//
//public class HttpPackage :JsonModel{
//
//    
//    //得到返回结果
//    public func getResult(json:Json)->AnyObject!{
//        return json;
//    }
//
//}
//
//extension HttpPackage{
//    public class var NONE_HANDLE:HttpRequestHandle {
//        
//        struct YRSingleton{
//            static var predicate:dispatch_once_t = 0
//            static var instance:NoneHttpRequestHandle? = nil
//        }
//        dispatch_once(&YRSingleton.predicate,{
//            YRSingleton.instance = NoneHttpRequestHandle()
//        })
//        return YRSingleton.instance!
//    }
//    
//    public class var STANDARD_HANDLE:HttpRequestHandle {
//        
//        struct YRSingleton{
//            static var predicate:dispatch_once_t = 0
//            static var instance:StandardHttpRequestHandle? = nil
//        }
//        dispatch_once(&YRSingleton.predicate,{
//            YRSingleton.instance = StandardHttpRequestHandle()
//        })
//        return YRSingleton.instance!
//    }
//    
//    public class var STANDARD_JSON_HANDLE:HttpRequestHandle {
//        
//        struct YRSingleton{
//            static var predicate:dispatch_once_t = 0
//            static var instance:StandardJsonHttpRequestHandle? = nil
//        }
//        dispatch_once(&YRSingleton.predicate,{
//            YRSingleton.instance = StandardJsonHttpRequestHandle()
//        })
//        return YRSingleton.instance!
//    }
//    
//    public class var ENCRYPT_JSON_HANDLE:HttpRequestHandle {
//        
//        struct YRSingleton{
//            static var predicate:dispatch_once_t = 0
//            static var instance:EncryptJsonHttpRequestHandle? = nil
//        }
//        dispatch_once(&YRSingleton.predicate,{
//            YRSingleton.instance = EncryptJsonHttpRequestHandle()
//        })
//        return YRSingleton.instance!
//    }
//}