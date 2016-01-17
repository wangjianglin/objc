//
//  HttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

//import Foundation
//
//
//public protocol HttpRequestHandle{
//    
//    func getParams(request:HttpTask,package:HttpPackage)->Dictionary<String,String>?;
//    
//    func response(package:HttpPackage,response:AnyObject!,result:((obj:AnyObject!,warning:[HttpError])->()),fault:((error:HttpError)->()) );
//}

#import <Foundation/Foundation.h>
#import "HttpTask.h"
#import "HttpPackage.h"
#import "HttpCommunicate.h"


@class HttpPackage;
@class HttpError;

@protocol HttpRequestHandle

-(NSDictionary*)getParams:(HttpTask *)request package:(HttpPackage * )package;

-(void)response:(HttpPackage*)package response:(NSObject*)response result:(void(^)(NSObject*,NSArray*))result fault:(void(^)(HttpError *))fault;

@end
