//
//  UIBarButtonItems.swift
//  LinCore
//
//  Created by lin on 1/23/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <UIKIt/UIKit.h>

@interface UIBarButtonItem (LinCore)


-(void)setDelegateAction:(void(^)(NSObject*))action;

-(void)removeDelegateAction;

@end