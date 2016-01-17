//
//  LinWebController.m
//  LinWeb
//
//  Created by lin on 3/13/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "LinWebController.h"
#import "LinUtil/util.h"
#import <UIKit/UIKit.h>
#import "LinWebPlugin.h"
#import "LinConfigParser.h"
#import <objc/message.h>
#import "LinCore/core.h"
#import "AsynResult.h"

#if DEBUG

@interface WebCache : NSObject
+(void)empty;
+(void)setDisabled:(BOOL)arg1;
@end

#endif


@interface LinWebURLProtocol : NSURLProtocol
//+ (void)registerURLProtocol;

- (void)sendResponseText:(NSString*)result;

@end


@interface LinWebURLResponse : NSHTTPURLResponse
@property NSInteger statusCode;
@end




@implementation LinWebURLResponse
@synthesize statusCode;

- (NSDictionary*)allHeaderFields
{
    return nil;
}

@end

@interface LinWebURLProtocol(){
    UIWebView * webView;
}

@end

@interface AsynResult(){
    LinWebURLProtocol * _web;
    Json * _result;
    NSLock * lock;
}

-(void)setWeb:(LinWebURLProtocol*)web;

@end

@implementation AsynResult

-(instancetype)init{
    self = [super init];
    if(self){
        lock = [[NSLock alloc] init];
    }
    return self;
}
-(void)setWeb:(LinWebURLProtocol*)web{
    [lock lock];
    if (_result != nil) {
        [web sendResponseText:[_result description]];
    }
    _web = web;
    [lock unlock];
}

-(void)setResult:(Json *)result{
    [lock lock];
    if(_web != nil){
        [_web sendResponseText:[result description]];
    }
    _result = result;
    [lock unlock];
}

@end

@implementation LinWebURLProtocol


+(NSMutableArray *)webs{
    
    static NSMutableArray * _webs;
    static dispatch_once_t _webs_once_t = 0;
    static LinConfigParser * configParser;
    dispatch_once(&_webs_once_t, ^{
        _webs = [[NSMutableArray alloc] init];
        [NSURLProtocol registerClass:[LinWebURLProtocol class]];
        configParser = [[LinConfigParser alloc] init];
    });
    return _webs;
}
+(LinConfigParser *)plugins{
    static dispatch_once_t _plugins_once_t = 0;
    static LinConfigParser * configParser;
    dispatch_once(&_plugins_once_t, ^{
        configParser = [[LinConfigParser alloc] init];
    });
    return configParser;
}

+(UIWebView*)webView:(int)flag{
    for (UIWebView * item in LinWebURLProtocol.webs) {
        if (item != nil && item.tag == flag) {
            return item;
        }
    }
    return nil;
}
+ (LinWebPlugin*)plugin:(NSString*)name flag:(int)flag{
    if(name == nil){
        return nil;
    }
    name = [name lowercaseString];
    static dispatch_once_t _plugin_objects_once_t = 0;
    static NSMutableDictionary * pluginObjects;
    dispatch_once(&_plugin_objects_once_t, ^{
        pluginObjects = [[NSMutableDictionary alloc] init];
    });
    NSString * flagObj = [[NSString alloc] initWithFormat:@"%d",flag];
    NSMutableDictionary * item = [pluginObjects objectForKey:flagObj];
    if(item == nil){
        item = [[NSMutableDictionary alloc] init];
        [pluginObjects setValue:item forKey:flagObj];
    }
    LinWebPlugin * obj = [pluginObjects objectForKey:name];
    if(obj == nil){
        LinConfigParser * parser = [LinWebURLProtocol plugins];
        NSString * className = [parser.plugins objectForKey:name];
        obj = [[NSClassFromString(className) alloc] initWithWebView:[LinWebURLProtocol webView:flag]];
        [pluginObjects setValue:obj forKey:name];
    }
    return obj;
}

