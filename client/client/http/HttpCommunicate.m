//
//  HttpCommunicate.m
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "HttpCommunicate.h"
#import "HttpUtils.h"
#import "HttpUploadPackage.h"
#import <UIKit/UIKit.h>

@interface HttpCommunicateResult(){
@private
    AutoResetEvent * _set;
}
-(void)setResult:(BOOL)result obj:(NSObject*)obj;
@end


@implementation HttpError


-(id)initWithCode:(int)code{
    self = [super init];
    if(self){
        self->_code = code;
    }
    return  self;
}


-(NSString *)description{
//    var message = "\(error.code) \(error.message)";
    //        var message = String(format: "%0x", error.code);
    //        if message.utf16Count > (error.code>0 ? 4 : 5) {
    //            message.insert("_", atIndex: advance(message.startIndex, message.utf16Count - 4));
    //        }
    ////        println("message:\(message)");
    //        if let msg = error.message {
    //            message = "错误码：\(message) 错误消息：\(msg)";
    //        }else{
    //            message = "错误码：\(message) 错误消息：无";
    //        }
    NSMutableString * str = [[NSMutableString alloc] init];
    
    [str appendString:@"错误码："];
    
    NSString * m = nil;
    if (self.code < 0) {
        m = [[NSString alloc] initWithFormat:@"-%0x",-self.code];
    }else{
        m = [[NSString alloc] initWithFormat:@"%0x",self.code];
    }
    
    if (m.length > (self.code > 0 ? 4 : 5)) {
        [str appendString:[m substringToIndex:m.length - 4]];
        [str appendString:@"_"];
        [str appendString:[m substringFromIndex:m.length - 4]];
    }else{
        [str appendString:m];
    }
    
    [str appendString:@"\n错误消息："];
    if (self.message == nil) {
        [str appendFormat:@"无"];
    }else{
        [str appendString:self.message];
    }
    
    return str;
}
@end


////HTTP通信实现类

@interface HttpCommunicateImpl(){
    @private
    void (^_httprequestComplete)(HttpPackage *,NSObject*,NSArray*);
    void (^_httprequestFault)(HttpPackage *,HttpError*);
    void (^_httprequest)(HttpPackage *);
    NSString * _commUrl;
}

@end


@implementation HttpCommunicateImpl

-(id)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        self->_name = name;
        self.isDebug = false;
        self.mainThread = false;
        self.commUrl = @"http://192.168.1.8:8080/lin.demo/";
    }
    return self;
}

-(void (^)(HttpPackage *))httprequest{
    //return self->_httprequest;
    return nil;
}
-(void (^)(HttpPackage *, NSObject *, NSArray *))httprequestComplete{
    return self->_httprequestComplete;
}

-(void (^)(HttpPackage *, HttpError *))httprequestFault{
    return self->_httprequestFault;
}

-(void)setHttprequest:(void (^)(HttpPackage *))httprequest{
    self->_httprequest = httprequest;
}

-(void)setHttprequestComplete:(void (^)(HttpPackage *, NSObject *, NSArray *))httprequestComplete{
    self->_httprequestComplete = httprequestComplete;
}

-(void)setHttprequestFault:(void (^)(HttpPackage *, HttpError *))httprequestFault{
    self->_httprequestFault = httprequestFault;
}

-(void)fireHttprequest:(HttpPackage*)package{
    if (self.httprequest != nil) {
        self.httprequest(package);
    }
}
-(void)fireHttprequestFault:(HttpPackage *)package error:(HttpError *)error{
    if(self.httprequestFault != nil){
        self.httprequestFault(package,error);
    }
}

-(void)fireHttprequestComplete:(HttpPackage *)package obj:(NSObject *)obj warning:(NSArray *)warning{
    if(self.httprequestComplete != nil){
        self.httprequestComplete(package,obj,warning);
    }
}
-(NSString *)commUrl{
    return self->_commUrl;
}
-(void)setCommUrl:(NSString *)commUrl{
    if (![commUrl hasSuffix:@"/"]) {
        commUrl = [[NSString alloc] initWithFormat:@"%@/",commUrl];
    }
    self->_commUrl = commUrl;
}

