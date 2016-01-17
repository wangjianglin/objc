//
//  HttpUtils.h
//  LinClient
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HttpCommunicate.h"
#import "HttpPackage.h"

@interface HttpUtils : NSObject

+(uint)timestamp;
+(uint)sequeue;

+(NSString*)url:(HttpCommunicateImpl*)impl pack:(HttpPackage*)pack;
@end

//    
//    class func url(impl:HttpCommunicateImpl,pack:HttpPackage)->String {
//    
//        var curl = impl.commUrl;
//        //var commUriString = "";
//        if pack.url.hasPrefix("/"){
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
//    }
//}