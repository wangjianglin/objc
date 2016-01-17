//
//  LinImagesController.h
//  seller
//
//  Created by lin on 12/28/14.
//  Copyright (c) 2014 lin. All rights reserved.
//
//

#import <UIKit/UIKit.h>

#import "QBImagePicker.h"
#import "ImageViews.h"

//typedef NS_ENUM(NSUInteger, LinImagesFill) {
//    LinImagesFillDefault,    // currently UISearchBarStyleProminent
//    LinImagesFillFill,  // used my Mail, Messages and Contacts
//    LinImagesFillWithWidth,
//    LinImagesFillWithHeight// used by Calendar, Notes and Music
//} ;

@interface ScrollImagesView : UIView{
//    @package
//    UIViewController * controller;
}
//@property(assign) UIViewController * controller;
@property BOOL edited;

@property BOOL fullScreen;
//    //使图像填满
//@property BOOL fill;
@property ImageFill fill;
//
//    //缩放
@property BOOL zoom;
//
//    //是否显示位置标记
@property BOOL showPositionLabel;

@property(readonly) NSArray * imagesForEdited;

@property(readonly) NSArray * images;
@property NSURL * vedioUrl;
@property BOOL hasVedio;
@property NSObject * vedioImage;
@property NSArray * imagePaths;

@property NSString * noImage;
@end

//@interface LinImagesController : UIViewController
//
//@property BOOL edited;
//
//@property(readonly) NSArray* imagesForEdited;
//
//@property(readonly) NSArray * images;
//@property NSURL * vedioUrl;
//@property BOOL hasVedio;
//@property NSArray * imagePaths;
////    
////    //是否可以全屏
//@property BOOL fullScreen;
////    
////    //使图像填满
////@property BOOL fill;
//@property LinImagesFill fill;
////    //缩放
//@property BOOL zoom;
////    
////    //是否显示位置标记
//@property BOOL showPositionLabel;
//
//@property NSString * noImage;
//
//@end