//
//  StandardJsonHttpRequestHandle.m
//  LinClient
//
//  Created by lin on 12/3/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StandardJsonHttpRequestHandle.h"

// 采用标准HTTP请求方式传递请求参数，但返回的是json格式的数据
@implementation StandardJsonHttpRequestHandle

-(NSDictionary*)getParams:(HttpTask *)request package:(HttpPackage *)package{
    return [package toParams];
}

-(void)response:(HttpPackage *)package response:(NSObject *)response result:(void (^)(NSObject *, NSArray *))result fault:(void (^)(HttpError *))fault{
    
    NSString * resp;
    if (response != nil) {
        NSData * data = (NSData*)response;
        resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    if (resp == nil) {
        
        HttpError * e = [[HttpError alloc] initWithCode:-1];
        fault(e);
        return;
    }
    
    Json * json = [[Json alloc] initWithString:resp];
    if (json.isError) {
        HttpError * e = [[HttpError alloc] initWithCode:-0x11];
        fault(e);
        return;
    }
    int code = [json[@"code"] asInt:-0x12];
    if (code < 0) {
        HttpError * e =[[HttpError alloc] initWithCode:code];
        e.message = json[@"message"].asString;
        e.stackTrace = json[@"stackTrace"].asString;
        e.cause = json[@"cause"].asString;
        fault(e);
        return;
    }
    result([package getResult:json[@"result"]],nil);
}

@end


//        if response != nil {
//            let data = response as NSData
//            resp = NSString(data: data, encoding: NSUTF8StringEncoding)
//            //println("response: \(resp)") //prints the HTML of the page
//        }
//        if let resp = resp{
//            var json = Json(string:resp);
//            if json.isError{
//                //println("resp:"+resp);
////                if let fault = fault{
//                    var error = HttpError(code:-0x11);
//                    fault(error:error);
////                }
//                return;
//            }else{
//                var code = json["code"].asInt(def:-0x12);
//                if code < 0 {
//                    var error = HttpError(code:code)
//                    error.message = json["message"].asString;
//                    error.strackTrace = json["strackTrace"].asString;
//                    error.cause = json["cause"].asString;
//                    
//                    fault(error:error);
//                }else{
//                    result(obj:package.getResult(json["result"]),warning:[HttpError]());
//                }
//            }
//        }else{
//            var error = HttpError(code:-1);
//            fault(error:error);
////            fault(error:error);
//        }
//        
//    }
//}