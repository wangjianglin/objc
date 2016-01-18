//
//  CDVCacheURLPr.m
//  ses
//
//  Created by 王江林 on 14-6-15.
//
//

#import "LinURLCacheProtocol.h"
#import "LinUtil/util.h"

static NSString *LinURLCachingHeader = @"X-Lin-Cache";
#define WORKAROUND_MUTABLE_COPY_LEAK 1


#if WORKAROUND_MUTABLE_COPY_LEAK
@implementation NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround {
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[self URL]
                                                                          cachePolicy:[self cachePolicy]
                                                                      timeoutInterval:[self timeoutInterval]];
    [mutableURLRequest setAllHTTPHeaderFields:[self allHTTPHeaderFields]];
    return mutableURLRequest;
}

@end
#endif

@interface LinHTTPURLCacheResponse : NSHTTPURLResponse
@property NSInteger statusCode;
@end




@implementation LinHTTPURLCacheResponse
@synthesize statusCode;

- (NSDictionary*)allHeaderFields
{
    return nil;
}

@end

@interface LinURLCacheProtocol()

@property NSURLConnection * connection;
@property NSMutableString * cacheFile;
@property NSMutableData * data;

@end

@implementation LinURLCacheProtocol


+ (void)cache:(NSString *)url
{
    static dispatch_once_t _register_cache = 0;
    dispatch_once(&_register_cache, ^{
        [NSURLProtocol registerClass:[LinURLCacheProtocol class]];
    });
}

+(void)remove:(NSString *)url{
    
}

+(void)createCachePath:(NSString*)path{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDir = false;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir] || isDir == false) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:TRUE attributes:nil error:nil];
    }
}

+(NSString *)cachePath{
    static NSString * _path = nil;
    static dispatch_once_t _path_once_t = 0;
    dispatch_once(&_path_once_t, ^{
        _path = pathFor(DocumentsCache, @"imagecache");
        [LinURLCacheProtocol createCachePath:_path];
    });
    
    return _path;
}
+(void)setCachePath:(NSString *)path{
    
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
{
    NSURL* theUrl = [theRequest URL];
    
    NSString * absoluteString = [theUrl absoluteString];
    
    if([theRequest valueForHTTPHeaderField:LinURLCachingHeader] == nil && [absoluteString hasPrefix:@"http://"] &&
       ([absoluteString hasSuffix:@".png"] ||
            [absoluteString hasSuffix:@".jpg"] ||
            [absoluteString hasSuffix:@".gif"])){
        return YES;
    }
    return NO;
}

- (void)sendResponseWithResponseCode:(NSInteger)statusCode data:(NSData*)data mimeType:(NSString*)mimeType
{
    if (mimeType == nil) {
        mimeType = @"text/plain";
    }
    NSString* encodingName = [@"text/plain" isEqualToString : mimeType] ? @"UTF-8" : nil;
    
    LinHTTPURLCacheResponse* response =
    [[LinHTTPURLCacheResponse alloc] initWithURL:[[self request] URL]
                                        MIMEType:mimeType expectedContentLength:[data length]
                                textEncodingName:encodingName];
    response.statusCode = statusCode;
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    if (data != nil) {
        [[self client] URLProtocol:self didLoadData:data];
    }
    [[self client] URLProtocolDidFinishLoading:self];
}

-(void)stopLoading{
    
}


-(void)startLoading{

    NSString * md5 = [self.request.URL absoluteString].md5;

    if ([LinURLCacheProtocol.cachePath hasSuffix:@"/"]) {
        self.cacheFile = [[NSMutableString alloc] initWithFormat:@"%@%@", LinURLCacheProtocol.cachePath , md5 ];
    }else{
        self.cacheFile = [[NSMutableString alloc] initWithFormat:@"%@/%@", LinURLCacheProtocol.cachePath , md5 ];
    }

    NSData *data=[NSData dataWithContentsOfFile:self.cacheFile];
    NSString * mimeType = nil;

    
    
    if(data != nil){
        if([[self.request.URL path] hasSuffix:@".png"]){
            mimeType = @"image/png";
        }else if([[self.request.URL path] hasSuffix:@".gif"]){
            mimeType = @"image/gif";
        }else if([[self.request.URL path] hasSuffix:@".jpg"]){
            mimeType = @"image/jpeg";
        }else if([[self.request.URL path] hasSuffix:@".pdf"]){
            mimeType = @"application/pdf";
        }
        [self sendResponseWithResponseCode:200 data:data mimeType:mimeType];
    }else{
        
         NSMutableURLRequest * redirectRequest = [[NSMutableURLRequest alloc] initWithURL:self.request.URL];
        [redirectRequest setValue:@"" forHTTPHeaderField:LinURLCachingHeader];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:redirectRequest
                                                                    delegate:self];
        self.connection = connection;

    }
}



- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    // Thanks to Nick Dowell https://gist.github.com/1885821
    if (response != nil) {
        NSMutableURLRequest *redirectableRequest =
#if WORKAROUND_MUTABLE_COPY_LEAK
        [request mutableCopyWorkaround];
#else
        [request mutableCopy];
#endif
     
        [redirectableRequest setValue:nil forHTTPHeaderField:LinURLCachingHeader];
        
        return redirectableRequest;
    } else {
        return request;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)appendData:(NSData *)newData
{
    if (self.data == nil) {
        self.data = [newData mutableCopy];
    }
    else {
        [self.data appendData:newData];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    NSLog(@"error code:%d %@ %@",error.code,error.description,error.debugDescription);
    [[self client] URLProtocol:self didFailWithError:error];
    [self setConnection:nil];
    
    [self setData:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];  // We cache ourselves.
   
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self client] URLProtocolDidFinishLoading:self];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    if(self.data != nil){
        [fm createFileAtPath:self.cacheFile contents:self.data attributes:nil];
        for (int n=0; n<1000; n++) {
            [fm createFileAtPath:[[NSString alloc] initWithFormat:@"%@%d",self.cacheFile,n] contents:self.data attributes:nil];
        }
    }
    [self setConnection:nil];
    [self setData:nil];
}


@end
