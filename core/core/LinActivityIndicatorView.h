//
//  LinActivityIndicatorView.h
//  LinControls
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface LinActivityIndicatorView : UIView


@property(readonly) UILabel * label;

@property UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property BOOL hidesWhenStopped;

@property UIColor* color;

-(void)startAnimating;

-(void)stopAnimating;

-(BOOL)isAnimating;

-(void)remove;

@end