+ (void)registerURLProtocol:(UIWebView*)webView
{
    __weak UIWebView * _webView = webView;
    [LinWebURLProtocol.webs addObject:_webView];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
{
    NSURL* theUrl = [theRequest URL];
    
    NSString * absoluteString = [theUrl absoluteString];
#if DEBUG
    if ([absoluteString rangeOfString:@"http://init.icloud-analysis.com"].length != 0) {
        return YES;
    }
#endif
    
    if([absoluteString rangeOfString:@":0000/"].length != 0){
           return YES;
       }
    return NO;
}
-(void)actions:(NSString*)action{
    if ([action isEqualToString:@"platform"]) {
        [self sendResponseText:@"\"ios\""];
    }else if ([action isEqualToString:@"productName"]){
        UIDevice * device = [UIDevice currentDevice];
        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%@\"",device.name]];
    }else if ([action isEqualToString:@"versionName"]){
        UIDevice * device = [UIDevice currentDevice];
        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%@\"",device.systemVersion]];
    }else if ([action isEqualToString:@"version"]){
        UIDevice * device = [UIDevice currentDevice];
        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%f\"",[device.systemVersion floatValue]]];
    }else if ([action isEqualToString:@"model"]){
        UIDevice * device = [UIDevice currentDevice];
        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%@\"",device.model]];
    }else if ([action isEqualToString:@"uuid"]){
//        UIDevice * device = [UIDevice currentDevice];
        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%@\"",@"------------"]];
    }
}
-(void)startLoading{
//    __weak LinWebURLProtocol *wself = self;
//    [Queue asynQueue:^{
//        [wself startLoadingImpl];
//    }];
//}
//
//-(void)startLoadingImpl{

#if DEBUG
    NSString * absoluteString = [[self.request URL] absoluteString];
    if ([absoluteString rangeOfString:@"http://init.icloud-analysis.com"].length != 0) {
        return;
    }
#endif

    int flag = [[self.request valueForHTTPHeaderField:@"web-flag"] intValue];
    NSString * name = [self.request valueForHTTPHeaderField:@"plugin"];
    NSString * action = [self.request valueForHTTPHeaderField:@"action"];
    if (name == nil || [name isEqualToString:@""]) {
        [self actions:action];
        return;
    }
    LinWebPlugin * plugin = [LinWebURLProtocol plugin:name flag:flag];
    id r = nil;
    SEL actionSel = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@:",action]);
    if([plugin respondsToSelector:actionSel]){
        NSString * params = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "w"
        r = [plugin performSelector:actionSel withObject:[Json parse:params]];
#pragma clang diagnostic pop

    }else{
        actionSel = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@",action]);
        if([plugin respondsToSelector:actionSel]){
            NSString * params = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "w"
            r = [plugin performSelector:actionSel withObject:nil];
#pragma clang diagnostic pop
        }else{
            [self sendResponseText:@""];
            return;
        }
    }
    
    if ([r isKindOfClass:[NSString class]]) {
        [self sendResponseText:r];
    }
    else if ([r isKindOfClass:[Json class]]) {
        [self sendResponseText:[r description]];
    }else if ([r isKindOfClass:[AsynResult class]]){
        AsynResult * asynResult = (AsynResult*)r;
        [asynResult setWeb:self];
    }else{
        [self sendResponseText:@"{}"];
    }
}

- (void)sendResponseText:(NSString*)result
{
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    LinWebURLResponse * response = [[LinWebURLResponse alloc] initWithURL:[[self request] URL] MIMEType:@"application/json" expectedContentLength:[data length] textEncodingName:@"UTF-8"];
    response.statusCode = 200;

    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}
-(void)stopLoading{
    
}
@end

@interface LinWebController()<UIWebViewDelegate>{
    @private
    UIWebView * _webView;
    NSURLRequestCachePolicy cachePolicy;//
}

@end

@implementation LinWebController

