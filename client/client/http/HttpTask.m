//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HTTPTask.m
//
//  Created by Dalton Cherry on 6/3/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>
#import "HttpTask.h"
#import "../Constants.h"
#import <MobileCoreServices/UTType.h>
#import <LinUtil/util.h>

#import <UIKit/UIKit.h>
#import "HttpDNS.h"


@interface BackgroundBlocks(){
    @private
    void(^_success)(HttpResponse*);
    void(^_failure)(NSError*,HttpResponse*);
    void(^_progress)(double);
}

@end
@implementation BackgroundBlocks

-(id)initWithSuccess:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure progress:(void(^)(double))progress{
    self = [super init];
    if(self){
        self->_success = success;
        self->_failure = failure;
        self->_progress = progress;
    }
    return self;
}

-(void(^)(HttpResponse * ))success{
    return self->_success;
}

-(void(^)(NSError*,HttpResponse * ))failure{
    return self->_failure;
}

-(void(^)(double))progress{
    return self->_progress;
}
@end


@interface HttpOperation (){
    @private
    
    BOOL stopped;
    BOOL running;
    BOOL done;
    @package
//#if __OSX_AVAILABLE_STARTING(10_9, 7_0)
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//    NSURLSessionTask * task;
//    NSObject * _task;
////#else
//    NSMutableURLRequest * request;
////    __weak id<NSURLConnectionDelegate> delegate;
//    NSURLConnection * conn;
//#endif
}
//@property(atomic) NSURLSessionTask * task;
@end
@implementation HttpOperation

-(BOOL)isAsynchronous{
    return FALSE;
}

-(BOOL)isCancelled{
    return self->stopped;
}

-(BOOL)isExecuting{
    return self->running;
}

-(BOOL)isFinished{
    return self->done;
}

-(BOOL)isReady{
    return !self->running;
}

-(void)start{
    [super start];
    stopped = FALSE;
    running = TRUE;
    done = FALSE;
//#if __OSX_AVAILABLE_STARTING(10_9, 7_0)
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//    NSLog(@"version:%f",[[[UIDevice currentDevice] systemVersion] doubleValue]);
//    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0){
//        NSURLSessionTask * task = _task;
//        [task resume];
//    }
//#endif
}

-(void)cancel{
    [super cancel];
    running = FALSE;
    stopped = TRUE;
    done = TRUE;
//#if __OSX_AVAILABLE_STARTING(10_9, 7_0)
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0){
//        NSURLSessionTask * task = _task;
//        [task cancel];
//    }else{
////#else
//        [self->conn cancel];
//    }
//#endif
}

-(void)main{
//    [Queue asynQueue:^{
//        NSLog(@"thread:%@",[NSThread currentThread]);
//        conn = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
//    }];
    
}

-(void)finish{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    running = FALSE;
    done = TRUE;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


@end


@implementation HttpResponse

-(NSString*)text{
    if ([self.responseObect isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData*)self.responseObect encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end

//#if __OSX_AVAILABLE_STARTING(10_9, 7_0)
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
@interface HttpTask (){
//#else
////@interface HttpTask ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
//@interface HttpTask (){
//#endif
    
@private
    NSDictionary * backgroundTaskMap;
    NSString * baseURL;
//#if __OSX_AVAILABLE_STARTING(10_9, 7_0)
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//    NSURLSession * session;
    
//#else
//    NSMutableData * buffer;
//    void(^_success)(HttpResponse*);
//    void(^_failure)(NSError *,HttpResponse*);
//    NSURLResponse * _response;
//#endif
    NSURLCredential *  (^_auth)(NSURLAuthenticationChallenge *);
    
}

-(void)processResponse:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure data:(NSData*)data response:(NSURLResponse*)response error:(NSError *)error;

-(HttpOperation*)createImpl:(NSMutableURLRequest*)request success:(void(^)(HttpResponse*))success failure:(void(^)(NSError *,HttpResponse*))failure;
@end

@implementation HttpTask

-(id)init{
    self = [super init];
    if (self) {
//        let config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration();
//#if __OSX_AVAILABLE_STARTING(10_9, 7_0)
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        
//        if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0){
//        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        
//            NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
//            self->session = session;
//        }
//#endif
        self->_requestSerializer = [[HttpRequestSerializer alloc] init];
        
//        self.requestSerializer = [Httpres]
    }
    return self;
}

-(NSURLCredential *(^)(NSURLAuthenticationChallenge *))auth{
    return self->_auth;
}

-(void)setAuth:(NSURLCredential *(^)(NSURLAuthenticationChallenge *))auth{
    self->_auth = auth;
}

-(HttpOperation*)create:(NSString*)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError *,HttpResponse*))failure{
    return [self create:url method:method parameters:parameters isDebug:isDebug isMulti:FALSE success:success failure:failure];
}
    
    -(HttpOperation*)create:(NSString*)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug isMulti:(BOOL)isMulti success:(void(^)(HttpResponse*))success failure:(void(^)(NSError *,HttpResponse*))failure {
    
    NSError * error;
    NSMutableURLRequest * request = [self createRequest:url method:method parameters:parameters isDebug:isDebug isMulti:isMulti error:&error];
    if (error != nil) {
        if (failure != nil) {
            failure(error,nil);
        }
    }
    return [self createImpl:request success:success failure:failure];
}

    
//    -(void)dealloc{
//        NSLog(@"Http Task dealloc.");
//    }

-(void)processResponse:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure data:(NSData*)data response:(NSURLResponse*)response error:(NSError *)error{
    
    if (error != nil) {
        failure(error,nil);
        return;
    }
    
    if (data == nil) {
        failure(error, nil);
        return;
    }
    
    NSObject * resObj = data;
    if (self.responseSerializer != nil) {
        NSError * e;
        resObj = [self.responseSerializer responseObjectFromResponse:response data:data error:&e];
        if (e != nil) {
            failure(error,nil);
            return;
        }
//        failure(error, nil);
//        return;
    }
    
    
    HttpResponse * extraResponse = [[HttpResponse alloc] init];
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse * hresponse = (NSHTTPURLResponse*)response;
        extraResponse.headers = hresponse.allHeaderFields;
        extraResponse.mimeType = hresponse.MIMEType;
        extraResponse.suggestedFilename = hresponse.suggestedFilename;
        extraResponse.statusCode = hresponse.statusCode;
        extraResponse.URL = hresponse.URL;
    }
    extraResponse.responseObect = resObj;
    if (extraResponse.statusCode > 299) {
//        statements
        if(failure != nil){
            //error(self.createError(extraResponse.statusCode!), extraResponse)
            //HttpError * e =
            failure([self createError:extraResponse.statusCode],extraResponse);
        }
        return;
    }
    success(extraResponse);
//    if data != nil {

//        if let hresponse = response as? NSHTTPURLResponse {
//            extraResponse.headers = hresponse.allHeaderFields as? Dictionary<String,String>
//            extraResponse.mimeType = hresponse.MIMEType
//            extraResponse.suggestedFilename = hresponse.suggestedFilename
//            extraResponse.statusCode = hresponse.statusCode
//            extraResponse.URL = hresponse.URL
//        }
//        extraResponse.responseObject = responseObject
//        if extraResponse.statusCode > 299 {
//            if failure != nil {
//                failure(self.createError(extraResponse.statusCode!), extraResponse)
//            }
//        } else if success != nil {
//            success(extraResponse)
//        }
//    } else if failure != nil {
//        failure(error, nil)
//    }
//    
}