-(HttpCommunicateResult *)upload:(HttpUploadPackage *)package result:(void (^)(NSObject *, NSArray *))result fault:(void (^)(HttpError *))fault progress:(void (^)(int64_t, int64_t))progress{
    //    public func upload(package:HttpUploadPackage,result:((obj:AnyObject!,warning:[HttpError])->())! = nil,fault:((error:HttpError)->())! = nil,progress:((send:Int64,total:Int64) -> Void)! = nil)->HttpCommunicateResult{
    //        var task = HttpTask();
    //
//    HttpTask * task = [[HttpTask alloc] init];//
    
//    HttpTask * task = [[HttpTaskIOS7 alloc] init];
    
    HttpTask * task = nil;
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0){
        task = [[HttpTaskIOS7 alloc] init];
    }else{
        task = [[HttpTaskIOS6 alloc] init];
    }
    task.httpDNS = self.httpDNS;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    AutoResetEvent * set = [[AutoResetEvent alloc] init];
    HttpCommunicateResult * httpResult = [[HttpCommunicateResult alloc] initWithSet:set];
    //        var params = Dictionary<String,AnyObject>();
    //        var httpResult = HttpCommunicateResult();
    //        var set = AutoResetEvent();
    //        httpResult.set = set;
    NSDictionary * p = [package toParams];
    
    for (NSString * key in p.keyEnumerator) {
        params[key] = p[key];
    }
    //
    //        for (name,value) in package.json.toParams() {
    //            params[name] = value;
    //        }
    //
    NSDictionary * files = package.files;
    //        for (name,value) in package.files {
    //            params[name] = value;
    //        }
    
    for (NSString * key in files) {
        params[key] = files[key];
    }
    
    //        self.httprequest?(package);
    [self fireHttprequest:package];
    
//    __block
    [task uploadFile:[HttpUtils url:self pack:package] parameters:params isDebug:self.isDebug progress:progress success:^(HttpResponse * response) {
        
        [package.handle response:package response:response.responseObect result:[self mainThreadResult:httpResult pack:package set:set result:result] fault:[self mainThreadFault:httpResult pack:package set:set fault:fault]];
        
    } failure:^(NSError * error, HttpResponse * response) {
        //        <#code#>
        //-1004 端口不对
        //-1003 域名不对
        //-1001
        //-1005  NSURLErrorDomain
        HttpError * e = [[HttpError alloc] initWithCode:-2];
        e.message = @"网络故障";//[error description];
        e.cause = [error description];
        [self mainThreadFault:httpResult pack:package set:set fault:fault](e);
    }];
    //        task.uploadFile(HttpUtils.url(self, pack: package), parameters: params,isDebug:self.isDebug,progress: package.progress, success: { (response) -> Void in
    //                //println("success");
    //                httpResult.setResult(true);
    //            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,set:set,result:result), fault: self.mainThreadFault(httpResult,pack:package,set:set,fault:fault));
    //
    //                //set.set();
    //
    //            }) { (error,response) -> Void in
    //                //println("error.")
    //                var e:HttpError = HttpError(code:-1);
    //                httpResult.setResult(false);
    //                self.mainThreadFault(httpResult,pack:package,set:set,fault:fault)(error:e);
    //                
    //                //set.set();
    //        };
    //
    //        return httpResult;
    //    }
    return httpResult;
}

//    private func mainThreadResult(httpResult:HttpCommunicateResult,pack:HttpPackage,set:AutoResetEvent,result:((obj:AnyObject!,warning:[HttpError])->())?)->((obj:AnyObject!,warning:[HttpError])->()){
//

