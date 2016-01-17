//
//  HttpUploadPackage.m
//  LinClient
//
//  Created by lin on 2/7/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "HttpUploadPackage.h"


@interface HttpUploadPackage(){
    @private
    void (^_progress)(int64_t,int64_t);
    NSMutableDictionary * _files;
}

@end

@implementation HttpUploadPackage

-(void (^)(int64_t, int64_t))progress{
    return self->_progress;
}

-(void)setProgress:(void (^)(int64_t, int64_t))progress{
    self->_progress = progress;
}


-(id)initWithUrl:(NSString *)url{
    self = [super initWithUrl:url];
    if (self) {
        self->_files = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(id)initWithUrl:(NSString *)url method:(HttpMethod)method{
    self = [super initWithUrl:url method:method];
    if (self) {
        self->_files = [[NSMutableDictionary alloc] init];
    }
    return self;
}

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
//public var progress:((send:Int64,total:Int64) -> Void)!;
//
//private var _files:Dictionary<String,HttpUpload>;
//
//internal var files:Dictionary<String,HttpUpload>{
//    return _files;
//}

-(NSDictionary *)files{
    return self->_files;
}

//
-(void)addFile:(NSString *)name file:(NSString *)file{
//    _files[@""] = [[HttpUpload alloc] initWithFileUrl:[[NSURL alloc] initFileURLWithPath:file]];
    [_files setValue:[[HttpUpload alloc] initWithFileUrl:[[NSURL alloc] initFileURLWithPath:file]] forKey:name];
}
//public func addFile(name:String,file:String){
//    _files[name] = HttpUpload(fileUrl: NSURL(fileURLWithPath: file)!);
//}
//

-(void)addFile:(NSString *)name data:(NSData *)data filename:(NSString *)filename mimeType:(NSString *)mimeType{
    _files[name] = [[HttpUpload alloc] initWithData:data fileName:filename mimeType:mimeType];
}
//public func addFile(name:String,data: NSData, fileName: String, mimeType: String){
//    _files[name] = HttpUpload(data: data, fileName: fileName, mimeType: mimeType);
//}
//
-(HttpUpload*)getFile:(NSString *)name{
    return [_files valueForKey:name];
}
//public func getFile(name:String)->HttpUpload?{
//    return _files[name];
//}
//
//public func remove(name:String){
//    _files.removeValueForKey(name);
//}
-(void)remove:(NSString *)name{
//    _files rem
}
@end
