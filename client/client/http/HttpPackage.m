//
//  Package.swift
//  LinClient
//
//  Created by lin on 11/27/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpPackage.h"
#import "HttpRequestHandle.h"
#import "StandardJsonHttpRequestHandle.h"


id<HttpRequestHandle> HTTP_NONE_HANDLE = nil;
dispatch_once_t HTTP_NONE_HANDLE_ONCE_T = 0;


id<HttpRequestHandle> HTTP_STANDARD_HANDLE = nil;
dispatch_once_t HTTP_STANDARD_HANDLE_ONCE_T = 0;


id<HttpRequestHandle> HTTP_STANDARD_JSON_HANDLE = nil;
dispatch_once_t HTTP_STANDARD_JSON_HANDLE_ONCE_T = 0;


id<HttpRequestHandle> HTTP_ENCRYPT_JSON_HANDLE = nil;
dispatch_once_t HTTP_ENCRYPT_JSON_HANDLE_ONCE_T = 0;

@implementation HttpPackage

-(id)initWithUrl:(NSString *)url{
    return [self initWithUrl:url method:POST];
}

-(id)initWithUrl:(NSString *)url method:(HttpMethod)method{
    self = [super init];
    if(self){
        self.enableCache = false;
        self->_url = url;
        self->_method = method;
        self->_handle = HttpPackage.STANDARD_JSON_HANDLE;
    }
    return self;
}


-(NSObject*)getResult:(Json *)json{
    return json;
}

+(id<HttpRequestHandle>)NONE_HANDLE{
    dispatch_once(&HTTP_NONE_HANDLE_ONCE_T,^{
    
    });
    return HTTP_NONE_HANDLE;
}

+(id<HttpRequestHandle>)STANDARD_HANDLE{
    dispatch_once(&HTTP_STANDARD_HANDLE_ONCE_T,^{
        
    });
    return HTTP_STANDARD_HANDLE;
}
+(id<HttpRequestHandle>)STANDARD_JSON_HANDLE{
    dispatch_once(&HTTP_STANDARD_JSON_HANDLE_ONCE_T,^{
        HTTP_STANDARD_JSON_HANDLE = [[StandardJsonHttpRequestHandle alloc] init];
    });
    return HTTP_STANDARD_JSON_HANDLE;
}
+(id<HttpRequestHandle>)ENCRYPT_JSON_HANDLE{
    dispatch_once(&HTTP_ENCRYPT_JSON_HANDLE_ONCE_T,^{
        
    });
    return HTTP_ENCRYPT_JSON_HANDLE;
}

-(NSDictionary*)toParams{
    NSDictionary * p = [self.json toParams:FALSE];// [Json toParamsJson:@"" value:self.value];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    for (NSString * key in p.keyEnumerator) {
        if (p[key] != nil && ![p[key] isKindOfClass:[NSNull class]]) {
            params[key] = p[key];
        }
    }
    return params;
}

@end

@protocol HttpRequestHandle;



//            YRSingleton.instance = NoneHttpRequestHandle()


//            YRSingleton.instance = StandardHttpRequestHandle()


//            YRSingleton.instance = StandardJsonHttpRequestHandle()

//            YRSingleton.instance = EncryptJsonHttpRequestHandle()


