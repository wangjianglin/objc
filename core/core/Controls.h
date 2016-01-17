//
//  Buttons.swift
//  LinCore
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIControl (Actions)


-(void)addActionForEvent:(UIControlEvents)event action:(void(^)(NSObject*))action;

@end