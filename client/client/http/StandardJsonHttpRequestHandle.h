//
//  StandardJsonHttpRequestHandle.h
//  LinClient
//
//  Created by lin on 12/3/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

//import Foundation
#import <Foundation/Foundation.h>
#import "HttpRequestHandle.h"


@interface StandardJsonHttpRequestHandle : NSObject<HttpRequestHandle>

@end

//#if !iOS7
//import LinUtil
//#endif
//
////
//// 采用标准HTTP请求方式传递请求参数，但返回的是json格式的数据
////
//public class StandardJsonHttpRequestHandle:HttpRequestHandle{
//    public func getParams(request:HttpTask,package:HttpPackage)->Dictionary<String,String>?{
//        return package.json.toParams();
//    }
//    
//    public func response(package:HttpPackage,response:AnyObject!,result:((obj:AnyObject!,warning:[HttpError])->()),fault:((error:HttpError)->())){
//        var resp:String? = nil;
//        
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