-(void)GET:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure{
    HttpOperation * opt = [self create:url method:GET parameters:parameters isDebug:isDebug success:success failure:failure];
    [opt start];
}

-(void)POST:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure{
    HttpOperation * opt = [self create:url method:POST parameters:parameters isDebug:isDebug success:success failure:failure];
    [opt start];
}

-(void)PUT:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure{
    HttpOperation * opt = [self create:url method:PUT parameters:parameters isDebug:isDebug success:success failure:failure];
    [opt start];
}

-(void)DELETE:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure{
    HttpOperation * opt = [self create:url method:DELETE parameters:parameters isDebug:isDebug success:success failure:failure];
    [opt start];
}

-(void)HEAD:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure{
    HttpOperation * opt = [self create:url method:HEAD parameters:parameters isDebug:isDebug success:success failure:failure];
    [opt start];
}

-(NSURLSessionDownloadTask*)download:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug progress:(void(^)(double))progress success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure{
    return nil;
}


-(NSMutableURLRequest*)createRequest:(NSString*)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug isMulti:(BOOL)isMulti error:(NSError**)error{
//    NSString * urlVal = url;
    if (!([url hasPrefix:@"http"]) && self->baseURL != nil ) {
        NSString * split = [url hasPrefix:@"/"] ? @"" : @"/";
        url = [[NSString alloc] initWithFormat:@"%@%@%@",self->baseURL,split,url];
    }
    
    NSURL * nsurl = [[NSURL alloc] initWithString:url];
    
    id<HttpDNS> httpDNS = self.httpDNS;
    NSString* ip = nil;
    NSString * hostName = nil;
    if(httpDNS != nil){
        hostName = nsurl.host;
        ip = [httpDNS getIpByHost:hostName];
        if (ip) {
//            // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
//            NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
            NSRange hostFirstRange = [url rangeOfString: hostName];
            if (NSNotFound != hostFirstRange.location) {
                NSString* newUrl = [url stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                nsurl = [[NSURL alloc] initWithString:newUrl];
            }else{
                ip = nil;
            }
        }
        
        
    }
//    NSURL * nsurl = [[NSURL alloc] initWithString:url];
//    NSObject * result = [self.requestSerializer createRequest:nsurl method:method parameters:parameters isMulit:isMulti];
    
//    -(NSMutableURLRequest*)createRequest:(NSURL *)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isMulti:(BOOL)isMulti error:(NSError**)error;
    
    NSError * e;
    NSMutableURLRequest * request = [self.requestSerializer createRequest:nsurl method:method parameters:parameters isMulti:isMulti error:&e];
    
    //    var result = self.requestSerializer.createRequest(NSURL(string: urlVal)!,
    //        method: method, parameters: parameters,isMulti : isMulti);
    //
    [request setValue:@"" forHTTPHeaderField:HTTP_COMM_PROTOCOL];
    //        result.request.setValue("",forHTTPHeaderField:HTTP_COMM_PROTOCOL);
    if (isDebug) {
        [request setValue:@"" forHTTPHeaderField:HTTP_COMM_PROTOCOL_DEBUG];
    }
    if (ip) {
        [request setValue:hostName forHTTPHeaderField:@"Host"];
    }
    //        if isDebug {
    //            result.request.setValue("",forHTTPHeaderField:HTTP_COMM_PROTOCOL_DEBUG);
    //        }
    //        return result;
    return request;
}

-(NSMutableURLRequest*)createRequest:(NSString*)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug error:(NSError**)error{
    return [self createRequest:url method:method parameters:parameters isDebug:isDebug isMulti:false error:error];
}


//    public func download(url: String, parameters: Dictionary<String,AnyObject>?,progress:((Double) -> Void)!,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) -> NSURLSessionDownloadTask? {
//        let serialReq = createRequest(url,method: .GET, parameters: parameters,isDebug:isDebug)
//        if serialReq.error != nil {
//            failure(serialReq.error!, nil)
//            return nil
//        }
//        let ident = createBackgroundIdent()
//        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(ident)
//        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
//        let task = session.downloadTaskWithRequest(serialReq.request)
//        self.backgroundTaskMap[ident] = BackgroundBlocks(success,failure,progress)
//        //this does not have to be queueable as Apple's background dameon *should* handle that.
//        task.resume()
//        return task
//    }
//    
//    //TODO: not implemented yet.
//    /// not implemented yet.
//    public func uploadFile(url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, progress:((Int64,Int64) -> Void)!, success:((HttpResponse) -> Void)!, failure:((NSError,HttpResponse?) -> Void)!) -> Void {


//        
//
//        let serialReq = createRequest(url,method: .GET, parameters: parameters,isDebug:isDebug,isMulti:true)
//        if serialReq.error != nil {
//            failure(serialReq.error!,nil)
//            return
//        }
//        self.uploadProgress = progress;
////        self.uploadSuccess = success;
////        self.uploadFailure = failure;
//        
////        var task = session.uploadTaskWithRequest(serialReq.request, fromData: nil);
//        
//        var task = session.uploadTaskWithRequest(serialReq.request, fromData:nil, completionHandler: {(data:NSData!,response: NSURLResponse!, error:NSError!) in
//            self.processResponse(success,failure:failure,data:data,response:response,error:error);
//        });
//        task.resume();
//        
//    }
//    
//    private var uploadProgress:((Int64,Int64) -> Void)!;



//    private func createBackgroundIdent() -> String {
//        let letters = "abcdefghijklmnopqurstuvwxyz"
//        var str = ""
//        for var i = 0; i < 14; i++ {
//            let start = Int(arc4random() % 14)
//            str.append(letters[advance(letters.startIndex,start)])
//        }
//        return "com.vluxe.swifthttp.request.\(str)"
//    }

//    /**
//        Creates a random string to use for the identifier of the background download/upload requests.
//        
//        :param: code Code for error.
//        
//        :returns: An NSError.
//    */
-(NSError*)createError:(int)code{
    NSString * text;
    if (code == 404) {
        text = @"page not found.";
    }else if (code == 401){
        text = @"accessed denied.";
    }else{
        text = @"An error occured.";
    }
    return [[NSError alloc] initWithDomain:@"HTTPTask" code:code userInfo:@{NSLocalizedDescriptionKey:text}];
}


//    private func cleanupBackground(identifier: String) {
//        self.backgroundTaskMap.removeValueForKey(identifier)
//    }
//    
//    //MARK: NSURLSession Delegate Methods
//    
//    /// Method for authentication challenge.
//    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
//#if __OSX_AVAILABLE_STARTING(10_9, 7_0)
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

//        if error != nil {
////            println("error:\(error)");
////            println("identifier:\(session.configuration)");
////            println("identifier:\(session.configuration.identifier)");
////            let blocks = self.backgroundTaskMap[session.configuration.identifier]
////            if blocks?.failure != nil { //Swift bug. Can't use && with block (radar: 17469794)
////                blocks?.failure!(error, nil)
////                cleanupBackground(session.configuration.identifier)
////            }
//        }
//    }
//    
//    /// The background download finished and reports the url the data was saved to.
//    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didFinishDownloadingToURL location: NSURL!) {

//-(void)URL
//        let blocks = self.backgroundTaskMap[session.configuration.identifier]
//        if blocks?.success != nil {
//            var resp = HttpResponse()
//            if let hresponse = downloadTask.response as? NSHTTPURLResponse {
//                resp.headers = hresponse.allHeaderFields as? Dictionary<String,String>
//                resp.mimeType = hresponse.MIMEType
//                resp.suggestedFilename = hresponse.suggestedFilename
//                resp.statusCode = hresponse.statusCode
//                resp.URL = hresponse.URL
//            }
//            resp.responseObject = location
//            if resp.statusCode > 299 {
//                if blocks?.failure != nil {
//                    blocks?.failure!(self.createError(resp.statusCode!), resp)
//                }
//                return
//            }
//            blocks?.success!(resp)
//            cleanupBackground(session.configuration.identifier)
//        }
//    }
//    
//    /// Will report progress of background download
//    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        let increment = 100.0/Double(totalBytesExpectedToWrite)
//        var current = (increment*Double(totalBytesWritten))*0.01
//        if current > 1 {
//            current = 1;
//        }
//        let blocks = self.backgroundTaskMap[session.configuration.identifier]
//        if blocks?.progress != nil {
//            blocks?.progress!(current)
//        }
//    }
//    
//    /// The background download finished, don't have to really do anything.
//    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession!) {
////        println("ok.");
//    }
//    
//    //TODO: not implemented yet.
//    /// not implemented yet. The background upload finished and reports the response data (if any).
//    func URLSession(session: NSURLSession!, dataTask: NSURLSessionDataTask!, didReceiveData data: NSData!) {
//        //add upload finished logic
////        var str = NSString(data: data, encoding: NSUTF8StringEncoding);
////        if let success = self.uploadSuccess {
////            var response = HttpResponse();
////            response.responseObject = data;
////            success(response);
////        }
//    }
//    
//    //TODO: not implemented yet.
//    /// not implemented yet.
//    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        //add progress block logic
//        if let progress = self.uploadProgress {
//            progress(totalBytesSent,totalBytesExpectedToSend);
//        }
//    }
//    
//    //TODO: not implemented yet.
//    /// not implemented yet.
//    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
////        println("ok.");
//    }
//    
//    deinit{
//        println("http task deinit.");
//    }
//}
//#else

    
//    - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//        
//    }
//    - (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection{
//        NSLog(@"--------------");
//        return TRUE;
//    }
//    - (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
//        NSLog(@"************************");
//    }
//    - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//        NSLog(@"************************");
//        return TRUE;
//    }
//    - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//        NSLog(@"************************");
//    }
//    - (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//        NSLog(@"************************");
//    }
    
//    - (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
//        return request;
//    }
//    - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//        
//    }
    
//    - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//        
//    }
    
//    - (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request{
//        
//    }
//    - (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
//totalBytesWritten:(NSInteger)totalBytesWritten
//totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
//    NSLog(@"************************");
//}
    
//    - (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
//        NSLog(@"************************");
//    }
    
//    - (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//        NSLog(@"************************");
//    }
//#endif
@end

@interface HttpRequestSerializer (){
    @private
    NSString * contentTypeKey;
}

@end
@implementation HttpRequestSerializer
//{
//    @private
//    NSString * contentTypeKey;
//}
//@property NSDictionary * headers;
//@property uint stringEncoding;
//@property BOOL allowsCellularAccess;
//@property BOOL HTTPShouldHandleCookies;
//@property BOOL HTTPShouldUsePipelining;
//@property NSTimeInterval timeoutInterval;
//@property NSURLRequestCachePolicy cachePolicy;
//@property NSURLRequestNetworkServiceType networkServiceType;

-(id)init{
    self = [super init];
    if (self) {
        contentTypeKey = @"Content-Type";
//        public var headers = Dictionary<String,String>()
        self.headers = [[NSDictionary alloc] init];
        //    /// encoding for the request.
        //    public var stringEncoding: UInt = NSUTF8StringEncoding
        self.stringEncoding = NSUTF8StringEncoding;
        //    /// Send request if using cellular network or not. Defaults to true.
        //    public var allowsCellularAccess = true
        self.allowsCellularAccess = TRUE;
        //    /// If the request should handle cookies of not. Defaults to true.
        //    public var HTTPShouldHandleCookies = true
        self.HTTPShouldHandleCookies = TRUE;
        //    /// If the request should use piplining or not. Defaults to false.
        //    public var HTTPShouldUsePipelining = false
        self.HTTPShouldUsePipelining = FALSE;
        //    /// How long the timeout interval is. Defaults to 60 seconds.
        //    public var timeoutInterval: NSTimeInterval = 60
        self.timeoutInterval = 60;
        //    /// Set the request cache policy. Defaults to UseProtocolCachePolicy.
        //    public var cachePolicy: NSURLRequestCachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        //    /// Set the network service. Defaults to NetworkServiceTypeDefault.
        //    public var networkServiceType = NSURLRequestNetworkServiceType.NetworkServiceTypeDefault
        self.networkServiceType = NSURLNetworkServiceTypeDefault;
    }
    
    return self;
}

-(NSMutableURLRequest*)newRequest:(NSURL*)url method:(HttpMethod)method {
//    return nil;
//    var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:self.cachePolicy timeoutInterval:self.timeoutInterval];
//    request.HTTPMethod = method;
    switch (method) {// GET,POST,PUT,HEAD,DELETE
        case GET:
            request.HTTPMethod = @"GET";
            break;
        case PUT:
            request.HTTPMethod = @"PUT";
            break;
        case HEAD:
            request.HTTPMethod = @"HEAD";
            break;
        case DELETE:
            request.HTTPMethod = @"DELETE";
            break;
        case POST:
        default:
            request.HTTPMethod = @"POST";
            break;
    }
    //        request.HTTPMethod = method.rawValue
    //        request.cachePolicy = self.cachePolicy
    request.cachePolicy = self.cachePolicy;
    //        request.timeoutInterval = self.timeoutInterval
    request.timeoutInterval = self.timeoutInterval;
//#if __OSX_AVAILABLE_STARTING(10_8, 6_0)//10_8, 6_0
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0){
        request.allowsCellularAccess = self.allowsCellularAccess;
    }
//#endif
    
    request.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies;
    request.HTTPShouldUsePipelining = self.HTTPShouldUsePipelining;
    request.networkServiceType = self.networkServiceType;
    //        for (key,val) in self.headers {
    //            request.addValue(val, forHTTPHeaderField: key)
    //        }
    //        return request
    for (NSString * key in self.headers.keyEnumerator) {
        [request addValue:self.headers[key] forHTTPHeaderField:key];
    }
    return request;
}