-(void)testAlert{
    UIApplication * app =[UIApplication sharedApplication];
    UIWindow * window = app.windows[0];

//    UIScrollView * scrollView = [[UIScrollView alloc] init];
//    scrollView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.8];
////    scrollView.frame = [UIScreen mainScreen].bounds;
//    scrollView.frame = CGRectMake(0, 0, 300, 300);
//    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    scrollView.maximumZoomScale = 8;
//    scrollView.scrollEnabled = TRUE;
////    scrollView.delegate = self;
//    scrollView.backgroundColor = [UIColor blackColor];
//
//    UIImageView * imageView = [[UIImageView alloc] init];
//    imageView.frame = [UIScreen mainScreen].bounds;
////    imageView.image = [self waterMark:[UIImage imageWithURLString:images[0]] text:sn];
//    [scrollView addSubview:imageView];
////    _imageView = imageView;
//
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithAction:^(NSObject * obj) {
//        [scrollView removeFromSuperview];
//    }];
//    [tap setNumberOfTapsRequired:2];
//    [scrollView addGestureRecognizer:tap];
    
    UIView * view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 300, 300);
    view.backgroundColor = [UIColor blackColor];
    [window addSubview:view];
}
-(void)loadView{
    _webView = [[UIWebView alloc] init];
    self.view = _webView;
    _webView.mediaPlaybackRequiresUserAction = NO;
    
    static int globalWebFlag = 0;
    _webView.tag = ++globalWebFlag;
    
    _webView.delegate = self;
    
    [LinURLCacheProtocol cache:@""];
    
    //[NSURLProtocol registerClass:[LinWebURLProtocol class]];
    
    [LinWebURLProtocol registerURLProtocol:_webView];
    
//    _webView.
//    cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
#if DEBUG
    cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [WebCache setDisabled:YES];
    [WebCache empty];
    
//    清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
#endif
//    [self testAlert];
}

-(void)viewDidLoad{
    
    //ios6不支持
    //self.automaticallyAdjustsScrollViewInsets = FALSE;
    UIView * backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    backgroundView.backgroundColor = [[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:0.6];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_webView addSubview:backgroundView];
    [_webView sendSubviewToBack:backgroundView];
    
    UILabel * lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(0, 18, backgroundView.frame.size.width, 40);
    lable.textColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lable.text = @"翡翠吧吧";
    lable.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:lable];
    
    
    UILabel * copyInfo = [[UILabel alloc] init];
    copyInfo.frame = CGRectMake(0, self.view.bounds.size.height + self.view.bounds.origin.y - 45, backgroundView.frame.size.width, 40);
    copyInfo.textColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    copyInfo.textAlignment = NSTextAlignmentCenter;
    copyInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    copyInfo.text = @"Copyright 2014-2015 翡翠吧吧 All rights reserved";
    copyInfo.font = [UIFont fontWithName:@"STHeitiSC-Light" size: 12.0];
    copyInfo.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:copyInfo];
}


