//
//  UIGestureRecognizers.swift
//  LinCore
//
//  Created by lin on 1/22/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinUtil/util.h"


@implementation UIGestureRecognizer (LinCore)

-(instancetype)initWithAction:(void(^)(NSObject*))action{
    EventDelegateAction * deleagateAction = [[EventDelegateAction alloc] initWithAction:action];
    self = [self initWithTarget:deleagateAction action:@selector(action:)];
    deleagateAction.withObjectSameLifecycle = self;
    return self;
}
@end