-(NSMutableURLRequest*)createRequest:(NSURL *)url method:(HttpMethod)method parameters:(NSDictionary*)parameters isMulti:(BOOL)isMulti error:(NSError**)error{
    //        var request = newRequest(url, method: method)
    NSMutableURLRequest * request = [self newRequest:url method:method];
    //        var isMulti = isDefMulti;
    if (isMulti == false) {
        isMulti = [self isMultiForm:parameters];
    }
    if (isMulti) {
        if (method != POST && method != PUT) {
            request.HTTPMethod = @"POST";
        }
//        u_int32_t one = arc4random();
//        u_int32_t two = arc4random();
        //NSString * boundary = [[NSString alloc] initWithFormat:@"Boundary+%d%d",one,two];
//        NSString * boundary = @"---------------------------88739631214394723612117964652";
        NSString * boundary = @"Boundary+25536756613635582792";
        if (parameters != nil) {
            request.HTTPBody = [self dataFromParameters:parameters boundary:boundary];
        }
        if ([request valueForHTTPHeaderField:contentTypeKey] == nil) {
            [request setValue:[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:contentTypeKey];
        }
        return request;
    }
  
    NSString * queryString ;
    if (parameters != nil) {
        queryString = [self stringFromParameters:parameters];
    }
    if ([self isURIParam:method]) {
        NSString * para = request.URL.query != nil ? @"&" : @"?";
        NSString * newUrl = request.URL.absoluteString;
        if (queryString.length > 0) {
            newUrl = [[NSString alloc] initWithFormat:@"%@%@%@",newUrl,para,queryString];
            newUrl = [newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        request.URL = [[NSURL alloc] initWithString:newUrl];
    }else{
        CFStringRef charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
                                           
        if ([request valueForHTTPHeaderField:contentTypeKey] == nil) {
            [request setValue:[[NSString alloc] initWithFormat: @"application/x-www-form-urlencoded; charset=%@",charset] forHTTPHeaderField:contentTypeKey];
            //[request setValue:[[NSString alloc] initWithFormat: @"application/json; charset=%@",charset] forHTTPHeaderField:contentTypeKey];
        }
        request.HTTPBody = [queryString dataUsingEncoding:self.stringEncoding];
        
    }
    //        var queryString = ""
    //        if parameters != nil {
    //            queryString = self.stringFromParameters(parameters!)
    //        }
    //        if isURIParam(method) {
    //            var para = (request.URL!.query != nil) ? "&" : "?"
    //            var newUrl = "\(request.URL!.absoluteString!)"
    //            if countElements(queryString) > 0 {
    //                newUrl += "\(para)\(queryString)"
    //            }
    //            request.URL = NSURL(string: newUrl)
    //        } else {
    //            var charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
    //            if request.valueForHTTPHeaderField(contentTypeKey) == nil {
    //                request.setValue("application/x-www-form-urlencoded; charset=\(charset)",
    //                                 forHTTPHeaderField:contentTypeKey)
    //            }
    //            request.HTTPBody = queryString.dataUsingEncoding(self.stringEncoding)
    //        }
    //        return (request,nil)
    
    return request;
}
-(NSMutableURLRequest*)createRequest:(NSURL *)url method:(HttpMethod)method parameters:(NSDictionary*)parameters error:(NSError**)error{
    return [self createRequest:url method:method parameters:parameters isMulti:FALSE error:error];
}
-(BOOL)isMultiForm:(NSDictionary*)params{
//    for (name,object: AnyObject) in params {
    NSObject * value;
    for (NSString * key in params) {
        value = params[key];
        if ([value isKindOfClass:[HttpUpload class]]) {
            return TRUE;
        }else if ([value isKindOfClass:[NSDictionary class]]){
            if ([self isMultiForm:(NSDictionary*)value]) {
                return true;
            }
        }
    }
        //            if object is HttpUpload {
        //                return true
        //            } else if let subParams = object as? Dictionary<String,AnyObject> {
        //                if isMultiForm(subParams) {
        //                    return true
        //                }
        //            }
        //        }
        //        return false
    return false;
}
-(NSString*)stringFromParameters:(NSDictionary*)parameters{
//    return join("&", map(serializeObject(parameters, key: nil), {(pair) in
        //            return pair.stringValue()
        //        }))
    NSMutableString * str = [[NSMutableString alloc] init];
    BOOL isFirst = true;
    for (NSString * key in parameters.keyEnumerator) {
        if (!isFirst) {
            [str appendString:@"&"];
        }
        isFirst = false;
        [str appendString:key];
        [str appendString:@"="];
        [str appendString:parameters[key]];
    }
    return str;
}
-(BOOL)isURIParam:(HttpMethod)method{
    if(method == GET || method == HEAD || method == DELETE) {
        return true;
    }
    return false;
}
-(NSArray*)serializeObject:(NSObject*)object key:(NSString*)key{
//    var collect = Array<HttpPair>()
    NSMutableArray * collect = [[NSMutableArray alloc] init];
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray * array = (NSArray *)object;
        key = key == nil ? @"" : key;
        for (NSObject * nestedValue in array) {
            [collect addObjectsFromArray:[self serializeObject:nestedValue key:[[NSString alloc] initWithFormat:@"%@[]",key]]];
        }
    }
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = (NSDictionary*)object;
//        NSObject * nestedObject;
        NSString * newKey;
        for (NSString * nestedKey in dic) {
            newKey = key != nil ? [[NSString alloc] initWithFormat:@"%@[%@]",key,nestedKey] : nestedKey;
            //[collect addObject:[self serializeObject:nestedObject key:newKey]];
            [collect addObjectsFromArray:[self serializeObject:dic[nestedKey] key:newKey]];
        }
    }else{
        [collect addObject:[[HttpPair alloc] initWithValue:object key:key]];
    }

    return collect;
}
-(NSData*)dataFromParameters:(NSDictionary*)parameters boundary:(NSString*)boundary{
    //        var mutData = NSMutableData()
    NSMutableData * mutData = [[NSMutableData alloc] init];
    NSString * multiCRLF = @"\r\n";
    
    NSData * boundSplit = [[[NSString alloc] initWithFormat:@"%@--%@%@",multiCRLF,boundary,multiCRLF ] dataUsingEncoding:self.stringEncoding];
    NSData * lastBound = [[[NSString alloc] initWithFormat:@"%@--%@--%@",multiCRLF,boundary,multiCRLF ] dataUsingEncoding:self.stringEncoding];
    [mutData appendData:[[[NSString alloc] initWithFormat:@"--%@%@",boundary,multiCRLF ] dataUsingEncoding:self.stringEncoding]];
    //        var multiCRLF = "\r\n"
    //        var boundSplit =  "\(multiCRLF)--\(boundary)\(multiCRLF)".dataUsingEncoding(self.stringEncoding)!
    //        var lastBound =  "\(multiCRLF)--\(boundary)--\(multiCRLF)".dataUsingEncoding(self.stringEncoding)!
    //        mutData.appendData("--\(boundary)\(multiCRLF)".dataUsingEncoding(self.stringEncoding)!)
    //
    NSArray * pairs = [self serializeObject:parameters key:nil];
    //        let pairs = serializeObject(parameters, key: nil)
    int count = pairs.count - 1;
    //        let count = pairs.count-1
    //        var i = 0
//    int i = 0;
   
//    for (HttpPair * pair in pairs.objectEnumerator) {
    HttpPair * pair;
    for (int n=0; n<pairs.count; n++) {
        pair = pairs[n];
        BOOL append = TRUE;
        HttpUpload * upload = [pair getUpload];
        if (upload != nil) {
            NSData * tmpData = [upload data];
            if (tmpData != nil) {
//                NSData * t = ;
                [mutData appendData:[[self multiFormHeader:pair.key fileName:upload.fileName type:upload.mimeType multiCRLF:multiCRLF] dataUsingEncoding:self.stringEncoding] ];
//                mutData.appendData(data)
                [mutData appendData:tmpData];
            }else{
                append = FALSE;
            }
        }else{
            [mutData appendData:[[[NSString alloc] initWithFormat:@"%@%@",[self multiFormHeader:pair.key fileName:nil type:nil multiCRLF:multiCRLF],[pair getValue]] dataUsingEncoding:self.stringEncoding]];
//            [mutData appendData:[[[NSString alloc] initWithFormat:@"%@%@",[self multiFormHeader:pair.key fileName:nil type:@"application/json" multiCRLF:multiCRLF],[pair getValue]] dataUsingEncoding:self.stringEncoding]];
            
            
//            [mutData appendData:[pair.getValue() Do]
        }
        
        if (append) {
            if (n == count) {
                [mutData appendData:lastBound];
            }else{
                [mutData appendData:boundSplit];
            }
        }
    }
    return mutData;
    //        for pair in pairs {
    //            var append = true
    //            if let upload = pair.getUpload() {
    //                if let data = upload.data {
    //                    mutData.appendData(multiFormHeader(pair.key, fileName: upload.fileName,
    //                                                       type: upload.mimeType, multiCRLF: multiCRLF).dataUsingEncoding(self.stringEncoding)!)
    //                    mutData.appendData(data)
    //                } else {
    //                    append = false
    //                }
    //            } else {
    //                let str = "\(self.multiFormHeader(pair.key, fileName: nil, type: nil, multiCRLF: multiCRLF))\(pair.getValue())"
    //                mutData.appendData(str.dataUsingEncoding(self.stringEncoding)!)
    //            }
    //            if append {
    //                if i == count {
    //                    mutData.appendData(lastBound)
    //                } else {
    //                    mutData.appendData(boundSplit)
    //                }
    //            }
    //            i++
    //        }
    //        return mutData
//    return nil;
}

//-(NSString *)escaped:(NSString*)string{
//        CFStringRef e = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string,(CFStringRef) @"[].", (CFStringRef)@":/?&=;+!@#$()',*", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    
//        return (__bridge NSString *)(e);
//}
-(NSString*)multiFormHeader:(NSString*)name fileName:(NSString*)fileName type:(NSString*)type multiCRLF:(NSString*)multiCRLF{
    //     var str = "Content-Disposition: form-data; name=\"\(name.escaped)\""
    //        if fileName != nil {
    //            str += "; filename=\"\(fileName!)\""
    //        }
    //        str += multiCRLF
    //        if type != nil {
    //            str += "Content-Type: \(type!)\(multiCRLF)"
    //        }
    //        str += multiCRLF
    //        return str
//    NSString * s2 = @"";
//    NSLog(@"%@",name);
//    NSString * s = name.escaped;
//    NSLog(@"%@",s);
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"Content-Disposition: form-data; name=%@",name.escaped];
    if (fileName != nil) {
        [str appendString:@"; filename="];
        [str appendString:fileName];
    }
    [str appendString:multiCRLF];
    if (type != nil) {
        [str appendString:@"Content-Type: "];
        [str appendString:type];
        [str appendString:multiCRLF];
    }
    [str appendString:multiCRLF];
    return str;
}
@end