-(void(^)(NSObject *,NSArray*))mainThreadResult:(HttpCommunicateResult*)httpResult pack:(HttpPackage*)pack set:(AutoResetEvent*)set result:(void(^)(NSObject *,NSArray*))result{
    
    id tmpResult = ^(NSObject*obj,NSArray*waring){
        [httpResult setResult:true obj:obj];
//        self.httprequestComplete(pack,obj,waring);
        [self fireHttprequestComplete:pack obj:obj warning:waring];
        if (result == nil) {
            [set set];
            return;
        }
        
        if (self.mainThread == FALSE ||
            [NSThread currentThread].isMainThread ||
            [set canEnterMainThread] == FALSE) {
            result(obj,waring);
            [set set];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                result(obj,waring);
                [set set];
            });
        }
    };;
    
    return tmpResult;
}

//        var tmpResult = {[weak httpResult](obj:AnyObject!,warning:[HttpError]) ->() in
//
//            httpResult?.setResult(true);
//            self.httprequestComplete?(pack,obj,warning);
//            if let result = result {
//                if self.mainThread == false || NSThread.currentThread().isMainThread || set.canEnterMainThread() == false {
//
//                    result(obj: obj,warning: warning);
//                    set.set();
//                }else{
//
//                    dispatch_async(dispatch_get_main_queue(), {() in
//                        result(obj: obj,warning: warning);
//                        set.set();
//                    });
//                }
//            }else{
//                set.set();
//            }
//        }
//        return tmpResult;
//
//    }
//    private func mainThreadFault(httpResult:HttpCommunicateResult,pack:HttpPackage,set:AutoResetEvent,fault:((error:HttpError)->())?)->((error:HttpError)->()){

-(void(^)(HttpError*))mainThreadFault:(HttpCommunicateResult*)httpResult pack:(HttpPackage*)pack set:(AutoResetEvent*)set fault:(void(^)(HttpError*))fault{
    
    id tmpFault = ^(HttpError*error){
        [httpResult setResult:false obj:error];
//        self.fireHttprequestFault(pack,error);
        [self fireHttprequestFault:pack error:error];
        if (fault == nil) {
            [set set];
            return;
        }
        
        if (self.mainThread == FALSE ||
            [NSThread currentThread].isMainThread ||
            [set canEnterMainThread] == FALSE) {
            fault(error);
            [set set];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                fault(error);
                [set set];
            });
        }
    };;
    
    return tmpFault;
}
//
//        var tmpFault = {[weak httpResult](error:HttpError) ->() in
//            httpResult?.setResult(false);
//            self.httprequestFault?(pack,error);
//            if let fault = fault {
//                if self.mainThread == false || NSThread.currentThread().isMainThread || set.canEnterMainThread() == false {
//                    fault(error: error);
//                    set.set();
//                }else{
//                    dispatch_async(dispatch_get_main_queue(), {() in
//                        fault(error: error);
//                        set.set();
//                    });
//                }
//            }else{
//                set.set();
//            }
//        }
//        return tmpFault;
//    }
//

