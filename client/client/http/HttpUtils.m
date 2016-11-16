//
//  HttpUtils.m
//  LinClient
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HttpUtils.h"
#import "HttpCommunicate.h"


@implementation HttpUtils

+(uint)timestamp{
    return 0;
}
+(uint)sequeue{
    return 0;
}

+(NSString*)url:(HttpCommunicateImpl*)impl pack:(HttpPackage*)pack{
    
    if([pack.url hasPrefix:@"http://"]
       ||[pack.url hasPrefix:@"https://"]){
        return pack.url;
    }
//    NSString * curl = impl.commUrl;
    NSMutableString * curl = [[NSMutableString alloc] init];
    [curl appendString:impl.commUrl];
    //        //var commUriString = "";
    //        if pack.url.hasPrefix("/"){
    if (pack.url == nil) {
        return curl;
    }
    if ([pack.url hasPrefix:@"/"]) {
        [curl appendString:[pack.url substringFromIndex:1]];
    }else{
        [curl appendString:pack.url];
    }
    if (!pack.enableCache) {
        if ([curl rangeOfString:@"?"].length != 0) {
            [curl appendString:@"&"];
        }else{
            [curl appendString:@"?"];
        }
        [curl appendString:[[NSString alloc] initWithFormat:@"_time_stamp_%f%d=%d",[[NSDate alloc] init].timeIntervalSince1970 * 1000,arc4random()*200,arc4random()*200]];
    }
    //            curl += pack.url.substringFromIndex(advance(pack.url.startIndex, 1))
    //        }else{
    //            curl += pack.url;
    //        }
    //
    //        if !pack.enableCache{
    //            if curl.rangeOfString("?") != nil {
    //                curl += "&_time_stamp_\(NSDate().timeIntervalSince1970 * 100000)=1";
    //            }else{
    //                curl += "?_time_stamp_\(NSDate().timeIntervalSince1970 * 100000)=1";
    //            }
    //        }
    //        
    //        return curl;
    
    return curl;
}

@end

//import Foundation
//
//
//class HttpUtils {
//    
//    class var timestamp:UInt{
//        return 0;
//    }
//    
//    class var sequeue:UInt {
//        get{
//            return 0;
//        }
//    }
//    
//    
//    class func url(impl:HttpCommunicateImpl,pack:HttpPackage)->String {
//    
//
//    }
//}
