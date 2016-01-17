//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HTTPTask.swift
//
//  Created by Dalton Cherry on 6/3/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HttpMethod) {
    GET,POST,PUT,HEAD,DELETE
};
//
///// Object representation of a HTTP Response.
@interface HttpResponse : NSObject

@property(atomic) NSDictionary * headers;
@property(atomic) NSString * mimeType;
@property(atomic) NSString * suggestedFilename;
@property(atomic) NSObject * responseObect;
@property int statusCode;
@property(atomic) NSURL * URL;

-(NSString*)text;

@end
//
///// Holds the blocks of the background task.
@interface BackgroundBlocks : NSObject

@property(atomic,readonly) void(^success)(HttpResponse*);
@property(atomic,readonly) void(^failure)(NSError*,HttpResponse*);
@property(atomic,readonly) void(^progress)(double);

-(id)initWithSuccess:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure progress:(void(^)(double))progress;

@end
//
///// Subclass of NSOperation for handling and scheduling HTTPTask on a NSOperationQueue.

@interface HttpOperation : NSOperation

//@property(atomic) NSURLSessionTask * task;
//@property(atomic) BOOL stopped;
//@property(atomic) BOOL running;
//@property(atomic) BOOL done;

-(void)finish;

@end

@class HttpRequestSerializer;
@protocol HttpResponseSerializer;


///// Configures NSURLSession Request for HTTPOperation. Also provides convenience methods for easily running HTTP Request.
@interface HttpTask : NSObject//<NSURLSessionDelegate,NSURLSessionTaskDelegate>

@property(atomic,readonly) HttpRequestSerializer * requestSerializer;
@property(atomic,readonly) id<HttpResponseSerializer> responseSerializer;
@property(atomic) NSURLCredential * (^auth)(NSURLAuthenticationChallenge *);

-(HttpOperation*)create:(NSString*)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError *,HttpResponse*))failure;

//-(void)processResponse:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure data:(NSData*)data response:(NSURLResponse*)response error:(NSError*)error;
-(void)GET:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure;

-(void)POST:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure;

-(void)PUT:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure;

-(void)DELETE:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure;

-(void)HEAD:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure;

-(NSURLSessionDownloadTask*)download:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug progress:(void(^)(double))progress success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure;

-(void)uploadFile:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug progress:(void(^)(int64_t,int64_t))progress success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure;

-(NSMutableURLRequest*)createRequest:(NSString*)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug isMulti:(BOOL)isMulti error:(NSError**)error;

-(NSMutableURLRequest*)createRequest:(NSString*)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug error:(NSError**)error;


@end

@interface HttpTaskIOS7 : HttpTask

@end

@interface HttpTaskIOS6 : HttpTask

@end

/// Default Serializer for serializing an object to an HTTP request. This applies to form serialization, parameter encoding, etc.

@interface HttpRequestSerializer : NSObject
//{
//    @private
//    NSString * contentTypeKey;
//}
@property NSDictionary * headers;
@property uint stringEncoding;
@property BOOL allowsCellularAccess;
@property BOOL HTTPShouldHandleCookies;
@property BOOL HTTPShouldUsePipelining;
@property NSTimeInterval timeoutInterval;
@property NSURLRequestCachePolicy cachePolicy;
@property NSURLRequestNetworkServiceType networkServiceType;

-(NSMutableURLRequest*)newRequest:(NSURL*)url method:(HttpMethod)method;

-(NSMutableURLRequest*)createRequest:(NSURL *)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isMulti:(BOOL)isMulti error:(NSError**)error;
-(NSMutableURLRequest*)createRequest:(NSURL *)url method:(HttpMethod)method parameters:(NSDictionary*)parameters error:(NSError**)error;
//-(BOOL)isMultiForm:(NSDictionary*)params;
//-(NSString*)stringFromParameters:(NSDictionary*)parameters;
//-(BOOL)isURIParam:(HttpMethod)method;
//-(NSArray*)serializeObject:(NSObject*)object key:(NSString*)key;
//-(NSData*)dataFromParameters:(NSDictionary*)parameters;
//-(NSString*)multiFormHeader:(NSString*)name fileName:(NSString*)fileName type:(NSString*)type multiCRLF:(NSString*)multiCRLF;
@end


@class HttpUpload;

@interface HttpPair : NSObject

@property(atomic,readonly) NSObject * value;
@property(atomic,readonly) NSString * key;

-(id)initWithValue:(NSObject*)value key:(NSString*)key;

-(HttpUpload*)getUpload;
-(NSString*)getValue;
-(NSString*)stringValue;

@end


/// JSON Serializer for serializing an object to an HTTP request. Same as HTTPRequestSerializer, expect instead of HTTP form encoding it does JSON.

@interface JSONRequestSerializer : HttpRequestSerializer

@end


// This protocol provides a way to implement a custom serializer.
//public protocol HttpResponseSerializer {
//    /// This can be used if you want to have your data parsed/serialized into something instead of just a NSData blob.
//    func responseObjectFromResponse(response: NSURLResponse, data: NSData) -> (object: AnyObject?, error: NSError?)
//}

@protocol HttpResponseSerializer

-(NSObject*)responseObjectFromResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError **)error;

@end


@interface JSONResponseSerializer<HttpResponseSerializer>

@end
/// Serialize the data into a JSON object.
//public struct JSONResponseSerializer : HttpResponseSerializer {
//    /// Initializes a new JSONResponseSerializer Object.
//    public init(){}
//    
//    /**
//     Creates a HTTPOperation that can be scheduled on a NSOperationQueue. Called by convenience HTTP verb methods below.
//     
//     :param: response The NSURLResponse.
//     :param: data The response data to be parsed into JSON.
//     
//     :returns: Returns a object from JSON data and an NSError if an error occured while parsing the data.
//     */
//    public func responseObjectFromResponse(response: NSURLResponse, data: NSData) -> (object: AnyObject?, error: NSError?) {
//        var error: NSError?
//        let response: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
//        return (response,error)
//    }
//}

@interface HttpUpload : NSObject

-(id)initWithFileUrl:(NSURL*)fileUrl;
-(id)initWithData:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)mimeType;

-(BOOL)jsonSkip:(NSString*)name;

@property(atomic) NSURL * fileUrl;
@property(atomic,readonly) NSString * mimeType;
@property(atomic,readonly) NSData * data;
@property(atomic,readonly) NSString * fileName;

//-(void)updateMimeType;
//-(void)loadData;

@end