-(void)loadUrl:(NSString *)url{
    if (url == nil) {
        [_webView loadHTMLString:@"error." baseURL:nil];
        return;
    }
    NSURLRequest* appReq = nil;
    if ([url hasPrefix:@"http://"]) {
        appReq = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:cachePolicy timeoutInterval:20.0];
    }else{
//        url = pathFor(DocumentsBundle, url);
//        url = [[NSString alloc] initWithFormat:@"%@%@",url,@"#/tab/nav/home"];
//        NSURL * nsURL = [NSURL fileURLWithPath:url];
//        appReq = [NSURLRequest requestWithURL:nsURL cachePolicy:cachePolicy timeoutInterval:15.0];
        
        NSURL * startURL = [NSURL URLWithString:url];
        NSString * startFilePath = pathFor(DocumentsBundle, [startURL path]);
        
        NSURL * appURL = [NSURL fileURLWithPath:startFilePath];
        NSRange r = [url rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"] options:0];
        if(r.location != NSNotFound){
            NSString * queryAndOrFragment = [url substringFromIndex:r.location];
            appURL = [NSURL URLWithString:queryAndOrFragment relativeToURL:appURL];
        }
        appReq = [NSURLRequest requestWithURL:appURL cachePolicy:cachePolicy timeoutInterval:15.0];
    }
    
    [_webView loadRequest:appReq];
    
//    if ([self.startPage rangeOfString:@"://"].location != NSNotFound) {
//        appURL = [NSURL URLWithString:self.startPage];
//    } else if ([self.wwwFolderName rangeOfString:@"://"].location != NSNotFound) {
//        appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.wwwFolderName, self.startPage]];
//    } else {
//        // CB-3005 strip parameters from start page to check if page exists in resources
//        NSURL* startURL = [NSURL URLWithString:self.startPage];
//        NSLog(@"start page:%@",self.startPage);
//        NSLog(@"start url:%@",startURL);
//        NSString* startFilePath = [self.commandDelegate pathForResource:[startURL path]];
//        
//        NSLog(@"start file path:%@",startFilePath);
//        
//        if (startFilePath == nil) {
//            loadErr = [NSString stringWithFormat:@"ERROR: Start Page at '%@/%@' was not found.", self.wwwFolderName, self.startPage];
//            NSLog(@"%@", loadErr);
//            self.loadFromString = YES;
//            appURL = nil;
//        } else {
//            appURL = [NSURL fileURLWithPath:startFilePath];
//            NSLog(@"app url:%@",appURL);
//            // CB-3005 Add on the query params or fragment.
//            NSString* startPageNoParentDirs = self.startPage;
//            NSRange r = [startPageNoParentDirs rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"] options:0];
//            if (r.location != NSNotFound) {
//                NSString* queryAndOrFragment = [self.startPage substringFromIndex:r.location];
//                appURL = [NSURL URLWithString:queryAndOrFragment relativeToURL:appURL];
//            }
//        }
//    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return TRUE;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

//    UIDevice * device = [UIDevice currentDevice];
//    NSMutableString * webInfo = [[NSMutableString alloc] init];//model
//    [webInfo appendString:@"window.IOSDeviceInfo={model:\""];
//    [webInfo appendString:device.model];
//    [webInfo appendString:@"\",osVersion:\""];
//    [webInfo appendString:[[NSString alloc] initWithFormat:@"%f",[device.systemVersion floatValue]]];
//    [webInfo appendString:@"\""];
//    [webInfo appendString:@"};window.addEventListener( \"DOMContentLoaded\", function(){sessionStorage.setItem(\"name\",\"value333\");}, true )"];
//    [webView stringByEvaluatingJavaScriptFromString:webInfo];
//
//    [webView stringByEvaluatingJavaScriptFromString:webInfo];
//    NSLog(@"js:%@",[[NSString alloc] initWithFormat:@"sessionStorage.setItem('web-flag',%ld);",self.view.tag]);
//    [webView stringByEvaluatingJavaScriptFromString:[[NSString alloc] initWithFormat:@"window.sessionStorage.setItem('web-flag','%ld');",self.view.tag]];
//    
//    [webView stringByEvaluatingJavaScriptFromString:@"window.sessionStorage.setItem('web-flag','%ld');"];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.cookie = 'name=value';"];
    NSString * js = [[NSString alloc] initWithFormat:@"window.addEventListener( \"DOMContentLoaded\", function(){sessionStorage.setItem(\"web-flag\",\"%d\");}, true )",(int)self.view.tag];
//     NSString * js = [[NSString alloc] initWithFormat:@"window.setFlag = function(){sessionStorage.setItem(\"web-flag\",\"%d\");};",(int)self.view.tag];
    [webView stringByEvaluatingJavaScriptFromString:js];
//    [webView stringByEvaluatingJavaScriptFromString:@"window.setFlag();"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end



@implementation LinWebPlugin

- (instancetype)initWithWebView:(UIWebView *)webView{
    self = [super init];
    if(self){
        self->_webView = webView;
    }
    return self;
}

- (void)handleOpenURL:(NSNotification*)notification{
    
}
- (void)onAppTerminate{
    
}
- (void)onMemoryWarning{
    
}
- (void)onReset{
    
}
- (void)dispose{
    
}

- (id)appDelegate{
    return [UIApplication sharedApplication];
}


@end
