//
//  Documents.h
//  LinUtil
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

//import Foundation
#import <Foundation/Foundation.h>
//
//public enum Documents{
//    case Document,Tmp,Cache,Library,Bundle
//}

#ifndef LinUtil_Documents_m
#define LinUtil_Documents_m

typedef enum {
    DocumentsDocument,DocumentsTmp,DocumentsCache,DocumentsLibrary,DocumentsBundle
} Documents;

NSString * pathFor(Documents document,NSString * path);

#endif
//
//public func pathFor(documents:Documents,path:String)->String?{
//
//    var filePath:String?;
//    switch(documents){
//
//    case .Document:
//        filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask,true)![0] as? String;
//
//    case .Cache:
//        filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,NSSearchPathDomainMask.UserDomainMask,true)![0] as? String;
//
//    case .Tmp:
//        filePath = NSTemporaryDirectory();
//
//    case .Library:
//        filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory,NSSearchPathDomainMask.UserDomainMask,true)![0] as? String;
//    case .Bundle:
//        var mainBundle:NSBundle = NSBundle.mainBundle();
//        return mainBundle.pathForResource(path, ofType: nil);
//    default:
//        break;
//    }
//    if var fPath = filePath {
//        if !fPath.hasSuffix("/") {
//            fPath = "\(fPath)/";
//        }
//        
//        if path.hasPrefix("/") {
//            filePath = "\(fPath)\((path as NSString).substringFromIndex(1))";
//        }else{
//            filePath = "\(fPath)\(path)";
//        }
//    }
//    return filePath;
//}