//    
//    //create a multi form data object of the parameters
//    func dataFromParameters(parameters: Dictionary<String,AnyObject>,boundary: String) -> NSData {

//    }
//    
//    ///helper method to create the multi form headers
//    func multiFormHeader(name: String, fileName: String?, type: String?, multiCRLF: String) -> String {
//
//    }
//    
//    /// Creates key/pair of the parameters.
@implementation HttpPair

//@property(atomic,readonly) NSObject * value;
//@property(atomic,readonly) NSString * key;

-(id)initWithValue:(NSObject*)value key:(NSString*)key{
    self = [super init];
    if (self) {
        self->_value = value;
        self->_key = key;
    }
    return self;
}

-(HttpUpload*)getUpload{
    //return (HttpUpload*)self.value;
    if ([self.value isKindOfClass:[HttpUpload class]]) {
        return (HttpUpload*)self.value;
    }else{
        return nil;
    }
}
-(NSString*)getValue{
    if ([self.value isKindOfClass:[NSString class]]) {
        return (NSString*)self.value;
    }
    if (self.value.description != nil) {
        return self.value.description;
    }
    return @"";
}
-(NSString*)stringValue{
    NSString * val = [self getValue];
    if (self.key == nil) {
        return val.escaped;
    }
    return [[NSString alloc] initWithFormat:@"%@=%@",self.key.escaped,val.escaped ];
}