-(HttpCommunicateResult *)request:(HttpPackage *)package result:(void (^)(NSObject *obj, NSArray *warning))result fault:(void (^)(HttpError *error))fault{
    
    //        if let uploadPackage = package as? HttpUploadPackage{
    //            return self.upload(uploadPackage,result:result,fault:fault,progress:uploadPackage.progress);
    //        }
    //        var httpResult = HttpCommunicateResult();
    
    if ([package isKindOfClass:[HttpUploadPackage class]]) {
        
        HttpUploadPackage * uploadPackage = (HttpUploadPackage*)package;
        return [self upload:uploadPackage result:result fault:fault progress:uploadPackage.progress];
    }
    
    AutoResetEvent * set = [[AutoResetEvent alloc] init];
    HttpCommunicateResult * httpResult = [[HttpCommunicateResult alloc] initWithSet:set];
    //        var set = AutoResetEvent();
    //        httpResult.set = set;
    //
    [self fireHttprequest:package];
    //        self.httprequest?(package);
    //        var request:HttpTask = HttpTask();
    //    HttpTask * task = [[HttpTask alloc] init];
//#if IOS6
//    HttpTask * task = [[HttpTaskIOS6 alloc] init];
//#else
//    HttpTask * task = [[HttpTaskIOS6 alloc] init];
//#end
    
    HttpTask * task = nil;
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0){
        task = [[HttpTaskIOS7 alloc] init];
    }else{
        task = [[HttpTaskIOS6 alloc] init];
    }
    task.httpDNS = self.httpDNS;
    //        requestImpl(request,package:package,url:HttpUtils.url(self, pack: package), parameters: package.handle.getParams(request,package:package),isDebug:self.isDebug, success: {(response: HttpResponse) in
    //
    [self requestImpl:task package:package url:[HttpUtils url:self pack:package] parameters:[package.handle getParams:task package:package] isDebug:self.isDebug success:^(HttpResponse * response) {
//
        [package.handle response:package response:response.responseObect result:[self mainThreadResult:httpResult pack:package set:set result:result] fault:[self mainThreadFault:httpResult pack:package set:set fault:fault]];
        
    } failure:^(NSError * error, HttpResponse * response) {
//        <#code#>
        //-1004 端口不对
        //-1003 域名不对
        //-1001
        //-1005  NSURLErrorDomain
//        HttpError * e = [[HttpError alloc] initWithCode:-2];
//        e.message = [error description];
        HttpError * e = [[HttpError alloc] initWithCode:-2];
        e.message = @"网络故障";//[error description];
        e.cause = [error description];
        [self mainThreadFault:httpResult pack:package set:set fault:fault](e);
    }];
    //            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,set:set,result:result), fault: self.mainThreadFault(httpResult,pack:package,set:set,fault:fault));
    //                //set.set();
    //            },failure: {(error: NSError?,response: HttpResponse?) in
    //
    //                //println("error: \(error)")
    //
    //                //-1004 端口不对
    //                //-1003 域名不对
    //                //-1001
    //                //-1005  NSURLErrorDomain
    //                var e:HttpError = HttpError(code:-2);
    //                e.message = error?.description;
    //                self.mainThreadFault(httpResult,pack:package,set:set,fault:fault)(error:e);
    //
    //                //set.set();
    //        })
    //        
    //        return httpResult;
    //    }
    return httpResult;
}

-(void)requestImpl:(HttpTask*)request package:(HttpPackage*)package url: (NSString*)url parameters: (NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*, HttpResponse*))failure {
    
    HttpOperation * opt = [request create:url method:package.method parameters:parameters isDebug:isDebug success:success failure:failure];
    
    [opt start];
}
@end

//@implementation HttpCommunicateInstall
//
//-(HttpCommunicateArgs *)install{
//    return  nil;
//}
//
//@end

//HttpCommunicateInstall * HttpCommunicate = [[HttpCommunicateImpl alloc] init];
//

//    
//    public var httprequestComplete:((HttpPackage,AnyObject!,[HttpError])->())?
//    
//    
//    public var httprequestFault:((HttpPackage,HttpError)->())?
//    
//    
//    public var httprequest:((HttpPackage)->())?
//    


//    
//
//}
//
//    
//public class HttpCommunicateArgs{
//    
//    var insts:Dictionary<String,HttpCommunicateImpl>;
//    var lock:NSLock;
//    
//    private init(){
//        self.insts = Dictionary<String,HttpCommunicateImpl>();
//        self.lock = NSLock();
//    }
//    
//    public subscript(name:String)->HttpCommunicateImpl {
//        get{
//            //线程同步
//            //@synchronized(self){
//            var impl = insts[name];
//            if let i = impl{
//                return i;
//            }
//            lock.lock();
//            impl = insts[name];
//            if impl == nil{
//                impl = HttpCommunicateImpl(name:name);
//                insts[name] = impl;
//            }
//            lock.unlock();
//            return impl!;
//             //   return HttpCommunicate(name:name);
//            //}
//        }
////            set{
////                
////            }
//    }
//}
//    //class var test:Dictionary<String,String> = Dictionary<String,String>();
//
//
//
//

