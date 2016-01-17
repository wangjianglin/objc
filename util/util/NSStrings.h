//
//  Strings.swift
//  LinUtil
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

//import Foundation
#import <Foundation/Foundation.h>

@interface NSString (LinUtil)

//@property(atomic,readonly) NSString * md5;
//@property(atomic,readonly) NSString * escaped;
-(NSString *)md5;

-(NSString*)escaped;
@end

//extension String {
//    public var md5 : String{
//        return md2WithString(self);
////        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
////        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
////        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
////        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
////        
////        CC_MD5(str!, strLen, result);
////        
////        var hash = NSMutableString();
////        for i in 0 ..< digestLen {
////            hash.appendFormat("%02x", result[i]);
////        }
////        result.destroy();
////        
////        return String(format: hash)
//    }
//}