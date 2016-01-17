//
//  UIBarButtonItems.swift
//  LinCore
//
//  Created by lin on 1/23/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


#import "UIBarButtonItems.h"
#import "LinUtil/util.h"


@implementation UIBarButtonItem(LinCore)


-(void)setDelegateAction:(void (^)(NSObject *))action{
    
    EventDelegateAction * delegateAction = [[EventDelegateAction alloc] initWithAction:action];
    delegateAction.withObjectSameLifecycle = self;
    self.target = delegateAction;
    self.action = @selector(action:);
    
}

-(void)removeDelegateAction{
    self.target = nil;
    self.action = nil;
}


@end