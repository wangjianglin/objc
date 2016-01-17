//
//  HttpCommunicate.h
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "HttpPackage.h"

@interface HttpError : NSObject

@property(readonly) int code;
@property NSString * message;
@property NSString * cause;
@property NSString * stackTrace;

-(id)initWithCode:(int)code;

@end

@class HttpCommunicateResult;
@class HttpCommunicateArgs;
@class HttpPackage;

@interface HttpCommunicateImpl : NSObject

@property NSString * commUrl;
@property BOOL mainThread;
@property BOOL isDebug;
@property(readonly) NSString * name;
@property void (^httprequestComplete)(HttpPackage *,NSObject*,NSArray*);
@property void (^httprequestFault)(HttpPackage *,HttpError*);
@property void (^httprequest)(HttpPackage *);

-(id)initWithName:(NSString*)name;

-(HttpCommunicateResult*)request:(HttpPackage*)package result:(void(^)(NSObject*obj,NSArray*warning))result fault:(void(^)(HttpError*error))fault;

-(HttpCommunicateResult*)upload:(HttpPackage*)package result:(void(^)(NSObject*obj,NSArray*warning))result fault:(void(^)(HttpError*error))fault progress:(void(^)(int64_t sended,int64_t total))progress;

@end

//@interface HttpCommunicateInstall : HttpCommunicateImpl
//
//-(HttpCommunicateArgs*)install;
//
//@end

//extern HttpCommunicateInstall * HttpCommunicate;
//
@interface HttpCommunicateArgs : NSObject
- (HttpCommunicateImpl *)objectForKeyedSubscript:(NSString *)key;
@end


@interface HttpCommunicateResult : NSObject

-(id)initWithSet:(AutoResetEvent*)set;

@property(readonly) BOOL isSuccess;
-(void)abort;
-(void)waitForEnd;
-(NSObject*)getResult;

@end


@interface HttpCommunicate : NSObject

//@property NSString * commUrl;
//@property BOOL mainThread;
//@property BOOL isDebug;
//@property(readonly) NSString * name;
//@property void (^httprequestComplete)(HttpPackage *,NSObject*,NSArray*);
//@property void (^httprequestFault)(HttpPackage *,HttpError*);
//@property void (^httprequest)(HttpPackage *);

+(void (^)(HttpPackage * package))httprequest;

+(void (^)(HttpPackage * package, NSObject *obj, NSArray *warning))httprequestComplete;

+(void (^)(HttpPackage * package, HttpError *error))httprequestFault;

+(void)setHttprequest:(void (^)(HttpPackage * package))httprequest;

+(void)setHttprequestComplete:(void (^)(HttpPackage *package, NSObject *obj, NSArray *warning))httprequestComplete;

+(void)setHttprequestFault:(void (^)(HttpPackage *package, HttpError *error))httprequestFault;

+(NSString *)commUrl;
+(void)setCommUrl:(NSString *)commUrl;

+(BOOL)isDebug;
+(void)setIsDebug:(BOOL)isDebug;

+(BOOL)mainThread;
+(void)setMainThread:(BOOL)mainThread;


//-(id)initWithName:(NSString*)name;

+(HttpCommunicateResult*)request:(HttpPackage*)package result:(void(^)(NSObject*obj,NSArray*warning))result fault:(void(^)(HttpError*error))fault;

+(HttpCommunicateResult*)upload:(HttpPackage*)package result:(void(^)(NSObject*obj,NSArray*warning))result fault:(void(^)(HttpError*error))fault progress:(void(^)(int64_t sender,int64_t total))progress;

@end
