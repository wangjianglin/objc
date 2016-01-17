//
//  Documents.m
//  LinUtil
//
//  Created by lin on 2/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//



#import "Documents.h"

NSString * pathFor(Documents document,NSString * path){
    
    
//    return nil;
//}

//
//public func pathFor(documents:Documents,path:String)->String?{
//
//    var filePath:String?;
//    switch(documents){
//
    NSString * filePath = nil;
    switch (document) {
        case DocumentsDocument:
            filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE)[0];
            break;
        case DocumentsCache:
            filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE)[0];
            break;
        case DocumentsTmp:
            filePath = NSTemporaryDirectory();
            break;
        case DocumentsLibrary:
            filePath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, TRUE)[0];
            break;
        case DocumentsBundle:
            return [[NSBundle mainBundle] pathForResource:path ofType:nil];
        default:
            break;
    }
    
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
    if (filePath != nil) {
        if (![filePath hasSuffix:@"/"]) {
            filePath = [[NSString alloc] initWithFormat:@"%@/",filePath];
        }
        if ([path hasPrefix:@"/"]) {
            filePath = [[NSString alloc] initWithFormat:@"%@%@",filePath,[path substringFromIndex:1]];
        }else{
            filePath = [[NSString alloc] initWithFormat:@"%@%@",filePath,path];
        }
    }
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
    return filePath;
//    return nil;
}
