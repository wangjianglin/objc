//
//  Images.h
//  LinCore
//
//  Created by lin on 1/14/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (LinCore)

-(UIImage*)scaledToSize:(CGSize)size;

-(UIImage *)scaledToSize:(CGSize)size fill:(BOOL)fill;

//[UIImage imageWithData:[LinURLCacheProtocol ]
+(UIImage*)imageWithURLString:(NSString*)url;
+(UIImage*)imageWithURL:(NSURL*)url;
+imageWithColor:(UIColor*)color;
@end


//@interface ColorImage : UIImage
//
//-initWithColor:(UIColor*)color;
//+imageWithColor:(UIColor*)color;
//
//@end