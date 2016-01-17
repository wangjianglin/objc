//
//  CDVCacheURLProtocol.h
//  web
//
//  Created by lin on 14-6-15.
//
//

#import <UIKit/UIKit.h>

@interface LinURLCacheProtocol : NSURLProtocol
+ (void)cache:(NSString*)url;
+ (void)remove:(NSString*)url;
+ (NSString*)cachePath;
+ (void)setCachePath:(NSString*)path;
//+ (void)setCacheSize:(long)size;
@end
