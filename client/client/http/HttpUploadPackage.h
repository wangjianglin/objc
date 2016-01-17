//
//  HttpUploadPackage.h
//  LinClient
//
//  Created by lin on 2/7/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "HttpPackage.h"

@interface HttpUploadPackage : HttpPackage

//-(id)initWithUrl:(NSString *)url;{
//    
//}
//
//public init(url:String){
//    _files = Dictionary<String,HttpUpload>();
//    super.init(url: url, method: HttpMethod.POST);
//    //        self._json = JSON();
//    //handle = HttpUploadPackage.FILE_UPLOAD_HANDLE;
//    //handle = HttpPackage.STANDARD_HANDLE;
//    //handle = HttpPackage.ENCRYPT_JSON_HANDLE;
//    
//    //        self._url = url;
//    //        self._method = method;
//}
//
//public class var FILE_UPLOAD_HANDLE:HttpRequestHandle {
//    
//    struct YRSingleton{
//        static var predicate:dispatch_once_t = 0
//        static var instance:FileUploadHttpRequestHandle? = nil
//    }
//    dispatch_once(&YRSingleton.predicate,{
//        YRSingleton.instance = FileUploadHttpRequestHandle()
//    })
//    return YRSingleton.instance!
//}
//
//
@property void (^progress)(int64_t,int64_t);
//
//private var _files:Dictionary<String,HttpUpload>;
//
@property(readonly) NSDictionary * files;
//internal var files:Dictionary<String,HttpUpload>{
//    return _files;
//}
//
//public func addFile(name:String,file:String){
//    _files[name] = HttpUpload(fileUrl: NSURL(fileURLWithPath: file)!);
//}
-(void)addFile:(NSString*)name file:(NSString*)file;
//
//public func addFile(name:String,data: NSData, fileName: String, mimeType: String){
//    _files[name] = HttpUpload(data: data, fileName: fileName, mimeType: mimeType);
//}
-(void)addFile:(NSString*)name data:(NSData*)data filename:(NSString*)filename mimeType:(NSString*)mimeType;

-(HttpUpload*)getFile:(NSString*)name;
//
//public func getFile(name:String)->HttpUpload?{
//    return _files[name];
//}
//
-(void)remove:(NSString*)name;
//public func remove(name:String){
//    _files.removeValueForKey(name);
//}
@end