@end

@implementation HttpUpload

-(id)initWithFileUrl:(NSURL*)fileUrl{
    self = [super init];
    if (self) {
        self.fileUrl = fileUrl;
        [self updateMimeType];
        [self loadData];
    }
    return self;
}
-(id)initWithData:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)mimeType{
    self = [super init];
    if (self) {
        self->_data = data;
        self->_fileName = fileName;
        self->_mimeType = mimeType;
    }
    return self;
}

-(BOOL)jsonSkip:(NSString*)name{
    return true;
}
//public func jsonSkip(name:String?)->Bool{
//    return true;
//}
//
//private var fileUrl: NSURL? {
//    didSet {
//        updateMimeType()
//        loadData()
//    }
//}
//private var _mimeType: String?
//private var _data: NSData?
//private var _fileName: String?
//
//
//public var mimeType: String?{
//    return self._mimeType;
//}
//public var data: NSData?{
//    return self._data;
//}
//public var fileName: String?{
//    return self._fileName;
//}
//
///// Tries to determine the mime type from the fileUrl extension.
//func updateMimeType() {

//}
//
///// loads the fileUrl into memory.
//func loadData() {
//
//}
//
///// Initializes a new HTTPUpload Object.
//public override init() {
//    super.init()
//}
//
///**
// Initializes a new HTTPUpload Object with a fileUrl. The fileName and mimeType will be infered.
// 
// :param: fileUrl The fileUrl is a standard url path to a file.
// */
//public convenience init(fileUrl: NSURL) {
//    self.init()
//
//}
//
///**
// Initializes a new HTTPUpload Object with a data blob of a file. The fileName and mimeType will be infered if none are provided.
// 
// :param: data The data is a NSData representation of a file's data.
// :param: fileName The fileName is just that. The file's name.
// :param: mimeType The mimeType is just that. The mime type you would like the file to uploaded as.
// */
/////upload a file from a a data blob. Must add a filename and mimeType as that can't be infered from the data
//public convenience init(data: NSData, fileName: String, mimeType: String) {
//    self.init()
//    self._data = data
//    self._fileName = fileName
//    self._mimeType = mimeType
//}
//@property(atomic) NSURL * fileUrl;
//@property(atomic,readonly) NSString * mimeType;
//@property(atomic,readonly) NSData * data;
//@property(atomic,readonly) NSString * fileName;