@interface HttpCommunicateResult (){
    @private
    BOOL _r;
    NSObject * _obj;
}

@end


@implementation HttpCommunicateResult

-(id)initWithSet:(AutoResetEvent*)set{
    self = [super init];
    if (self) {
        _set = set;
        _r = FALSE;
    }
    return self;
}

//public func waitForEnd(){
//    if let set = self.set{
//        set.waitOne();
//    }
//}
//
//
//public var isSuccess:Bool{
//    get{
//        self.waitForEnd();
//        return self._r;
//    }
//}
//internal func setResult(var result:Bool){
//    self._r = result;
//}

-(void)setResult:(BOOL)result obj:(NSObject*)obj{
    _r = result;
    _obj = obj;
}
-(NSObject *)getResult{
    return _obj;
}
-(void)abort{
    
}
-(void)waitForEnd{
    [_set waitOne];
}

-(BOOL)isSuccess{
    [self waitForEnd];
    return _r;
}

@end


HttpCommunicateImpl * _global = nil;
static dispatch_once_t HttpCommunicateImplDispathOne = 0;

HttpCommunicateImpl * global(){
    
    dispatch_once(&HttpCommunicateImplDispathOne,^{
        _global = [[HttpCommunicateImpl alloc] initWithName:@"global"];
    });
    return _global;
}

@implementation HttpCommunicate : NSObject

//@property NSString * commUrl;
//@property BOOL mainThread;
//@property BOOL isDebug;
//@property(readonly) NSString * name;
//@property void (^httprequestComplete)(HttpPackage *,NSObject*,NSArray*);
//@property void (^httprequestFault)(HttpPackage *,HttpError*);
//@property void (^httprequest)(HttpPackage *);

+(void (^)(HttpPackage *))httprequest{
    return global().httprequest;
}

+(void (^)(HttpPackage *, NSObject *, NSArray *))httprequestComplete{
    return global().httprequestComplete;
}

+(void (^)(HttpPackage *, HttpError *))httprequestFault{
    return global().httprequestFault;
}

+(void)setHttprequest:(void (^)(HttpPackage *))httprequest{
    global().httprequest = httprequest;
}

+(void)setHttprequestComplete:(void (^)(HttpPackage *, NSObject *, NSArray *))httprequestComplete{
    global().httprequestComplete = httprequestComplete;
}

+(void)setHttprequestFault:(void (^)(HttpPackage *, HttpError *))httprequestFault{
    global().httprequestFault = httprequestFault;
}

+(NSString *)commUrl{
    return global().commUrl;
}
+(void)setCommUrl:(NSString *)commUrl{
    global().commUrl = commUrl;
}

+(id<HttpDNS>)httpDNS{
    return global().httpDNS;
}

+(void)setHttpDNS:(id<HttpDNS>)httpDNS{
    global().httpDNS = httpDNS;
}

+(BOOL)isDebug{
    return global().isDebug;
}
+(void)setIsDebug:(BOOL)isDebug{
    global().isDebug = isDebug;
}

+(BOOL)mainThread{
    return global().mainThread;
}
+(void)setMainThread:(BOOL)mainThread{
    global().mainThread = mainThread;
}


//-(id)initWithName:(NSString*)name;

+(HttpCommunicateResult*)request:(HttpPackage*)package result:(void(^)(NSObject*obj,NSArray*warning))result fault:(void(^)(HttpError*error))fault{
    return [global() request:package result:result fault:fault];
}

+(HttpCommunicateResult*)upload:(HttpPackage*)package result:(void(^)(NSObject*,NSArray*))result fault:(void(^)(HttpError*))fault progress:(void(^)(int64_t,int64_t))progress{
    return [global() upload:package result:result fault:fault progress:progress];
}

@end
