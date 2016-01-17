//
//  Images.m
//  LinCore
//
//  Created by lin on 1/14/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "Images.h"

@implementation UIImage(LinCore)

-(UIImage *)scaledToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)scaledToSize:(CGSize)size fill:(BOOL)fill{
    
    CGFloat s = 1.0;
//    CGFloat offsetX = 0.0;
//    CGFloat offsetY = 0.0;
    if (!fill) {
        s = (self.size.width/self.size.height)/(size.width/size.height);
    }
    
    if (s > 1) {
        size.height = size.height / s;
//        offsetY = (self.size.height - size.height) / 2;
    }else{
        size.width = size.width * s;
//        offsetX = (self.size.width - size.width) / 2;
    }
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)imageWithURLString:(NSString*)url{
    return [UIImage imageWithURL:[NSURL URLWithString:url]];
}
+(UIImage*)imageWithURL:(NSURL*)url{
    NSData * data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}


+(id)imageWithColor:(UIColor *)color{
    //    return [[ColorImage alloc] initWithColor:color];
    
    CGSize imageSize = CGSizeMake(100, 100);
//    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
//    [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] set];
//    [color set];
    
//    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
//    CGContextStrokeEllipseInRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

@end


//@interface ColorImage(){
//    CIColor * _color;
//}
//
//@end
//
//@implementation ColorImage
//
//
//+(id)imageWithColor:(UIColor *)color{
////    return [[ColorImage alloc] initWithColor:color];
//    
//    CGSize imageSize = CGSizeMake(50, 50);
//    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
//    [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] set];
//    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
//    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//}
//
//-(id)initWithColor:(UIColor *)color{
//    self = [super init];
//    if (self) {
//        _color = [CIColor colorWithCGColor:color.CGColor];
//    }
//    return self;
//}
//
////-d
//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context{
////-(void)drawRect:(CGRect)rect{
////
////}
////-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context{
//    CGContextSetRGBFillColor(context, _color.red,_color.green,_color.blue,_color.alpha);
//    CGContextFillRect(context, CGContextGetClipBoundingBox(context));
//}
//
////-(UIImageResizingMode)resizingMode{
////    UIImageResizingMode
////}
//
//-(CGSize)size{
//    return CGSizeMake(100, 100);
//}
//@end