-(void)updateMimeType{
    if (self.mimeType == nil && self.fileUrl != nil) {
       CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,(__bridge CFStringRef)((NSString*)self.fileUrl.pathExtension),nil);
        NSString * str = (__bridge NSString *)(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
        if (str == nil) {
            _mimeType = @"application/octet-stream";
        }else{
            _mimeType = str;
        }
    }
    //    if mimeType == nil && fileUrl != nil {
    //        var UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileUrl?.pathExtension as NSString?, nil);
    //        var str = UTTypeCopyPreferredTagWithClass(UTI.takeUnretainedValue(), kUTTagClassMIMEType);
    //        if (str == nil) {
    //            _mimeType = "application/octet-stream";
    //        } else {
    //            _mimeType = str.takeUnretainedValue() as NSString
    //        }
    //    }
}
-(void)loadData{
    if (self.fileUrl != nil) {
        //        self._fileName = url.lastPathComponent
        self->_fileName = self.fileUrl.lastPathComponent;
        self->_data = [NSData dataWithContentsOfFile:_fileUrl.path options:NSDataReadingMappedIfSafe error:nil];
                       
           
        //        self._data = NSData.dataWithContentsOfMappedFile(url.path!) as? NSData
    }
}

@end


@interface HttpOperationIOS6: HttpOperation{
@package
    NSMutableURLRequest * request;
    NSURLConnection * conn;
    //#endif
}
//@property(atomic) NSURLSessionTask * task;
@end
@implementation HttpOperationIOS6


