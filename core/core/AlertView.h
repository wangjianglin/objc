//
//  AlertView.swift
//  LinControls
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertView : NSObject

+(void)show:(NSString*)titie message:(NSString*)message buttonTitle:(NSString*)buttonTitle;

+(void)show:(NSString*)message;


@end

@interface UIAlertView (LinCore)


@property void(^clickedButtonAtIndexAction)(UIAlertView * alertView,NSInteger buttonIndex);

@property void(^alertViewCancelAction)(UIAlertView*alertView) ;

@property void(^willPresentAlertViewAction)(UIAlertView * alertView);

@property void(^didPresentAlertViewAction)(UIAlertView * alertView);

@property void(^willDismissWithButtonIndexAction)(UIAlertView * alertView,NSInteger buttonIndex);

@property void(^didDismissWithButtonIndexAction)(UIAlertView * alertView,NSInteger buttonIndex);

@property BOOL(^alertViewShouldEnableFirstOtherButtonAction)(UIAlertView *alertView);

@end

