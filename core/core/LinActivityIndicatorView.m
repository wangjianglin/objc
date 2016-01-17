//
//  LinActivityIndicatorView.swift
//  LinControls
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinActivityIndicatorView.h"

@interface LinActivityIndicatorView (){
    @private
    UIActivityIndicatorView * indicator;
}

@end
@implementation LinActivityIndicatorView


-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [indicator setBackgroundColor:backgroundColor];
    super.backgroundColor = backgroundColor;
}

-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (self) {
        super.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = true;
        self->indicator = [[UIActivityIndicatorView alloc] init];
        self->indicator.backgroundColor = [UIColor clearColor];
        
        [self->indicator startAnimating];
        self->indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        
        self->_label = [[UILabel alloc] init];
        self->_label.backgroundColor = [UIColor clearColor];
        self->_label.textAlignment = NSTextAlignmentCenter;
        self->_label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12.0];
        [self addSubview:indicator];
        self.backgroundColor = [[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:0.3];
        
        
        _label.frame = CGRectMake(0, 80, 100, 25);
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:self->_label];
    }
    return self;
}

-(UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    return indicator.activityIndicatorViewStyle;
}
-(void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    indicator.activityIndicatorViewStyle = activityIndicatorViewStyle;
}

-(BOOL)hidesWhenStopped{
    return indicator.hidesWhenStopped;
}
-(void)setHidesWhenStopped:(BOOL)hidesWhenStopped{
    indicator.hidesWhenStopped = hidesWhenStopped;
}

-(UIColor *)color{
    return indicator.color;
}
-(void)setColor:(UIColor *)color{
    indicator.color = color;
}

-(void)startAnimating{
    [indicator startAnimating];
}

-(void)stopAnimating{
    [indicator stopAnimating];
}

-(BOOL)isAnimating{
    return indicator.isAnimating;
}

-(void)layoutSubviews{
    UIView * superView = self.superview;
    if (superView != nil) {
        self.frame = superView.bounds;
        indicator.center = CGPointMake(superView.bounds.size.width*0.5, superView.bounds.size.height*0.5);
    }
    [super layoutSubviews];
}

-(void)remove{
    [indicator stopAnimating];
    [self removeFromSuperview];
}


@end