-(void)cancel{
    [super cancel];
    [self->conn cancel];
}



@end


@interface HttpOperationIOS7 : HttpOperation{

    @package
    NSURLSessionTask * task;
}
@end
@implementation HttpOperationIOS7

-(void)start{
    [super start];
    [task resume];
}

-(void)cancel{
    [super cancel];
    [task cancel];
}

@end


////<NSURLSessionDelegate,NSURLSessionTaskDelegate>

@interface HttpTaskIOS7()<NSURLSessionDelegate,NSURLSessionTaskDelegate>{
@private
    NSURLSession * session;
    void(^_progress)(int64_t,int64_t);
}
@end

@implementation HttpTaskIOS7

-(id)init{
    self = [super init];
    if (self) {
        
        if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0){
            NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
            
        }
        
    }
    return self;
}

-(HttpOperation*)createImpl:(NSMutableURLRequest*)request success:(void(^)(HttpResponse*))success failure:(void(^)(NSError *,HttpResponse*))failure {
    HttpOperationIOS7 * opt = nil;
    //###############################################################################################
    //#if __OSX_AVAILABLE_STARTING(10_9, 7_0)
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    
        opt = [[HttpOperationIOS7 alloc] init];
        
        __weak id weakself = self;
    
        NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [weakself processResponse:success failure:failure data:data response:response error:error];
        }];
        
        opt->task = task;
   
    //#endif
    return opt;
}

-(void)uploadFile:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug progress:(void(^)(int64_t,int64_t))progress success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure{
    
    
    
    self->_progress = progress;
    //###############################################################################################
    //#if __OSX_AVAILABLE_STARTING(10_9, 7_0)
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        NSError * error;
        
        //    NSMutableURLRequest * request = [self createRequest:url method:POST parameters:parameters isDebug:isDebug error:&error];
        NSMutableURLRequest * request = [self createRequest:url method:POST parameters:parameters isDebug:isDebug isMulti:TRUE error:&error];
        //
        //
        if (error != nil) {
            if (failure != nil) {
                failure(error,nil);
            }
            return;
        }
        //        let serialReq = createRequest(url,method: .GET, parameters: parameters,isDebug:isDebug,isMulti:true)
        //        if serialReq.error != nil {
        //            failure(serialReq.error!,nil)
        //            return
        //        }
        //        self.uploadProgress = progress;
        ////        self.uploadSuccess = success;
        ////        self.uploadFailure = failure;
        //
        ////        var task = session.uploadTaskWithRequest(serialReq.request, fromData: nil);
        //
        
        NSURLSessionUploadTask * task = [session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [self processResponse:success failure:failure data:data response:response error:error];
        }];
        [task resume];
       //#endif
    
    //###############################################################################################
    
    //        var task = session.uploadTaskWithRequest(serialReq.request, fromData:nil, completionHandler: {(data:NSData!,response: NSURLResponse!, error:NSError!) in
    //            self.processResponse(success,failure:failure,data:data,response:response,error:error);
    //        });
    //        task.resume();
    //
    //    }
    //
    //    private var uploadProgress:((Int64,Int64) -> Void)!;
    
}



