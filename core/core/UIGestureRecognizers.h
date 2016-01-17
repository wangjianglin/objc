//
//  UIGestureRecognizers.swift
//  LinCore
//
//  Created by lin on 1/22/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


@interface UIGestureRecognizer (LinCore)

-(instancetype)initWithAction:(void(^)(NSObject*))action;
@end