-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
//    if (self.auth != nil) {
//        NSURLCredential * cred = self.auth(challenge);
//        if (cred != nil) {
//            completionHandler(NSURLSessionAuthChallengeUseCredential,cred);
//        }else{
//            completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace,cred);
//        }
//    }else{
//        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
//    }
    if (!challenge) {
        return;
    }
    
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengeUseCredential;
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    
    // 对于其他的challenges直接使用默认的验证方案
    completionHandler(disposition,credential);
}
//        if let a = auth {
//            let cred = a(challenge)
//            if let c = cred {
//                completionHandler(.UseCredential, c)
//            }
//            completionHandler(.RejectProtectionSpace, nil)
//            return
//        }
//        completionHandler(.PerformDefaultHandling, nil)
//    }
//
//    /// Called when the background task failed.
//    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didCompleteWithError error: NSError!) {
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
}

@end


@interface HttpTaskIOS6(){
    @private
    NSMutableData * buffer;
    void(^_success)(HttpResponse*);
    void(^_failure)(NSError *,HttpResponse*);
    NSURLResponse * _response;
    
    void(^_progress)(int64_t,int64_t);
}

@end
@implementation HttpTaskIOS6


-(HttpOperation*)createImpl:(NSMutableURLRequest*)request success:(void(^)(HttpResponse*))success failure:(void(^)(NSError *,HttpResponse*))failure {
    HttpOperationIOS6 * opt = nil;
    
        
    //#else
    //###############################################################################################
    
    //NSLog(@"thread:%@",[NSThread currentThread]);
    //        conn = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    //NSLog(@"request thread:%@",[NSThread currentThread]);
    
    static NSOperationQueue * _queue = nil;
    static dispatch_once_t _queue_once_t = 0;
    dispatch_once(&_queue_once_t, ^{
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 10;
    });
    //    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //        NSURLConnection * conn = [[NSURLConnection alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        HttpResponse * extraResponse = nil;//[[HttpResponse alloc] init];
        if(response != nil){
            
            extraResponse = [[HttpResponse alloc] init];
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse * hresponse = (NSHTTPURLResponse*)response;
                extraResponse.headers = hresponse.allHeaderFields;
                extraResponse.mimeType = hresponse.MIMEType;
                extraResponse.suggestedFilename = hresponse.suggestedFilename;
                extraResponse.statusCode = hresponse.statusCode;
                extraResponse.URL = hresponse.URL;
            }
            extraResponse.responseObect = data;
            //_failure(error,extraResponse);
            //            extraResponse.responseObect = resObj;
            if (extraResponse.statusCode > 299) {
                //        statements
                if(failure != nil){
                    //error(self.createError(extraResponse.statusCode!), extraResponse)
                    //HttpError * e =
                    failure([self createError:extraResponse.statusCode],extraResponse);
                }
                return;
            }
        }
        if(connectionError != nil){
            if(_failure != nil){
                _failure(connectionError,extraResponse);
            }
        }else{
            if(_success != nil){
                _success(extraResponse);
            }
        }
    }];
    _success = success;
    _failure = failure;
        //        opt->conn = conn;
        //    opt->request = request;
        //    opt->delegate = self;
        //    opt
    
    //#endif
    return opt;
}


-(void)uploadFile:(NSString*)url parameters:(NSDictionary*)parameters isDebug:(BOOL)isDebug progress:(void(^)(int64_t,int64_t))progress success:(void(^)(HttpResponse*))success failure:(void(^)(NSError*,HttpResponse*))failure{
    
    
    
    self->_progress = progress;
    
        
        //    HttpOperation * opt = [self create:url method:POST parameters:parameters isDebug:isDebug success:success failure:failure];
        HttpOperation * opt = [self create:url method:POST parameters:parameters isDebug:isDebug isMulti:TRUE success:success failure:failure];
        [opt start];

    
}



- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse{
    buffer = [[NSMutableData alloc] init];
    _response = aResponse;
}
//    // 你可以在里面判断返回结果, 或者处理返回的http头中的信息
//
//    // 每收到一次数据, 会调用一次
//    - (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data;
// 因此一般来说,是
- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data
{
    [buffer appendData:data];
}
// 当然buffer就是前面initWithRequest时同时声明的.

// 网络错误时触发
- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error{
    if(self->_failure != nil){
        //        NSLog(@"error:%@",error);
        if(_response != nil){
            HttpResponse * extraResponse = [[HttpResponse alloc] init];
            
            if ([_response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse * hresponse = (NSHTTPURLResponse*)_response;
                extraResponse.headers = hresponse.allHeaderFields;
                extraResponse.mimeType = hresponse.MIMEType;
                extraResponse.suggestedFilename = hresponse.suggestedFilename;
                extraResponse.statusCode = hresponse.statusCode;
                extraResponse.URL = hresponse.URL;
            }
            _failure(error,extraResponse);
            //            extraResponse.responseObect = resObj;
            //            if (extraResponse.statusCode > 299) {
            //                //        statements
            //                if(failure != nil){
            //                    //error(self.createError(extraResponse.statusCode!), extraResponse)
            //                    //HttpError * e =
            //                    failure([self createError:extraResponse.statusCode],extraResponse);
            //                }
            //                return;
            //            }
            
        }else{
            _failure(error,nil);
        }
    }
}

// 全部数据接收完毕时触发
- (void)connectionDidFinishLoading:(NSURLConnection *)aConn{
    NSLog(@"conn thread:%@",[NSThread currentThread]);
    [self processResponse:_success failure:_failure data:buffer response:_response error:nil];
}

@end
